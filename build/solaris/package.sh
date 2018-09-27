#!/bin/bash

# Get version
DIR=$(dirname "$(readlink -f "$0")")
BUILD_DIR=$(realpath "$DIR/..")
VERSION=$(cat $BUILD_DIR/../VERSION)

# Set up package info
ARCH=$(arch)
sed "s/ARCH=.*/ARCH=$ARCH/" $DIR/pkginfo > $BUILD_DIR/pkginfo

# Make the package and cleanup
(
    cd $BUILD_DIR
    cp pkginfo ncpa/pkginfo
    cp postinstall ncpa/postinstall
    cp preinstall ncpa/preinstall

    # Add prototype file
    echo 'i pkginfo' > prototype
    pkgproto ncpa >> prototype

    # Build package and create the .pkg file
    pkgmk -b $(pwd) -o
    pkgtrans -s /var/spool/pkg ncpa-$VERSION.$ARCH.pkg ncpa
    rm -rf ncpa-$VERSION.$ARCH.pkg
    mv -f /var/spool/pkg/ncpa-$VERSION.$ARCH.pkg .

    # Remove build leftovers
    rm -rf /var/spool/pkg/ncpa
    rm -rf ncpa
    rm -f prototype
    rm -f pkginfo
)