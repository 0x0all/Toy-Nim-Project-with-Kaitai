import os, system, sugar, strutils, strformat
import unicode
import kaitai_struct_nim_runtime
import ksy_helper

func code_points*(utf8: string): int = utf8.runeLen


proc duration*(path: string, low: string): float = 
  debug_echo &"path='{path}', ext='{low}'"
  var ks = new_kaitai_stream(path)
  case low
  of ".mkv", ".webm": return mkv_duration(ks) / 1000
  of ".mp4":          return mp4_duration(ks, 0 == get_file_size(path) mod 188)
  else: raise new_exception(OSError, "y u do dis to me")


func format*(bytes: int): string = "bytes"


func format*(seconds: float): string = "seconds"


func format*(path: string): string = "path"


func nice_extension*(path: string): tuple[fit: bool, low: string] =
  let (_, _, ext) = split_file(path)
  let low = ext.to_lower_ascii()
  #debug_echo ext
  case low
  of ".mkv", ".mp4", ".webm": (true,  low)
  else:                       (false, "")
