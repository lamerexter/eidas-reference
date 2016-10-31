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

mvn --file EIDAS-Parent clean install -P embedded -P coreDependencies -Dmaven.test.skip=true

# ---------------------------
# Deploy
# ---------------------------

# Deploy the SP
cp "$project_root"/EIDAS-SP/target/SP.war "$CATALINA_HOME/webapps"

# Deploy the Connector Node
cp "$project_root"/EIDAS-Node/target/EidasNode.war "$CATALINA_HOME/webapps/ConnectorNode.war"

# Deploy the IdP
cp "$project_root"/EIDAS-IdP-1.0/target/IdP.war "$CATALINA_HOME/webapps"

# Hack - reconfigure the Node to be a proxy node instead of a connector node
FILES_TO_REPLACE=$(git grep 'CONNECTOR_NODE_KEYSTORE' | cut -d: -f1 | grep .xml | sort -u)
for file in $FILES_TO_REPLACE; do
  sed -i '.original' \
    -e 's/CONNECTOR_NODE_KEYSTORE/PROXY_NODE_KEYSTORE/' \
    -e 's/CN=Test Connector/CN=Test Proxy/' \
    -e 's/1dcfdeedc8983a5f13f2338e0814b6e47090b3d7/6641716bee633fb618dbd85b7d41e63b62046c2d/' \
    -e 's/763709571da44ef6d323f7ae1ea4c3a4358fd81c/13b0d8b35ed284356bf14e1759473d7fc55f2deb/' $file
done

mvn --file EIDAS-Parent clean install -P embedded -P coreDependencies -Dmaven.test.skip=true

# Deploy the Proxy Node
cp "$project_root"/EIDAS-Node/target/EidasNode.war "$CATALINA_HOME/webapps/ProxyNode.war"

# Restore the modified files from their backups
find . -name "*.original" -exec sh -c 'mv -f $0 ${0%.original}' {} \;

# ---------------------------
# Start Tomcat
# ---------------------------

export EIDAS_CONFIG_REPOSITORY="$project_root"/EIDAS-Config/
export EIDAS_KEYSTORE='keystore/eidasKeystore.jks'
export STUB_SP_KEYSTORE="$project_root/EIDAS-Node/target/EidasNode/WEB-INF/stubSpKeystore.jks"
export CONNECTOR_NODE_KEYSTORE="$project_root/EIDAS-Node/target/EidasNode/WEB-INF/connectorNodeKeystore.jks"
export PROXY_NODE_KEYSTORE="$project_root/EIDAS-Node/target/EidasNode/WEB-INF/proxyNodeKeystore.jks"
export STUB_IDP_KEYSTORE="$project_root/EIDAS-Node/target/EidasNode/WEB-INF/stubIdpKeystore.jks"
export SP_URL='http://127.0.0.1:8080/SP'
export CONNECTOR_URL='http://127.0.0.1:8080/ConnectorNode'
export PROXY_URL='http://127.0.0.1:8080/ProxyNode'
export NODE_METADATA_SSO_LOCATION='http://127.0.0.1:8080/ProxyNode/ColleagueRequest'
export IDP_URL='http://127.0.0.1:8080/IdP'
export IDP_SSO_URL='https://127.0.0.1:8080/IdP'

catalina run
