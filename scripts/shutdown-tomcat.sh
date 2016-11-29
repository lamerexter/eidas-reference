#!/usr/bin/env bash

set -eu
set -o pipefail

SCRIPTS_DIR="$(dirname $0)"
. "$SCRIPTS_DIR/tomcat-variables.sh"

for shutdownScript in "$EIDAS_TOMCAT_DIR"/*/bin/shutdown.sh; do
    echo "Shutting down $shutdownScript"
    $shutdownScript
done
