cmake_minimum_required(VERSION 3.13)
project(dat)

include_directories(/usr/include/GNUstep /usr/lib/GNUstep/System/Library/Headers /usr/include)
add_compile_options("-fconstant-string-class=NSConstantString" "-Wall")
link_libraries(gnustep-base objc)
add_executable(dat_store store.mm)