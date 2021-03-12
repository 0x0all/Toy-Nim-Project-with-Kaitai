import os, system, strutils, strformat
import kaitai_struct_nim_runtime


type
  Size_type_t* = enum
    st_init   = 0
    st_float  = 132
    st_double = 136

  Mkv_t* = ref object
    ks*: KaitaiStream
    magic*: seq[byte]
    protocol*: Size_type_t
    value4*: float32
    value8*: float
    

proc new_mkv_t*(pks: KaitaiStream): owned Mkv_t =
  Mkv_t(ks: pks,
        magic: @[0'u8, 0'u8],
        protocol: Size_type_t.st_init,
        value4: 0.0'f32,
        value8: 0.0)


proc read*(self: Mkv_t) =
  self.magic = self.ks.read_bytes(2)
  if self.magic != @[0x44'u8, 0x89'u8]:
    raise new_exception(OSError, &"validation_not_equal_error: {self.magic} != [0x44, 0x89]")
  self.protocol = cast[Size_type_t](self.ks.read_u1)
  case self.protocol
  of Size_type_t.st_float:  self.value4 = self.ks.read_f4be
  of Size_type_t.st_double: self.value8 = self.ks.read_f8be
  else: raise new_exception(OSError, &"validation_not_equal_error: '{self.protocol}'")
