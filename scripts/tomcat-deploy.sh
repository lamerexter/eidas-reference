#!/usr/bin/env bash

project_root=$(dirname "$0")/..

# ---------------------------
# Tomcat setup
# ---------------------------

if hash catalina 2>/dev/null; then
  CATALINA_HOME=$(catalina  | grep CATALINA_HOME | awk '{ print $NF }')
  if [ ! -d "$CATALINA_HOME" ]; then
    >&2 echo "Error: Value for CATALINA_HOME ('$CATALINA_HOME') does not point to a directory."
    >&2 echo "Is your tomcat installation setup correctly?"
    exit 1
  fi
else
  >&2 echo "Error: Could not find a 'catalina' executable on the PATH. Do you have tomcat installed?"
  exit 1
fi

# ---------------------------
# Build
# ---------------------------

mvn --file "$project_root"/EIDAS-Parent clean install -P embedded -P coreDependencies -Dmaven.test.skip=true

# ---------------------------
# Deploy
# ---------------------------

# Deploy the SP
cp "$project_root"/EIDAS-SP/target/SP.war "$CATALINA_HOME/webapps"

# Deploy the Connector Node
cp "$project_root"/EIDAS-Node/target/EidasNode.war "$CATALINA_HOME/webapps/ConnectorNode.war"

# Deploy the Proxy Node
cp "$project_root"/EIDAS-Node/target/EidasNode.war "$CATALINA_HOME/webapps/ProxyNode.war"

# Deploy the IdP
cp "$project_root"/EIDAS-IdP-1.0/target/IdP.war "$CATALINA_HOME/webapps"

# ---------------------------
# Environment Variables
# ---------------------------

export EIDAS_CONFIG_REPOSITORY="$project_root"/EIDAS-Config/

# Stub SP
export STUB_SP_KEYSTORE="$project_root/EIDAS-SP/target/SP/WEB-INF/eidasKeystore.jks"
export STUB_SP_KEYSTORE_PASSWORD="local-demo"
export STUB_SP_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=local-demo-cert, OU=DIGIT, O=European Comission, L=Brussels, ST=Belgium, C=BE"
export STUB_SP_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="54d8a000"
export STUB_SP_SIGNING_CERTIFICATE_DISTINGUSHED_NAME="CN=local-demo-cert, OU=DIGIT, O=European Comission, L=Brussels, ST=Belgium, C=BE"
export STUB_SP_SIGNING_CERTIFICATE_SERIAL_NUMBER="54d8a000"

# Nodes
export NODE_KEYSTORE="$project_root/EIDAS-Node/target/EidasNode/WEB-INF/eidasKeystore.jks"
export NODE_KEYSTORE_PASSWORD="local-demo"

export NODE_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=local-demo-cert, OU=DIGIT, O=European Comission, L=Brussels, ST=Belgium, C=BE"
export NODE_SIGNING_CERTIFICATE_DISTINGUISHED_NAME="CN=local-demo-cert, OU=DIGIT, O=European Comission, L=Brussels, ST=Belgium, C=BE"

export NODE_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="54d8a000"
export NODE_SIGNING_CERTIFICATE_SERIAL_NUMBER="54d8a000"

# Stub IdP
export STUB_IDP_KEYSTORE="$project_root/EIDAS-IdP-1.0/target/IdP/WEB-INF/eidasKeystore.jks"
export STUB_IDP_KEYSTORE_PASSWORD="local-demo"
export STUB_IDP_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=local-demo-cert, OU=DIGIT, O=European Comission, L=Brussels, ST=Belgium, C=BE"
export STUB_IDP_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="54d8a000"
export STUB_IDP_SIGNING_CERTIFICATE_DISTINGUISHED_NAME="CN=local-demo-cert, OU=DIGIT, O=European Comission, L=Brussels, ST=Belgium, C=BE"
export STUB_IDP_SIGNING_CERTIFICATE_SERIAL_NUMBER="54d8a000"

# URLs
export SP_URL='http://127.0.0.1:8080/SP'
export CONNECTOR_URL='http://127.0.0.1:8080/ConnectorNode'
export PROXY_URL='http://127.0.0.1:8080/ProxyNode'
export NODE_METADATA_SSO_LOCATION='http://127.0.0.1:8080/ProxyNode/ColleagueRequest'
export IDP_URL='http://127.0.0.1:8080/IdP'
export IDP_SSO_URL='https://127.0.0.1:8080/IdP'

# ---------------------------
# Start Tomcat
# ---------------------------

catalina run

