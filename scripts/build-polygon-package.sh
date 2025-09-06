#!/bin/bash

set -e

PKG_MAIN=PolygonPackage
PROJECT_DIR=/home/martinfrei/code/advancedfileserver


TOOLKIT=/home/martinfrei/toolkit
ARCH1=v1000
#ARCH2=rtd1619b
VER=7.2


# copy project
DEST=$TOOLKIT/source/$PKG_MAIN
if [ -d "$DEST" ]; then
    rm -r "$DEST"
fi
cp -r $PROJECT_DIR/$PKG_MAIN $TOOLKIT/source

# run build script
for i in $ARCH1 $ARCH2; do
    ( cd $TOOLKIT/pkgscripts-ng && sudo ./PkgCreate.py -v $VER -p $i -c $PKG_MAIN )
done
