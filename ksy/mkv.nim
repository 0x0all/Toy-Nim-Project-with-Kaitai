import os, system, sugar, strutils, strformat
import kaitai_struct_nim_runtime


#if KAITAI_STRUCT_VERSION < 9000L
#error "Incompatible Kaitai Struct C++/STL API: version 0.9 or later is required"
#endif


type
  Size_type_t* = enum
    st_float = 132
    st_double = 136

  Mkv_t* = ref object
    ks*: KaitaiStream
    magic*: seq[byte]
    protocol*: int
    value4*: float32
    value8*: float
    

proc new_mkv_t*(pks: KaitaiStream): owned Mkv_t =
  Mkv_t(ks: pks, magic: @[0'u8, 0'u8], protocol: 0, value4: 0.0, value8: 0.0)


proc read*(self: Mkv_t) =
  self.magic = self.ks.read_bytes(2)
  if self.magic != @[0x44'u8, 0x89'u8]:
    raise new_exception(OSError, &"validation_not_equal_error: {self.magic} != [0x44, 0x89]")


  #[
      m_magic = m__io->read_bytes(2);
    if (!(magic() == std::string("\x44\x89", 2))) {
        throw kaitai::validation_not_equal_error<std::string>(std::string("\x44\x89", 2), magic(), _io(), std::string("/seq/0"));
    }
    m_protocol = static_cast<mkv_t::size_type_t>(m__io->read_u1());
    n_value4 = true;
    if (protocol() == mkv_t::SIZE_TYPE_FLOAT) {
        n_value4 = false;
        m_value4 = m__io->read_f4be();
    }
    n_value8 = true;
    if (protocol() == mkv_t::SIZE_TYPE_DOUBLE) {
        n_value8 = false;
        m_value8 = m__io->read_f8be();
    }]#


func a*(a: int): int = 19 * a
