import os, system, sugar, sequtils, strutils, strformat
import tables
import algorithm
import argparse
import terminal

import util


proc red(s:string) =
  set_foreground_color(fg_red, true)
  stdout.write(s & '\n')
  reset_attributes()


func get_max(data: TableRef[string, seq[string]], top: int64): int =
  var copy = top
  var max = 0
  for key in to_seq(data.keys).sorted.reversed:
    for p in data[key]:
      copy -= 1
      let cp = code_points(p)
      if cp > max:
        max = cp
      if 0 == copy:
        return max
  return max


var options = new_parser("mkv"):
  help("Longest movies (in current directory)")
  option("-p", "--path", default=".", help="Path to movies.")
  option("-t", "--top", default="10", help="Number of lines to show, 0 is inf.")
  flag(  "-f", "--flat", help="No recursion.")

proc main() =
  try:
    var opts = options.parse(command_line_params())
    if opts.path == ".":
      opts.path = get_current_dir()
    if not dir_exists opts.path:
      raise new_exception(OSError, &"directory '{opts.path}' does not exist")
 
    var data = new_table[string, seq[string]]()
    var collect = proc (p: string) =
      if (let (fit, code) = nice_extension(p); fit):
        try:
          let milli = duration(p, code)
          let key = format(milli)
          var same = data.get_or_default(key, @[])
          same.add(p)
          data[key] = same
        except:
          red get_current_exception_msg()
 
    if opts.flat:
      for kind, path in walk_dir(opts.path):
        if kind == pc_file:
          collect(path)
    else:
      for path in walk_dir_rec(opts.path, {pc_file}):
        collect(path)
 
    let max = get_max(data, opts.top.parse_int)
    echo "\n"
    for key in to_seq(data.keys).sorted.reversed:
      echo &"    key={key}"
      echo &"    key={key}, vec={data[key]}"
    echo "\n"
  except:
    red get_current_exception_msg()

main()  
