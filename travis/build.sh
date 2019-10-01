#!/bin/bash

cd ~/build/libdat
cmake -S ~/build/libdat -B ~/build/libdat/build
cmake --build ~/build/libdat/build
~/build/libdat/build/dat_store test.dat build
~/build/libdat/build/dat_read test.dat Makefile
~/build/libdat/build/dat_store_libimpl test.dat build
~/build/libdat/build/dat_read_libimpl test.dat Makefile
