#!/usr/bin/env bash

. "$(dirname $0)/tomcat-variables.sh"

export EIDAS_CONFIG_REPOSITORY=./EIDAS-Config/

export NODE_KEYSTORE="./EIDAS-Node/target/EidasNode/WEB-INF/proxyNodeKeystore.jks"
export NODE_KEYSTORE_PASSWORD="Password"

export NODE_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Proxy Encryption 20262026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
export NODE_SIGNING_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Proxy Metadata Signing 20262026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"

export NODE_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="6642726bee633fb628dbd85b7d42e63b62046c2d"
export NODE_SIGNING_CERTIFICATE_SERIAL_NUMBER="203b6cb0724922c675e08606287e75c4c4457a2c"

export SERVICE_METADATA_URL="http://localhost:$COUNTRY_2_PROXY_NODE_HTTP_PORT/ServiceMetadata"
export CONNECTOR_URL="http://localhost:$CONNECTOR_NODE_HTTP_PORT"
export PROXY_URL="http://localhost:$COUNTRY_2_PROXY_NODE_HTTP_PORT"
export EXT_PROXY_URL="http://localhost:$COUNTRY_2_PROXY_NODE_HTTP_PORT"
export NODE_METADATA_SSO_LOCATION="http://localhost:$COUNTRY_2_PROXY_NODE_HTTP_PORT/ColleagueRequest"
export IDP_URL="http://localhost:$COUNTRY_2_STUB_IDP_HTTP_PORT"
export EXT_IDP_URL="http://localhost:$COUNTRY_2_STUB_IDP_HTTP_PORT"
export IDP_SSO_URL="http://localhost:$COUNTRY_2_STUB_IDP_HTTP_PORT"
export EXT_CONNECTOR_URL=''
export SP_URL=''
export EXT_SP_URL=''

# Shouldn't need this for the Proxy, but set it to empty to stop the variable replacement complaining:
export COUNTRY_1_CODE=''
export COUNTRY_1_NAME=''
export COUNTRY_1_PROXY_URL=''
export COUNTRY_2_CODE=''
export COUNTRY_2_NAME=''
export COUNTRY_2_PROXY_URL=''
export COUNTRY_3_CODE=''
export COUNTRY_3_NAME=''
export COUNTRY_3_PROXY_URL=''
export COUNTRY_4_CODE=''
export COUNTRY_4_NAME=''
export COUNTRY_4_PROXY_URL=''
export COUNTRY_5_CODE=''
export COUNTRY_5_NAME=''
export COUNTRY_5_PROXY_URL=''
export COUNTRY_6_CODE=''
export COUNTRY_6_NAME=''
export COUNTRY_6_PROXY_URL=''
export COUNTRY_7_CODE=''
export COUNTRY_7_NAME=''
export COUNTRY_7_PROXY_URL=''
