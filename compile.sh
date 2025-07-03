#!/bin/bash
[ -d "build" ] && rm -rf "build"

#if [ "$1" = "asan" ]; then
CMAKE_C_FLAGS="-fsanitize=address" CMAKE_CXX_FLAGS="-fsantitize=address" CC=afl-clang-fast CXX=afl-clang-fast++ cmake -B ./build S .
CMAKE_C_FLAGS="-fsanitize=address" CMAKE_CXX_FLAGS="-fsantitize=address" CC=afl-clang-fast CXX=afl-clang-fast++ make -j16 -C ./build
afl-clang-fast++ -I. -o decode-asan decode.cc build/libwebp.a build/libwebpdecoder.a -fsanitize=fuzzer,address,undefined

else
CMAKE_C_FLAGS="-fsanitize=address" CMAKE_CXX_FLAGS="-fsantitize=address" CC=afl-clang-fast CXX=afl-clang-fast++ cmake -B ./build S .
CMAKE_C_FLAGS="-fsanitize=address" CMAKE_CXX_FLAGS="-fsantitize=address" CC=afl-clang-fast CXX=afl-clang-fast++ make -j16 -C ./build
afl-clang-fast++ -I. -o decode-asan decode.cc build/libwebp.a build/libwebpdecoder.a -fsanitize=fuzzer
fi
