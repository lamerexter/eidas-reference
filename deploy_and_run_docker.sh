#!/usr/bin/env bash
set -e

./compile.sh
docker-compose up -d
docker-compose logs -f
