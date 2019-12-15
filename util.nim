import os, system, sugar, strutils, strformat
import unicode


func code_points*(utf8: string): int = utf8.runeLen


func nice_extension*(path: string): tuple[fit: bool, ext: string] =
  let (_, _, ext) = split_file(path)
  let low = ext.to_lower_ascii()
  #debug_echo ext
  case low
  of ".mkv", ".mp4", ".webm": (true,  ext)
  else:                       (false, "")
