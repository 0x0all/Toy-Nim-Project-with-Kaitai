import os, system, sugar, strutils, strformat
import kaitai_struct_nim_runtime
import ksy/mkv
import ksy/mp4
import ksy/mp4_atom


proc mkv_duration*(ks: KaitaiStream): float =
  var
    o = new_mkv_t(ks)
    offset = 0'u64
    a, b, c = 0'u8

  while true:
    echo "sleep"
    sleep(1000)


  o.read()
  echo o.magic
  echo o.protocol
  echo o.value4
  echo o.value8
  case cast[Size_type_t]  (o.protocol)
  of Size_type_t.st_float: o.value4
  else:                    o.value8



proc mp4_duration*(ks: KaitaiStream, maybe_mpeg2: bool): float = 3.14
