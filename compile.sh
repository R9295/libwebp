#!/bin/bash
[ -d "build" ] && rm -rf "build"

if [ "$2" = "asan" ]; then
AFL_LLVM_CMPLOG=1 CC=afl-clang-fast CXX=afl-clang-fast++ cmake -DCMAKE_C_FLAGS="-fsanitize=address -fsanitize=undefined" -DCMAKE_CXX_FLAGS="-fsantitize=address -fsanitize=undefined" -S . -B ./build
AFL_LLVM_DICT2FILE=$(pwd)/dict.dict AFL_LLVM_CMPLOG=1 CC=afl-clang-fast CXX=afl-clang-fast++ make -j16 -C ./build
AFL_LLVM_CMPLOG=1 afl-clang-fast++ -I. -o $1.asan $1 build/libwebp.a build/libwebpdecoder.a -fsanitize=fuzzer,address,undefined
else
AFL_LLVM_CMPLOG=1 CC=afl-clang-fast CXX=afl-clang-fast++ cmake -B ./build S .
AFL_LLVM_DICT2FILE=$(pwd)/dict.dict AFL_LLVM_CMPLOG=1 CC=afl-clang-fast CXX=afl-clang-fast++ make -j16 -C ./build
AFL_LLVM_CMPLOG=1 afl-clang-fast++ -I. -o $1.out $1 build/libwebp.a build/libwebpdecoder.a -fsanitize=fuzzer
fi
