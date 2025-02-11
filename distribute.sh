#!/bin/bash

me=$(readlink -f "$0")
path=$(dirname "$me")
project=${path##*/}
cmakelists=$path/CMakeLists.txt
if [ -f $cmakelists ]
then
  major=`grep VERSION_MAJOR $cmakelists | grep -o [0-9]*`
  minor=`grep VERSION_MINOR $cmakelists | grep -o [0-9]*`
  patch=`grep VERSION_PATCH $cmakelists | grep -o [0-9]*`
  version=$major.$minor.$patch
else
  version="Unknown"
fi
cd ..
archive=rri-${version}.tar.bz2 
tar -cvjSf $archive $project
mv $archive $project 
