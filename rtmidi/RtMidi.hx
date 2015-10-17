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
    inline function openVirtualPort(portName:String = "RtMidi"):Void _openVirtualPort(cast portName);

    @:native('get_raw()->getPortCount')
    public function getPortCount():UInt;

    inline function getPortName(portNumber:UInt = 0):String {
        return cast untyped __cpp__("{0}->get_raw()->getPortName({1}).c_str()", this, portNumber);
    }

    @:native('get_raw()->closePort')
    function closePort():Void;

    @:native('get_raw()->isPortOpen')
    function isPortOpen():Bool;

    inline function setErrorCallback(?cb:ErrorCallback):Void {
        RtMidiHelper.setErrorCallback(cb);
    }

        // Internal
    @:native('linc::rtmidi::initErrorCallback')
    private static function initInternalErrorCallback(cb:cpp.Callable<ErrorType->String->Void>):Void;

    @:native('linc::rtmidi::setErrorCallback')
    private static function setInternalErrorCallback(midi:RtMidi):Void;

    private inline function onCreate(_this:RtMidi):Void {
        RtMidiHelper.initErrorCallback(_this);
    }
}

@:enum
abstract Api(Int)
from Int to Int {
    var UNSPECIFIED    = 0;
    var MACOSX_CORE    = 1;
    var LINUX_ALSA     = 2;
    var UNIX_JACK      = 3;
    var WINDOWS_MM     = 4;
    var RTMIDI_DUMMY   = 5;
}

@:enum
abstract ErrorType(Int)
from Int to Int {
    var WARNING = 0;
    var DEBUG_WARNING = 1;
    var UNSPECIFIED = 2;
    var NO_DEVICES_FOUND = 3;
    var INVALID_DEVICE = 4;
    var MEMORY_ERROR = 5;
    var INVALID_PARAMETER = 6;
    var INVALID_USE = 7;
    var DRIVER_ERROR = 8;
    var SYSTEM_ERROR = 9;
    var THREAD_ERROR = 10;
}

typedef ErrorCallback = ErrorType->String->Void;

    //Internal
@:allow(rtmidi.RtMidi)
@:include('linc_rtmidi.h')
private class RtMidiHelper {
    static var callback:ErrorCallback = defaultErrorCallback;
    static var internalCallbackSet:Bool = false;

    static function defaultErrorCallback(type:ErrorType, errorText:String):Void {
        trace('Type: $type, error text: $errorText');
    }

    static function internalCallback(type:ErrorType, errorText:String):Void {
        callback(type, errorText);
    }

    static function initErrorCallback(midi:RtMidi):Void {
        if(!internalCallbackSet) {
            internalCallbackSet = true;
            @:privateAccess RtMidi.initInternalErrorCallback(cpp.Callable.fromStaticFunction(internalCallback));
        }
        @:privateAccess RtMidi.setInternalErrorCallback(midi);
    }

    static function setErrorCallback(cb:ErrorCallback):Void {
        if(cb == null) {
            callback = defaultErrorCallback;
        }
        else {
            callback = cb;
        }
    }
}