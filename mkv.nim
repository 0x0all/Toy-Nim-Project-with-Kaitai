import os, system, strutils, argparse

{.passC: """-std=c++2a -pipe -march=native -mtune=native -O3 \
            -maes -mavx -mavx2 -mf16c -mfma -mmmx -mpclmul   \
            -mpopcnt -msse -msse2 -msse3 -msse4.1 -msse4.2   \
            -mssse3 -pedantic -Wextra -Wshadow -fipa-pta     \
            -Wnon-virtual-dtor -Wdelete-non-virtual-dtor     \
            -fgraphite-identity -fno-semantic-interposition  \
            -floop-nest-optimize -fdevirtualize-at-ltrans    \
        -fuse-linker-plugin -falign-functions=32 -flto=9""" .}

var p = new_parser("mkv"):
  help("Longest movies (in current directory)")
  option("-p", "--path", default=".", help="Path to movies.")
  option("-t", "--top", default="10", help="Number of lines to show, 0 is inf.")
  flag(  "-f", "--flat", help="No recursion.")

var opts = p.parse(command_line_params())

if opts.path == ".":
  opts.path = get_current_dir()
  
echo opts
