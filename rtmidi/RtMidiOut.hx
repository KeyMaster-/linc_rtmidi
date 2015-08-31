package rtmidi;
import rtmidi.RtMidi.Api;

@:include('linc_rtmidi.h')
@:native('RtMidiOut*')
extern class RtMidiOut extends RtMidi {
    static inline function create(api:Api = Api.UNSPECIFIED, clientName:String = "RtMidi Output Client"):RtMidiOut {
        return cast untyped __cpp__("new RtMidiOut((RtMidi::Api)({0}), (const ::cpp::Char *)({1}))", api, clientName);
    }

    inline function destroy():Void {
        untyped __cpp__("delete {0}; {0} = NULL", this);
    }

    @:native('getCurrentApi')
    function getCurrentApi():Api;

    @:native('openPort')
    private function _openPort(portNumber:UInt, portName:cpp.ConstCharStar):Void;
    inline function openPort(portNumber:UInt = 0, portName:String = "RtMidi Output"):Void return _openPort(portNumber, cast portName);

    @:native('openVirtualPort')
    private function _openVirtualPort(portName:cpp.ConstCharStar):Void;
    inline function openVirtualPort(portName:String = "RtMidi Output"):Void return _openVirtualPort(cast portName);

    @:native('closePort')
    function closePort():Void;

    @:native('isPortOpen')
    function isPortOpen():Bool;

    @:native('getPortCount')
    function getPortCount():UInt;

    inline function getPortName(portNumber:UInt = 0):String {
        return cast untyped __cpp__("{0}->getPortName({1}).c_str()", this, portNumber);
    }

    inline function sendMessage(message:haxe.io.BytesData):Void {
        untyped __cpp__("std::vector<unsigned char> __msg({0}->length)", message);
        untyped __cpp__("memcpy(__msg.data(), {0}->GetBase(), {0}->length)", message);
        untyped __cpp__("{0}->sendMessage(&__msg)", this);
    }

    //setErrorCallback
}