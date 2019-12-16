import os, system, sugar, strutils, strformat
import unicode
import calmsize
import kaitai_struct_nim_runtime
import ksy_helper


func code_points*(utf8: string): int = utf8.runeLen


proc duration*(path: string, low: string): float = 
  var ks = new_kaitai_stream(path)
  case low
  of ".mkv", ".webm": return mkv_duration(ks) / 1000
  of ".mp4":          return mp4_duration(ks, get_file_size(path))
  else: raise new_exception(OSError, "y u do dis to me")


func format*(bytes: int): string       = human_filesize(bytes)


func format*(seconds: float): string   = human_duration(seconds)


func pad*(s: string, max: int): string = unicode.align_left(s, max)


func nice_extension*(path: string): tuple[fit: bool, low: string] =
  let (_, _, ext) = split_file(path)
  let low = ext.to_lower_ascii()
  case low
  of ".mkv", ".mp4", ".webm": (true,  low)
  else:                       (false, "")


proc filename*(path: string): string =
  let (_, base, ext) = split_file(path)
  return base & ext
