# libdat

## Description

## Building

### apt dependencies

gobjc++: Objective c++ for gcc  
gnustep: Library that contains essential files  
gnustep-devel: Development headers  
gcc: [GNU Compiler Collection](https://github.com/gcc-mirror/gcc)  
cmake: [Makefile generator](https://gitlab.kitware.com/cmake/cmake)  
make: [Makefile executer](http://savannah.gnu.org/projects/make)

```shell script
sudo apt install gobjc++ gnustep gnustep-devel gcc cmake make
```

### cmake

```shell script
cmake -S . -B build
cmake --build build
```

### cmake/make

```shell script
cmake -S . -B build
cd build
make
```
