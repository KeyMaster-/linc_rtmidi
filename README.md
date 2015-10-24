# linc/rtmidi
Haxe/hxcpp @:native bindings for the [RtMidi](https://www.music.mcgill.ca/~gary/rtmidi/) midi library

This is a [linc](http://snowkit.github.io/linc/) library.

---

This library works with the Haxe cpp target only.

---

### Install

`haxelib git linc_rtmidi https://github.com/keymaster-/linc_rtmidi.git`

### Supported platforms

- Mac
- Linux
- Windows


### Example usage

See the `tests` directory. Build with `haxe build.hxml` and run the executable in the `cpp` folder.


### Platform notes

- `Linux` - Make sure `libasound2-dev` is installed. This library has been tested on Ubuntu 14.04.3.
    - using `apt-get install libasound2-dev` or equivalent
