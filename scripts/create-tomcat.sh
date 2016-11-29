#!/usr/bin/env bash

set -eu
set -o pipefail

SCRIPTS_DIR="$(dirname $0)"
. "$SCRIPTS_DIR/tomcat-variables.sh"

TOMCAT_ZIP=${1?Usage $0 <path to tomcat zip>}

(./shutdown-tomcat.sh || :) 2> /dev/null

http_port=$STUB_SP_HTTP_PORT
ajp_port=50410
shutdown_port=50420
redirect_port=50430

mkdir -p "$EIDAS_TOMCAT_DIR"

index=0
for instance in stub-sp connector-node proxy-node stub-idp
do
  dest="$EIDAS_TOMCAT_DIR/tomcat-$instance"
  rm -rf $dest
  unzip -q -d "$dest" "$TOMCAT_ZIP" && f=("$dest"/*) && mv "$dest"/*/* "$dest" && rmdir "${f[@]}"
  sed -i '.backup' -e "s/8080/$((http_port + index))/g" -e "s/8009/$((ajp_port + index))/g" -e "s/8005/$((shutdown_port + index))/g" -e "s/8443/$((redirect_port + index))/g" $dest/conf/server.xml
  chmod +x $dest/bin/*.sh
  rm -r $dest/webapps/ROOT

  cp "$SCRIPTS_DIR/tomcat-variables.sh" "$EIDAS_TOMCAT_DIR/tomcat-$instance/bin"
  cp "$SCRIPTS_DIR/$instance-setenv.sh" "$EIDAS_TOMCAT_DIR/tomcat-$instance/bin/setenv.sh"

  index=$((index+1))
done

