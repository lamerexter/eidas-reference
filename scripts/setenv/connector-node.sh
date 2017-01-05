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
export SERVICE_METADATA_URL="http://localhost:$CONNECTOR_NODE_HTTP_PORT/ServiceMetadata"
export CONNECTOR_URL="http://localhost:$CONNECTOR_NODE_HTTP_PORT"
export PROXY_METADATA_URL="http://localhost:$PROXY_NODE_HTTP_PORT/ServiceMetadata"
export NL_PROXY_URL="http://localhost:$NL_PROXY_NODE_HTTP_PORT"
export FR_PROXY_URL="http://localhost:$FR_PROXY_NODE_HTTP_PORT"
export NODE_METADATA_SSO_LOCATION="http://localhost:$CONNECTOR_NODE_HTTP_PORT/ColleagueRequest"

# Shouldn't need these for the Connector, but set them to empty to stop the variable replacement complaining:
export IDP_URL=''
export IDP_SSO_URL=''
export PROXY_URL=''
