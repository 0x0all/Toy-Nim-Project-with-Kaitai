import os, system, sugar, strutils, argparse

var options = new_parser("mkv"):
  help("Longest movies (in current directory)")
  option("-p", "--path", default=".", help="Path to movies.")
  option("-t", "--top", default="10", help="Number of lines to show, 0 is inf.")
  flag(  "-f", "--flat", help="No recursion.")

var opts = options.parse(command_line_params())
if opts.path == ".":
  opts.path = get_current_dir()

var collect = (p: int) => p + 1
if opts.flat:
  for fn in walk_dir(opts.path):
    echo fn
    echo collect(5)
else:
  for fn in walk_dir_rec(opts.path):
    echo fn
    echo collect(5)
