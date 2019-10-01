#!/bin/bash

cmake -S . -B build
cmake --build build
build/dat_store test.dat build
build/dat_read test.dat Makefile
build/dat_store_libimpl test.dat build
build/dat_read_libimpl test.dat Makefile
