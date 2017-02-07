#!/usr/bin/env bash
set -e

docker build -t "eidas/tomcat:8-oracle-java8" ./docker/
