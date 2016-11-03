if (!$env:CATALINA_HOME) {
  Write-Error "Please provide a value for the CATALINA_HOME environment variable."
  exit 1
}

$scriptPath = $MyInvocation.MyCommand.Definition
$parentPath = Split-Path -parent $scriptPath
$project_root = Split-Path -parent $parentPath

# ---------------------------
# Build
# ---------------------------

mvn clean install -file "$project_root/EIDAS-Parent" -P embedded -P coreDependencies -D maven.test.skip=true

# ---------------------------
# Stop Tomcat
# ---------------------------

Invoke-Expression "$env:CATALINA_HOME\bin\shutdown.bat"

#Clean out tomcat deployment directory
Remove-Item $env:CATALINA_HOME\webapps\*.war
Remove-Item $env:CATALINA_HOME\webapps\SP -Recurse
Remove-Item $env:CATALINA_HOME\webapps\ConnectorNode -Recurse
Remove-Item $env:CATALINA_HOME\webapps\ProxyNode -Recurse
Remove-Item $env:CATALINA_HOME\webapps\IdP -Recurse

# ---------------------------
# Deploy
# ---------------------------

# Deploy the SP
Copy-Item "$project_root/EIDAS-SP/target/SP.war" "$env:CATALINA_HOME/webapps"

# Deploy the Connector Node
Copy-Item "$project_root/EIDAS-Node/target/EidasNode.war" "$env:CATALINA_HOME/webapps/ConnectorNode.war"


# Deploy the IdP
Copy-Item "$project_root/EIDAS-IdP-1.0/target/IdP.war" "$env:CATALINA_HOME/webapps"


# Hack - reconfigure the Node to be a proxy node instead of a connector node
$files = Get-ChildItem -Recurse -include "*.xml"| Select-String "CONNECTOR_NODE_KEYSTORE" -List | Select -unique Path

foreach ($file in $files) {
    Copy-Item $file.Path ($file.Path + ".backup")
    (Get-Content $file.Path) | Foreach-Object { $_ -replace '${NODE_', '${PROXY_NODE_' } | Set-Content $file.Path
}

# Build proxy node
mvn clean install -file "$project_root/EIDAS-Parent" -P embedded -P coreDependencies -D maven.test.skip=true


# Deploy the Proxy Node
Copy-Item "$project_root/EIDAS-Node/target/EidasNode.war" "$env:CATALINA_HOME/webapps/ProxyNode.war"

#change back the Node configs to Connector Node
$files = Get-ChildItem -Recurse -include "*.xml"| Select-String "PROXY_NODE_KEYSTORE" -List | Select -unique Path
foreach ($file in $files)
{
    Remove-Item $file.Path
    Move-Item ($file.Path + ".backup") $file.Path    
}

# ---------------------------
# Environment Variables
# ---------------------------

$env:EIDAS_CONFIG_REPOSITORY="$project_root"/EIDAS-Config/

# Stub SP
$env:STUB_SP_KEYSTORE="$project_root/EIDAS-Node/target/EidasNode/WEB-INF/stubSpKeystore.jks"
$env:STUB_SP_KEYSTORE_PASSWORD="Password"
$env:STUB_SP_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Stub SP Encryption 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
$env:STUB_SP_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="41573ab34ef7100cb77e4c5aca551826cf86a1e9"
$env:STUB_SP_SIGNING_CERTIFICATE_DISTINGUSHED_NAME="CN=Test Stub SP Metadata Signing 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
$env:STUB_SP_SIGNING_CERTIFICATE_SERIAL_NUMBER="123f7141d99aa3b6ad31211dabb9ca7abdc08b5d"

# Connector Node
$env:NODE_KEYSTORE="$project_root/EIDAS-Node/target/EidasNode/WEB-INF/connectorNodeKeystore.jks"
$env:NODE_KEYSTORE_PASSWORD="Password"

$env:NODE_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Connector Encryption 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
$env:NODE_SIGNING_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Connector Metadata Signing 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"

$env:NODE_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="1dcfdeedc8983a5f13f2338e0814b6e47090b3d7"
$env:NODE_SIGNING_CERTIFICATE_SERIAL_NUMBER="56520de46a76cb6ad7b9c238dd253d88904da9d8"

# Proxy Node
# Hack: PROXY_* variables are only needed for running locally due to instances running in
# the same application and therefore getting the same environment variables:
$env:PROXY_NODE_KEYSTORE="$project_root/EIDAS-Node/target/EidasNode/WEB-INF/proxyNodeKeystore.jks"
$env:PROXY_NODE_KEYSTORE_PASSWORD="Password"

$env:PROXY_NODE_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Proxy Encryption 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
$env:PROXY_NODE_SIGNING_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Proxy Metadata Signing 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"

$env:PROXY_NODE_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="6641716bee633fb618dbd85b7d41e63b62046c2d"
$env:PROXY_NODE_SIGNING_CERTIFICATE_SERIAL_NUMBER="203b6cb0714922c675e08606187e75c4c4457a1c"

# Stub IdP
$env:STUB_IDP_KEYSTORE="$project_root/EIDAS-Node/target/EidasNode/WEB-INF/stubIdpKeystore.jks"
$env:STUB_IDP_KEYSTORE_PASSWORD="Password"
$env:STUB_IDP_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Stub IdP Encryption 20161031, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
$env:STUB_IDP_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="723c0f7f4b45dea5296e53f565535174d0df5218"
$env:STUB_IDP_SIGNING_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Stub IdP Metadata Signing 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
$env:STUB_IDP_SIGNING_CERTIFICATE_SERIAL_NUMBER="5ae2153c3f9a99824df394abd65f9e1e8ca53365"

# URLs
$env:SP_URL='http://127.0.0.1:8080/SP'
$env:CONNECTOR_URL='http://127.0.0.1:8080/ConnectorNode'
$env:PROXY_URL='http://127.0.0.1:8080/ProxyNode'
$env:NODE_METADATA_SSO_LOCATION='http://127.0.0.1:8080/ProxyNode/ColleagueRequest'
$env:IDP_URL='http://127.0.0.1:8080/IdP'
$env:IDP_SSO_URL='https://127.0.0.1:8080/IdP'

# ---------------------------
# Start Tomcat
# ---------------------------

Invoke-Expression "$env:CATALINA_HOME\bin\startup.bat"
