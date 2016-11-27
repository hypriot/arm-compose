#!/bin/bash -e
# bash script to create a simple debian package

gem install fpm

PACKAGE_NAME=$1
PACKAGE_VERSION=$2
BUILD_DIR=$3
BUILD_NUMBER=${TRAVIS_BUILD_NUMBER}

mkdir temp
cd temp

# Set fpm arguments
declare -a FPM_ARGS
FPM_ARGS+=(-s dir)
FPM_ARGS+=(-t deb)
FPM_ARGS+=(--force)
FPM_ARGS+=(--verbose)
FPM_ARGS+=(--vendor "Docker")
FPM_ARGS+=(--category "net")
FPM_ARGS+=(--maintainer "Hypriot")
FPM_ARGS+=(--architecture "armhf")
FPM_ARGS+=(--url "http://blog.hypriot.com")
FPM_ARGS+=(--license "Apache License Version 2.0")
FPM_ARGS+=(--name "${PACKAGE_NAME}")
FPM_ARGS+=(--version "${PACKAGE_VERSION}")
FPM_ARGS+=(--description "docker-compose for armhf")
FPM_ARGS+=(--prefix /usr/local/bin)
FPM_ARGS+=(--iteration ${BUILD_NUMBER})
FPM_ARGS+=(--package ../)

# copy binary to destination
cp $BUILD_DIR/dist/docker-compose docker-compose

set -x
fpm "${FPM_ARGS[@]}" .
