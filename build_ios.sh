#!/bin/bash
rm -rf tmp build lib
mkdir tmp build lib
cd build

cmake -DCMAKE_TOOLCHAIN_FILE=../ios.cmake -DIOS_PLATFORM=OS .. && make
cp libnng_static.a ../tmp/libnng_armv7.a
rm -rf *

cmake -DCMAKE_TOOLCHAIN_FILE=../ios.cmake -DIOS_PLATFORM=OS64 .. && make
cp libnng_static.a ../tmp/libnng_arm64.a
rm -rf *

cmake -DCMAKE_TOOLCHAIN_FILE=../ios.cmake -DIOS_PLATFORM=SIMULATOR .. && make
cp libnng_static.a ../tmp/libnng_i386.a
rm -rf *

cmake -DCMAKE_TOOLCHAIN_FILE=../ios.cmake -DIOS_PLATFORM=SIMULATOR64 .. && make
cp libnng_static.a ../tmp/libnng_x86_64.a
rm -rf *

echo "lipo ..."

lipo -create ../tmp/libnng_armv7.a ../tmp/libnng_arm64.a ../tmp/libnng_i386.a ../tmp/libnng_x86_64.a -output ../lib/libnng.a

rm -rf tmp build
