package rtmidi;
import rtmidi.RtMidi.Api;

@:include('linc_rtmidi.h')
@:native('::cpp::Pointer<RtMidiOut>')
extern class ExternRtMidiOut extends RtMidi {
    private static inline function create(api:Api = Api.UNSPECIFIED, clientName:String = "RtMidi Output Client"):ExternRtMidiOut return _create(api, cast clientName);

    private static inline function _create(api:Api, clientName:cpp.ConstCharStar):ExternRtMidiOut {
        return cast untyped __cpp__("::cpp::Pointer<RtMidiOut>(new RtMidiOut((RtMidi::Api)({0}), {1}))", api, clientName);
    }

    inline function destroy():Void {
        untyped __cpp__("{0}->destroy()", this);
    }

    @:native('get_raw()->getCurrentApi')
    function getCurrentApi():Api;

    inline function sendMessage(message:haxe.io.BytesData):Void {
        untyped __cpp__("std::vector<unsigned char> __msg({0}->length)", message);
        untyped __cpp__("memcpy(__msg.data(), {0}->GetBase(), {0}->length)", message);
        untyped __cpp__("{0}->get_raw()->sendMessage(&__msg)", this);
    }
}