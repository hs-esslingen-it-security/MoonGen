project(
    'MoonGen',
    'c',
    'cpp',
    version: '1.0.0',
)

cxx = meson.get_compiler('cpp')

src_files = [
    'src/moongen-main.cpp',
    'src/software-timestamping.c',
    'src/crc-rate-limiter.c',
    'src/software-rate-limiter.cpp',
    'src/moonsniff.cpp',
    'src/histogram.cpp',
    'src/hashmap.cpp'
]

dep_libmoon = dependency('libmoon', version: '=1.0.0')

dep_dpdk = dependency('libdpdk', version: '=23.07.0')
dep_luajit = dependency('luajit', version: '=2.1.0-beta3')
dep_tbb = dependency('tbb', version: '=2021.10.0')

dep_highwayhash_cxx = cxx.find_library(
    'highwayhash',
    dirs: ['/usr/local/lib']
)
dep_highwayhash = declare_dependency(
    include_directories: include_directories(['/usr/local/include/highwayhash']),
    dependencies: dep_highwayhash_cxx
)

dependencies = [
    dep_libmoon,
    dep_dpdk,
    dep_luajit,
    dep_tbb,
    dep_highwayhash
]

executable(
    'MoonGen',
    src_files,
    dependencies: dependencies,
    # Export all (not only used) symbols so that LuaJIT can access them
    link_args: ['-rdynamic'],
    cpp_args: ['-std=c++11'],
    install: true
)
