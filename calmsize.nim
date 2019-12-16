import os, system, sugar, strutils, strformat

template `//`[T](a, b: T): T = a /% b

func human_filesize*(size: int): string =
  # ported from hachoir.core.tools
  if size < 10000:
    return &"{size} bytes"
  let units = ["KB", "MB", "GB", "TB"]
  var fsize = float(size)
  let divsr = 1024.0
  var xunit = "BUG"
  for unit in units:
    xunit = unit
    fsize /= divsr
    if fsize < divsr:
      return &"{fsize:.1f} {unit}"
  return &"{fsize} {xunit}"

func human_duration*(seconds: float): string =
  let s = seconds.to_int
  let H = s // (60 * 60)
  let m = s mod (60 * 60)
  let M = m // 60
  let S = m mod 60
  return &"{H:02d}:{M:02d}:{S:02d}"
