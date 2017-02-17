#!/usr/bin/env bash
set -e

docker build -t "eidas/tomcat:8.5.11-jre8-alpine-UnlimitedJCEPolicyJDK8" ./
