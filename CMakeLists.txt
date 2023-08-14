cmake_minimum_required(VERSION 3.6.3)
project(MoonGen C CXX)

find_package(PkgConfig REQUIRED)

#Options are defined in libmoon/CMakeLists.txt

set(CMAKE_CXX_FLAGS "-fno-stack-protector -Wall -Wextra -Wno-unused-parameter -g -O3 -std=gnu++11 -march=native -msse4.2")
set(CMAKE_C_FLAGS "-fno-stack-protector -Wall -Wextra -Wno-unused-parameter -g -O3 -std=gnu11 -march=native -msse4.2")
set(CMAKE_EXE_LINKER_FLAGS "-rdynamic")

set(LIBMOON_BUILD_LIBRARY true)
add_definitions(-DLIBMOON_LUA_MAIN_MODULE="moongen-main")
add_subdirectory(libmoon)

pkg_search_module(PKG_DPDK REQUIRED IMPORTED_TARGET libdpdk)
pkg_search_module(PKG_LUAJIT REQUIRED IMPORTED_TARGET luajit)
pkg_search_module(PKG_TBB REQUIRED IMPORTED_TARGET tbb)

include_directories(
	${CMAKE_CURRENT_SOURCE_DIR}/src
	${CMAKE_CURRENT_SOURCE_DIR}/lib
	# ${CMAKE_CURRENT_SOURCE_DIR}/libmoon/lib-build/dpdk/include
	${PKG_DPDK_INCLUDE_DIRS}
	${PKG_LUAJIT_INCLUDE_DIRS}
	# ${CMAKE_CURRENT_SOURCE_DIR}/libmoon/lib-build/luajit/usr/local/include
	${CMAKE_CURRENT_SOURCE_DIR}/libmoon/deps/highwayhash/highwayhash
	# ${CMAKE_CURRENT_SOURCE_DIR}/libmoon/lib-build/tbb/include
	${PKG_TBB_INCLUDE_DIRS}
	${CMAKE_CURRENT_SOURCE_DIR}/libmoon/lib
	${CMAKE_CURRENT_SOURCE_DIR}/libmoon/src
)

set(files
	src/moongen-main.cpp
	src/software-timestamping.c
	src/crc-rate-limiter.c
	src/software-rate-limiter.cpp
	src/moonsniff.cpp
	src/histogram.cpp
	src/hashmap.cpp
)

set(libraries
	-Wl,--whole-archive
	moon
	PkgConfig::PKG_DPDK
	PkgConfig::PKG_LUAJIT
)

link_directories(
	${CMAKE_CURRENT_BINARY_DIR}/libmoon
	# ${CMAKE_CURRENT_SOURCE_DIR}/libmoon/deps/dpdk/build/lib
	# ${CMAKE_CURRENT_SOURCE_DIR}/libmoon/deps/luajit/usr/local/lib
	${CMAKE_CURRENT_SOURCE_DIR}/libmoon/deps/highwayhash/lib
)

add_executable(MoonGen ${files})
target_link_libraries(MoonGen ${libraries})

