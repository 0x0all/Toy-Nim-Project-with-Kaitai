# Toy Nim Project with Kaitai

![Image](<https://i.imgur.com/NYpxwwX.png>)

```
$ nimble install kaitai_struct_nim_runtime --verbose
$ nimble install argparse --verbose
```

```
$ git clone https://github.com/sheerluck/Toy-Nim-Project-with-Kaitai.git
$ cd Toy-Nim-Project-with-Kaitai
$ nim compile -d:release -o:mkv mkv.nim
$ ./mkv --path ~/Videos
```

I would like to thank
 * @sealmove (Stefanos Mandalas) for KaitaiStruct Runtime Library for Nim
 * @solitudesf for letting me print inside pure functions with debug_echo
 * @leorize aka @alaviss for Nim plugin for NeoVim and introducing me to argparse
 * @PMunch (Peter Munch-Ellingsen) for "for key in to_seq(data.keys).sorted.reversed"
 * @stefantalpalaru (Ștefan Talpalaru) for Gentoo Overlay with nim-1.1.1.ebuild
 * @Zevv (Ico Doornekamp) for https://github.com/zevv/aoc2019
 * @Araq (Andreas Rumpf) for creating Nim Language and convincing me not to use repeat-until loop bc "until" is for strutils

