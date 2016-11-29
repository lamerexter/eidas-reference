#!/usr/bin/env bash

set -eu
set -o pipefail

SCRIPTS_DIR="$(dirname $0)"
. "$SCRIPTS_DIR/tomcat-variables.sh"

for startupScript in "$EIDAS_TOMCAT_DIR"/*/bin/startup.sh; do
    echo "Starting $startupScript"
    # Maybe CD here?
    $startupScript
done
