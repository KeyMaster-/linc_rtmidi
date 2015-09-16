package rtmidi;
import rtmidi.RtMidi.Api;

@:include('linc_rtmidi.h')
@:native('::cpp::Pointer<RtMidiOut>')
extern class RtMidiOut extends RtMidi {
    static inline function create(api:Api = Api.UNSPECIFIED, clientName:String = "RtMidi Output Client"):RtMidiOut {
        return cast untyped __cpp__("::cpp::Pointer<RtMidiOut>(new RtMidiOut((RtMidi::Api)({0}), (const ::cpp::Char *)({1})))", api, clientName);
    }

    inline function destroy():Void {
        untyped __cpp__("{0}->destroy()", this);
    }

    @:native('get_raw()->getCurrentApi')
    function getCurrentApi():Api;

    @:native('get_raw()->openPort')
    private function _openPort(portNumber:UInt, portName:cpp.ConstCharStar):Void;
    inline function openPort(portNumber:UInt = 0, portName:String = "RtMidi Output"):Void return _openPort(portNumber, cast portName);

    @:native('get_raw()->openVirtualPort')
    private function _openVirtualPort(portName:cpp.ConstCharStar):Void;
    inline function openVirtualPort(portName:String = "RtMidi Output"):Void return _openVirtualPort(cast portName);

    @:native('get_raw()->closePort')
    function closePort():Void;

    @:native('get_raw()->isPortOpen')
    function isPortOpen():Bool;

    @:native('get_raw()->getPortCount')
    override function getPortCount():UInt;

    inline function getPortName(portNumber:UInt = 0):String {
        return cast untyped __cpp__("{0}->get_raw()->getPortName({1}).c_str()", this, portNumber);
    }

    inline function sendMessage(message:haxe.io.BytesData):Void {
        untyped __cpp__("std::vector<unsigned char> __msg({0}->length)", message);
        untyped __cpp__("memcpy(__msg.data(), {0}->GetBase(), {0}->length)", message);
        untyped __cpp__("{0}->get_raw()->sendMessage(&__msg)", this);
    }

    //setErrorCallback
}