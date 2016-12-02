#!/usr/bin/env bash

set -eu
set -o pipefail

if [ ! -d "EIDAS-Parent" ]; then
	>&2 echo "This script should always be run in the root folder (with EIDAS-Parent in the folder)"
	exit 1
fi

SCRIPTS_DIR="$(dirname $0)"
. "$SCRIPTS_DIR/tomcat-variables.sh"

for startupScript in "$EIDAS_TOMCAT_DIR"/*/bin/startup.sh; do
    echo "Starting $startupScript"
    # Maybe CD here?
    $startupScript
done
