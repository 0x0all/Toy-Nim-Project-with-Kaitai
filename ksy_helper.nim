import kaitai_struct_nim_runtime
import ksy/mkv
import ksy/mp4
import ksy/mp4_atom


proc mkv_duration*(ks: KaitaiStream): float =
  var
    o = new_mkv_t(ks)
    offset  = 0
    a, b, c = 0'u8

  while true:
    a = o.ks.read_u1
    offset += 1
    if 0x44 != a: continue
    if (b = o.ks.read_u1; 0x89 != b):
      o.ks.seek(offset)
      continue
    if (c = o.ks.read_u1; 0x84 == c or 0x88 == c): break
    o.ks.seek(offset)
  o.ks.seek(offset - 1)
  o.read()
  case o.protocol
  of Size_type_t.st_float: o.value4
  else:                    o.value8


proc is_mpeg2(ks: KaitaiStream): bool =
  return true


proc mp4_duration*(ks: KaitaiStream, fsize: BiggestInt): float =
  let maybe_mpeg2 = 0 == fsize mod 188
  if maybe_mpeg2 and is_mpeg2(ks):
    let divsr = 1024.0
    let seconds = float(fsize) / divsr / divsr
    return 10 * seconds
  3.14
