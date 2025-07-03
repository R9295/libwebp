#!/bin/bash
[ -d "build" ] && rm -rf "build"

if [ "$1" = "asan" ]; then
CC=afl-clang-fast CXX=afl-clang-fast++ cmake -DCMAKE_C_FLAGS="-fsanitize=address -fsanitize=undefined" -DCMAKE_CXX_FLAGS="-fsantitize=address -fsanitize=undefined" -S . -B ./build
CC=afl-clang-fast CXX=afl-clang-fast++ make -j16 -C ./build
afl-clang-fast++ -I. -o decode-asan decode.cc build/libwebp.a build/libwebpdecoder.a -fsanitize=fuzzer,address,undefined
else
 CC=afl-clang-fast CXX=afl-clang-fast++ cmake -B ./build S .
 CC=afl-clang-fast CXX=afl-clang-fast++ make -j16 -C ./build
afl-clang-fast++ -I. -o decode decode.cc build/libwebp.a build/libwebpdecoder.a -fsanitize=fuzzer
fi
