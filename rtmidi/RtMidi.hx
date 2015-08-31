package rtmidi;

@:keep
@:include('linc_rtmidi.h')
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('rtmidi'))

@:native('RtMidi*')
extern class RtMidi {
    static inline function getVersion():String {
        return cast untyped __cpp__("RtMidi::getVersion().c_str()");
    }

    static inline function getCompiledApi():Array<Int> {
        untyped __cpp__("std::vector<RtMidi::Api> __apis");
        untyped __cpp__("RtMidi::getCompiledApi(__apis)");
        var apis:Array<Int> = [];
        untyped __cpp__("int __apisSize = __apis.size()");
        untyped __cpp__("{0}->__SetSize(__apisSize)", apis);
        untyped __cpp__("memcpy({0}->GetBase(), __apis.data(), __apisSize)", apis); //:todo: copy iteration
        return apis;
    }

    //getCompiledApi

    //problems with representing the inheritance: declaring a function signature which is overriden by the subclass
    // doesn't seem to work, haxe does not use the subclass function.

    // function openPort(portNumber:UInt = 0, portName:String = "RtMidi");
}

@:enum
abstract Api(Int) //:todo: move to own file?
from Int to Int {
    var UNSPECIFIED    = 0;
    var MACOSX_CORE    = 1;
    var LINUX_ALSA     = 2;
    var UNIX_JACK      = 3;
    var WINDOWS_MM     = 4;
    var RTMIDI_DUMMY   = 5;
}