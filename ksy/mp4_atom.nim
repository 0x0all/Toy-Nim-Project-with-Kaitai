import os, system, sugar, strutils, strformat
import kaitai_struct_nim_runtime


type
  Mp4_atom_t* = ref object
    ks*: KaitaiStream
    size*: uint32
    typx*: uint32
    

proc new_mp4_atom_t*(pks: KaitaiStream): owned Mp4_atom_t =
  Mp4_atom_t(ks: pks, size: 0, typx: 0)


proc read*(self: Mp4_atom_t) =
  self.size = self.ks.read_u4be
  self.typx = self.ks.read_u4be
