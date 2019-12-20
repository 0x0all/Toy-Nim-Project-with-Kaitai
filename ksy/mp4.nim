import os, system, sugar, strutils, strformat
import kaitai_struct_nim_runtime


type
  Mp4_t* = ref object
    ks*: KaitaiStream
    magic*: seq[byte]
    version*: uint8
    flags*: seq[byte]
    ctime*: uint32
    mtime*: uint32
    scale*: uint32
    duration*: uint32
    

proc new_mp4_t*(pks: KaitaiStream): owned Mp4_t =
  Mp4_t(ks: pks,
        magic: @[0'u8, 0'u8],
        version: 0,
        flags: @[0'u8, 0'u8],
        ctime: 0,
        mtime: 0,
        scale: 0,
        duration: 0)


proc read*(self: Mp4_t) =
  self.magic = self.ks.read_bytes(4)
  if self.magic != @[0x6d'u8, 0x76'u8, 0x68'u8, 0x64'u8]:
    raise new_exception(OSError, &"validation_not_equal_error: {self.magic} != [0x6d, 0x76, 0x68, 0x64]")
  self.version = self.ks.read_u1
  self.flags = self.ks.read_bytes(3)
  self.ctime = self.ks.read_u4be
  self.mtime = self.ks.read_u4be
  self.scale = self.ks.read_u4be
  self.duration = self.ks.read_u4be
