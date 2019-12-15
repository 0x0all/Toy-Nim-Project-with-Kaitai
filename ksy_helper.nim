import kaitai_struct_nim_runtime
import ksy/mkv
import ksy/mp4
import ksy/mp4_atom


proc mkv_duration*(ks: KaitaiStream): float =
  #var o = mkv_t(pks);
  a(2020).to_float


proc mp4_duration*(ks: KaitaiStream, maybe_mpeg2: bool): float = 3.14
