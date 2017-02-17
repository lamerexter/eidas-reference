#!/usr/bin/env bash
set -e

pushd ..
./compile.sh
popd 
docker-compose up -d
docker-compose logs -f
