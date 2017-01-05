#!/usr/bin/env bash

set -eu
set -o pipefail

SCRIPTS_DIR="$(dirname $0)"
. "$SCRIPTS_DIR/tomcat-variables.sh"

rm -rf "$EIDAS_TOMCAT_DIR"
