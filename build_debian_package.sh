#!/bin/bash -e
# bash script to create a simple debian package

PACKAGE_NAME=$1
PACKAGE_VERSION=$2
BUILD_DIR=$3

# create necessary file system structure for package
mkdir -p $BUILD_DIR/package/$PACKAGE_NAME/DEBIAN
mkdir -p $BUILD_DIR/package/$PACKAGE_NAME/usr/local/bin


# copy consul binary to destination
cp $BUILD_DIR/docker-compose-`uname -s`-`uname -m` $BUILD_DIR/package/$PACKAGE_NAME/usr/local/bin/docker-compose

# copy package control template and replace version info
cp -v ./control_file_template $BUILD_DIR/package/$PACKAGE_NAME/DEBIAN/control
sed -i'' "s/<VERSION>/${PACKAGE_VERSION}/g" $BUILD_DIR/package/$PACKAGE_NAME/DEBIAN/control

# actually create package with dpkg-deb
cd $BUILD_DIR/package
dpkg-deb --build $PACKAGE_NAME

# remove temporary folder with source package artifacts as they should not be uploaded to AWS S3
rm -R $BUILD_DIR/package/$PACKAGE_NAME
