import os, system, strutils, argparse

var p = new_parser("mkv"):
  help("Longest movies (in current directory)")
  option("-p", "--path", default=".", help="Path to movies.")
  option("-t", "--top", default="10", help="Number of lines to show, 0 is inf.")
  flag(  "-f", "--flat", help="No recursion.")

var opts = p.parse(command_line_params())
if opts.path == ".":
  opts.path = get_current_dir()
  
echo opts
