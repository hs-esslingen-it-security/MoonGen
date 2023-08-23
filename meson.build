# meson setup build2 --pkg-config-path ./libmoon/lib-build/dpdk/lib/x86_64-linux-gnu/pkgconfig/,./libmoon/lib-build/luajit/lib/pkgconfig/,./libmoon/lib-build/tbb/lib/pkgconfig/
# LD_LIBRARY_PATH='$ORIGIN/../libmoon/lib-build/dpdk/lib/x86_64-linux-gnu:$ORIGIN/../libmoon/lib-build/luajit/lib:$ORIGIN/../libmoon/lib-build/tbb/lib' ./MoonGen

project(
    'MoonGen',
    'c',
    'cpp',
    # default_options: {
    # 	'pkg_config_path': './libmoon/lib-build/dpdk/lib/x86_64-linux-gnu/pkgconfig/,./libmoon/lib-build/luajit/lib/pkgconfig/,./libmoon/lib-build/tbb/lib/pkgconfig/'
    # }
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

# dep_libmoon_cxx = cxx.find_library(
#     'moon',
#     dirs: [meson.current_source_dir() + '/libmoon/lib-build/libmoon/lib/x86_64-linux-gnu']
# )
# dep_libmoon = declare_dependency(
#     include_directories: include_directories(['./libmoon/lib-build/libmoon/include']),
#     dependencies: dep_libmoon_cxx
# )
dep_libmoon = dependency('libmoon', version: '=1.0.0')

dep_dpdk = dependency('libdpdk', version: '=23.07.0')
dep_luajit = dependency('luajit', version: '=2.1.0-beta3')
dep_tbb = dependency('tbb', version: '=2021.10.0')
# dep_highwayhash = dependency('highwayhash', method: 'system')

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
    # build_rpath: '$ORIGIN/../libmoon/lib-build/dpdk/lib/x86_64-linux-gnu:$ORIGIN/../libmoon/lib-build/luajit/lib:$ORIGIN/../libmoon/lib-build/tbb/lib'
    # build_rpath: '/home/markus/git/MoonGen/libmoon/lib-build/dpdk/lib/x86_64-linux-gnu:/home/markus/git/MoonGen/libmoon/lib-build/luajit/lib:/home/markus/git/MoonGen/libmoon/lib-build/tbb/lib'
)
