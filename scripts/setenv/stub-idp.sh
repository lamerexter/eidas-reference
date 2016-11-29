#!/usr/bin/env bash

. "$(dirname $0)/tomcat-variables.sh"

export EIDAS_CONFIG_REPOSITORY=./EIDAS-Config/

export STUB_IDP_KEYSTORE="./EIDAS-Node/target/EidasNode/WEB-INF/stubIdpKeystore.jks"
export STUB_IDP_KEYSTORE_PASSWORD="Password"
export STUB_IDP_ENCRYPTION_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Stub IdP Encryption 20161031, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
export STUB_IDP_ENCRYPTION_CERTIFICATE_SERIAL_NUMBER="723c0f7f4b45dea5296e53f565535174d0df5218"
export STUB_IDP_SIGNING_CERTIFICATE_DISTINGUISHED_NAME="CN=Test Stub IdP Metadata Signing 20161026, OU=Government Digital Service, O=Cabinet Office, L=London, ST=Greater London, C=UK"
export STUB_IDP_SIGNING_CERTIFICATE_SERIAL_NUMBER="5ae2153c3f9a99824df394abd65f9e1e8ca53365"

export PROXY_METADATA_URL="http://localhost:$PROXY_NODE_HTTP_PORT/ServiceMetadata"
export PROXY_URL="http://localhost:$PROXY_NODE_HTTP_PORT"
export NODE_METADATA_SSO_LOCATION="http://localhost:$PROXY_NODE_HTTP_PORT/ColleagueRequest"
export IDP_URL="http://localhost:$STUB_IDP_HTTP_PORT"
export IDP_SSO_URL="http://localhost:$STUB_IDP_HTTP_PORT"

# Shouldn't need this for the Proxy, but set it to empty to stop the variable replacement complaining:
export SP_URL=''
export SERVICE_METADATA_URL=''
export CONNECTOR_URL=''
