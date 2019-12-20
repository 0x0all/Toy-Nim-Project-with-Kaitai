import os, system, sugar, sequtils, strutils, strformat
import tables
import algorithm
import argparse
import terminal

import util


proc print(s:string, color: ForegroundColor = fg_red) =
  set_foreground_color(color, true)
  if fg_red == color:
    stdout.write(s & '\n')
  else:
    stdout.write(s)
  reset_attributes()


func get_max(data: TableRef[string, seq[string]], top: int64): int =
  var copy = top
  var max = 0
  for key in to_seq(data.keys).sorted.reversed:
    for p in data[key]:
      copy -= 1
      let name = filename(p)
      let cp = code_points(name)
      if cp > max: max = cp
      if 0 == copy: return max
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
    let collect = proc (p: string) =
      if (let (fit, code) = nice_extension(p); fit):
        try:
          let milli = duration(p, code)
          let key = format(milli)
          var same = data.get_or_default(key, @[])
          same.add(p)
          data[key] = same
        except:
          print get_current_exception_msg()
 
    if opts.flat:
      for kind, path in walk_dir(opts.path):
        if kind == pc_file:
          collect(path)
    else:
      for path in walk_dir_rec(opts.path, {pc_file}):
        collect(path)

    var top = opts.top.parse_int
    let max = get_max(data, top)
    echo "\n"
    for key in to_seq(data.keys).sorted.reversed:
      for p in to_seq(data[key]).sorted:
        top -= 1
        stdout.write("    ")
        print(pad(filename(p), max), fg_blue)
        stdout.write(" -- ")
        print(key, fg_green)
        stdout.write(" -- ")
        
        let s = format(get_file_size(p))
        if s.ends_with("Gb"):
          print(align(s, 9))
        else:
          echo align(s, 9)
        if 0 == top: break
      if 0 == top: break
    echo "\n"
  except:
    print get_current_exception_msg()

main()  
