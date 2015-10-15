package rtmidi;

@:keep
@:include('linc_rtmidi.h')
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('rtmidi'))

@:native('::cpp::Pointer<RtMidi>')
extern class RtMidi {
    static inline function getVersion():String {
        return cast untyped __cpp__("RtMidi::getVersion().c_str()");
    }

    static inline function getCompiledApi():Array<Api> {
        untyped __cpp__("std::vector<RtMidi::Api> __apis");
        untyped __cpp__("RtMidi::getCompiledApi(__apis)");
        var apis:Array<Int> = [];
        untyped __cpp__("int __apisSize = __apis.size()");
        untyped __cpp__("{0}->__SetSize(__apisSize)", apis);
        untyped __cpp__("memcpy({0}->GetBase(), __apis.data(), __apisSize)", apis);
        return apis;
    }

    @:native('get_raw()->openPort')
    private function _openPort(portNumber:UInt = 0, portName:cpp.ConstCharStar):Void;
    inline function openPort(portNumber:UInt = 0, portName:String = "RtMidi"):Void _openPort(portNumber, cast portName);

    @:native('get_raw()->openVirtualPort')
    private function _openVirtualPort(portName:cpp.ConstCharStar):Void;
    inline function openVirtualPort(portName:String = "RtMidi"):Void return _openVirtualPort(cast portName);

    @:native('get_raw()->getPortCount')
    public function getPortCount():UInt;

    inline function getPortName(portNumber:UInt = 0):String return cast untyped __cpp__("{0}->get_raw()->getPortName({1}).c_str()", this, portNumber);

    @:native('get_raw()->closePort')
    function closePort():Void;

    @:native('get_raw()->isPortOpen')
    function isPortOpen():Bool;
}

@:enum
abstract Api(Int) //:todo: move to own file? Get this to auto-cast somehow?
from Int to Int {
    var UNSPECIFIED    = 0;
    var MACOSX_CORE    = 1;
    var LINUX_ALSA     = 2;
    var UNIX_JACK      = 3;
    var WINDOWS_MM     = 4;
    var RTMIDI_DUMMY   = 5;
}