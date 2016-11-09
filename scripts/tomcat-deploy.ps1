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

# Clean out tomcat deployment directory
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

# Deploy the Proxy Node
Copy-Item "$project_root/EIDAS-Node/target/EidasNode.war" "$env:CATALINA_HOME/webapps/ProxyNode.war"

# ---------------------------
# Environment Variables
# ---------------------------

$env:EIDAS_CONFIG_REPOSITORY="$project_root"/EIDAS-Config/

# Stub SP
$env:STUB_SP_KEYSTORE="$project_root/EIDAS-SP/target/SP/WEB-INF/eidasKeystore.jks"
$env:STUB_SP_KEYSTORE_PASSWORD="local-demo"
$env:STUB_SP_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=local-demo-cert, OU=DIGIT, O=European Comission, L=Brussels, ST=Belgium, C=BE"
$env:STUB_SP_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="54d8a000"
$env:STUB_SP_SIGNING_CERTIFICATE_DISTINGUSHED_NAME="CN=local-demo-cert, OU=DIGIT, O=European Comission, L=Brussels, ST=Belgium, C=BE"
$env:STUB_SP_SIGNING_CERTIFICATE_SERIAL_NUMBER="54d8a000"

# Nodes
$env:NODE_KEYSTORE="$project_root/EIDAS-Node/target/EidasNode/WEB-INF/eidasKeystore.jks"
$env:NODE_KEYSTORE_PASSWORD="local-demo"

$env:NODE_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=local-demo-cert, OU=DIGIT, O=European Comission, L=Brussels, ST=Belgium, C=BE"
$env:NODE_SIGNING_CERTIFICATE_DISTINGUISHED_NAME="CN=local-demo-cert, OU=DIGIT, O=European Comission, L=Brussels, ST=Belgium, C=BE"

$env:NODE_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="54d8a000"
$env:NODE_SIGNING_CERTIFICATE_SERIAL_NUMBER="54d8a000"

# Stub IdP
$env:STUB_IDP_KEYSTORE="$project_root/EIDAS-IdP-1.0/target/IdP/WEB-INF/eidasKeystore.jks"
$env:STUB_IDP_KEYSTORE_PASSWORD="local-demo"
$env:STUB_IDP_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=local-demo-cert, OU=DIGIT, O=European Comission, L=Brussels, ST=Belgium, C=BE"
$env:STUB_IDP_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="54d8a000"
$env:STUB_IDP_SIGNING_CERTIFICATE_DISTINGUISHED_NAME="CN=local-demo-cert, OU=DIGIT, O=European Comission, L=Brussels, ST=Belgium, C=BE"
$env:STUB_IDP_SIGNING_CERTIFICATE_SERIAL_NUMBER="54d8a000"

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
