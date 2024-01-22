#! /bin/bash
set -e

KUBEVIRT_SRC=$PWD/kubevirt

cd $KUBEVIRT_SRC

for fname in ../src/patches/*.patch; do
  echo "Patch - $fname"
  #patch -p1 < ../src/patches/001-build.patch
  #patch -p1 < $fname
done
patch -p1 < ../src/patches/001-build.patch