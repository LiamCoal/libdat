#!/bin/bash

cmake .
cmake --build .
./dat_store test.dat build
./dat_read test.dat Makefile
./dat_store_libimpl test.dat build
./dat_read_libimpl test.dat Makefile
