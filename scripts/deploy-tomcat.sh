#!/usr/bin/env bash

set -eu
set -o pipefail

SCRIPTS_DIR="$(dirname "$0")"
. "$SCRIPTS_DIR/tomcat-variables.sh"

if [ "${1:-}" != '--skip-build' ]
then
  echo 'Building eidas parent, pass --skip-build to skip this'
  mvn --file "$SCRIPTS_DIR/../EIDAS-Parent" package -P embedded -P coreDependencies -Dmaven.test.skip=true
fi

echo Deploying to "$EIDAS_TOMCAT_DIR"/*

cp EIDAS-SP/target/SP.war "$EIDAS_TOMCAT_DIR/tomcat-stub-sp/webapps/ROOT.war"
cp EIDAS-Node/target/EidasNode.war "$EIDAS_TOMCAT_DIR/tomcat-connector-node/webapps/ROOT.war"
cp EIDAS-Node/target/EidasNode.war "$EIDAS_TOMCAT_DIR/tomcat-proxy-node/webapps/ROOT.war"
cp EIDAS-IdP-1.0/target/IdP.war "$EIDAS_TOMCAT_DIR/tomcat-stub-idp/webapps/ROOT.war"
