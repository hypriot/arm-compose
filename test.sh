#!/bin/bash
set -e
docker build -t test -f test/Dockerfile .
docker run test docker-compose --version
