import os, system, sugar, strutils, strformat
import tables
import algorithm
import argparse
import terminal

import util


proc red(s:string) =
  set_foreground_color(fg_red, true)
  stdout.write(s & '\n')
  reset_attributes()


func get_max(data: TableRef[string, seq[string]], copy: var int64): int =
  var max = 0
  for key, vec in data.pairs:
    for p in vec:
      copy -= 1
      let cp = code_points(p)
      if cp > max:
        max = cp
      if 0 == copy:
        return max


var options = new_parser("mkv"):
  help("Longest movies (in current directory)")
  option("-p", "--path", default=".", help="Path to movies.")
  option("-t", "--top", default="10", help="Number of lines to show, 0 is inf.")
  flag(  "-f", "--flat", help="No recursion.")


try:
  var opts = options.parse(command_line_params())
  if opts.path == ".":
    opts.path = get_current_dir()
  if not dir_exists opts.path:
    raise new_exception(OSError, &"directory '{opts.path}' does not exist")

  var data = new_table[string, seq[string]]()
  var collect = proc (p: string) =
    if (let (fit, ext) = nice_extension(p); fit):
      try:
        var same = data.get_or_default(ext, @[p])
        same.add(ext)
        data[ext] = same
      except:
        red get_current_exception_msg()

  if opts.flat:
    for kind, path in walk_dir(opts.path):
      if kind == pc_file:
        collect(path)
  else:
    for path in walk_dir_rec(opts.path, {pc_file}):
      collect(path)

  let x = get_max(45, opts.top)
except:
  red get_current_exception_msg()
