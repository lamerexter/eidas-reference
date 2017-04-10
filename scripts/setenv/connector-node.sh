#!/usr/bin/env bash

. "$(dirname $0)/tomcat-variables.sh"

export EIDAS_CONFIG_REPOSITORY=./EIDAS-Config/

export NODE_KEYSTORE="./EIDAS-Node/target/EidasNode/WEB-INF/connectorNodeKeystore.jks"
export NODE_KEYSTORE_PASSWORD="Password"

export NODE_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Connector Encryption 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
export NODE_SIGNING_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Connector Metadata Signing 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"

export NODE_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="1dcfdeedc8983a5f13f2338e0814b6e47090b3d7"
export NODE_SIGNING_CERTIFICATE_SERIAL_NUMBER="56520de46a76cb6ad7b9c238dd253d88904da9d8"

export SP_URL="http://localhost:$STUB_SP_HTTP_PORT"
export EXT_SP_URL="http://localhost:$STUB_SP_HTTP_PORT"
export SERVICE_METADATA_URL="http://localhost:$CONNECTOR_NODE_HTTP_PORT/ServiceMetadata"
export CONNECTOR_URL="http://localhost:$CONNECTOR_NODE_HTTP_PORT"
export EXT_CONNECTOR_URL="http://localhost:$CONNECTOR_NODE_HTTP_PORT"

export NODE_METADATA_SSO_LOCATION="http://localhost:$CONNECTOR_NODE_HTTP_PORT/ColleagueRequest"

export COUNTRY_1_CODE='NL'
export COUNTRY_1_NAME='The Netherlands'
export COUNTRY_1_PROXY_URL="http://localhost:$COUNTRY_1_PROXY_NODE_HTTP_PORT"

export COUNTRY_2_CODE='ES'
export COUNTRY_2_NAME='Spain'
export COUNTRY_2_PROXY_URL="http://localhost:$COUNTRY_2_PROXY_NODE_HTTP_PORT"

# Shouldn't need these for the Connector, but set them to empty to stop the variable replacement complaining:
export EXT_IDP_URL=''
export EXT_PROXY_URL=''
export IDP_URL=''
export IDP_SSO_URL=''
export PROXY_URL=''
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
