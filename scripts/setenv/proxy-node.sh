#!/usr/bin/env bash

. "$(dirname $0)/tomcat-variables.sh"

export EIDAS_CONFIG_REPOSITORY=./EIDAS-Config/

export NODE_KEYSTORE="./EIDAS-Node/target/EidasNode/WEB-INF/proxyNodeKeystore.jks"
export NODE_KEYSTORE_PASSWORD="Password"

export NODE_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Proxy Encryption 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
export NODE_SIGNING_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Proxy Metadata Signing 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"

export NODE_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="6641716bee633fb618dbd85b7d41e63b62046c2d"
export NODE_SIGNING_CERTIFICATE_SERIAL_NUMBER="203b6cb0714922c675e08606187e75c4c4457a1c"

export SERVICE_METADATA_URL="http://localhost:$PROXY_NODE_HTTP_PORT/ServiceMetadata"
export CONNECTOR_URL="http://localhost:$CONNECTOR_NODE_HTTP_PORT"
export PROXY_METADATA_URL="http://localhost:$PROXY_NODE_HTTP_PORT/ServiceMetadata"
export PROXY_URL="http://localhost:$PROXY_NODE_HTTP_PORT"
export NODE_METADATA_SSO_LOCATION="http://localhost:$PROXY_NODE_HTTP_PORT/ColleagueRequest"
export IDP_URL="http://localhost:$STUB_IDP_HTTP_PORT"
export IDP_SSO_URL="http://localhost:$STUB_IDP_HTTP_PORT"

# Shouldn't need this for the Proxy, but set it to empty to stop the variable replacement complaining:
export SP_URL=''
