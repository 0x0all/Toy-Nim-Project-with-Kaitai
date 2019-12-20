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


proc inner_loop(tag: uint32,
                ks: KaitaiStream,
                copy: int): int =
  var
    o = new_mp4_atom_t(ks)
    offset = copy
    prev   = 0

  o.ks.seek(offset)
  while true:
    o.read()
    prev = offset
    if 1 == o.size: # size cannot fit in uint32
      offset += 8
      o.ks.seek(offset)
      offset += int(o.ks.read_u8be()) - 8
    else:           # size can    fit in uint32
      offset += int(o.size)
    o.ks.seek(offset)
    if tag == o.typx: break
  prev


proc find_moov(ks: KaitaiStream): int =
  let moov = 0x6d6f6f76'u32
  inner_loop(moov, ks, 0)


proc find_mvhd(ks: KaitaiStream, start: int): int =
  let mvhd = 0x6d766864'u32
  inner_loop(mvhd, ks, start + 8)


proc is_mpeg2(ks: KaitaiStream): bool =
  return true


proc mp4_duration*(ks: KaitaiStream, fsize: BiggestInt): float =
  let maybe_mpeg2 = 0 == fsize mod 188
  if maybe_mpeg2 and is_mpeg2(ks):
    let divsr = 1024.0
    let seconds = float(fsize) / divsr / divsr
    return 10 * seconds
  let offset = find_mvhd(ks, find_moov(ks))
  var o = new_mp4_t(ks)
  o.ks.seek(offset + 4)
  o.read();
  float(o.duration) / float(o.scale)
