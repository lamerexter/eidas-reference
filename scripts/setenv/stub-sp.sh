#!/usr/bin/env bash

. "$(dirname $0)/tomcat-variables.sh"

export EIDAS_CONFIG_REPOSITORY=./EIDAS-Config/

export STUB_SP_KEYSTORE="./EIDAS-Node/target/EidasNode/WEB-INF/stubSpKeystore.jks"
export STUB_SP_KEYSTORE_PASSWORD="Password"
export STUB_SP_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Stub SP Encryption 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
export STUB_SP_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="41573ab34ef7100cb77e4c5aca551826cf86a1e9"
export STUB_SP_SIGNING_CERTIFICATE_DISTINGUSHED_NAME="CN=Test Stub SP Metadata Signing 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
export STUB_SP_SIGNING_CERTIFICATE_SERIAL_NUMBER="123f7141d99aa3b6ad31211dabb9ca7abdc08b5d"

export SP_URL="http://localhost:$STUB_SP_HTTP_PORT"
export SERVICE_METADATA_URL="http://localhost:$CONNECTOR_NODE_HTTP_PORT/ServiceMetadata"
export CONNECTOR_URL="http://localhost:$CONNECTOR_NODE_HTTP_PORT"

# Shouldn't need these for the SP, but set them to empty to stop the variable replacement complaining:
export PROXY_METADATA_URL=''
export NL_PROXY_URL=''
export FR_PROXY_URL=''
export PROXY_NODE_METADATA_SSO_LOCATION=''
export IDP_URL=''
export IDP_SSO_URL=''
export PROXY_URL=''
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