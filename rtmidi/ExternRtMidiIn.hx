package rtmidi;
import rtmidi.RtMidi.Api;

@:include('linc_rtmidi.h')
@:native('::cpp::Pointer<RtMidiIn>')
extern class ExternRtMidiIn extends RtMidi {
    static inline function create(api:Api = Api.UNSPECIFIED, clientName:String = "RtMidi Input Client", queueSizeLimit:UInt = 100):ExternRtMidiIn {
        return _create(api, clientName, queueSizeLimit);
    }

    private static inline function _create(api:Api, clientName:cpp.ConstCharStar, queueSizeLimit:UInt):ExternRtMidiIn {
        return cast untyped __cpp__("::cpp::Pointer<RtMidiIn>(new RtMidiIn((RtMidi::Api)({0}), {1}, {2}))", api, clientName, queueSizeLimit); //:todo: manual cast to ConstCharStar okay?
    }

    inline function destroy():Void {
        cancelCallback();
        untyped __cpp__("{0}->destroy()", this);
    }

    @:native('get_raw()->getCurrentApi')
    function getCurrentApi():Api;

    inline function setCallback(cb:InputCallback, userData:Dynamic):Void {
        RtMidiIn_helper.set_input_callback(this, cb, userData);
    }

    inline function cancelCallback():Void {
        RtMidiIn_helper.cancel_callback(this);
    }

    @:native('get_raw()->ignoreTypes')
    function ignoreTypes(midiSysex:Bool = true, midiTime:Bool = true, midiSense:Bool = true):Void;

    inline function getMessage(message:haxe.io.BytesData):Float {
        untyped __cpp__("std::vector<unsigned char> __msg");
        untyped __cpp__("double __stamp = {0}->get_raw()->getMessage(&__msg)", this);
        untyped __cpp__("int __msgSize = __msg.size()");
        untyped __cpp__("{0}->__SetSize(__msgSize)", message);
        untyped __cpp__("memcpy({0}->GetBase(), __msg.data(), __msgSize)", message);
        return cast untyped __cpp__("__stamp");
    }

        // Internal
    @:native('get_raw()->cancelCallback')
    private function cancel_callback():Void;

    @:native('linc::rtmidi::init_input_callback')
    private static function init_input_callback(cb:cpp.Callable<Float->haxe.io.BytesData->Int->Void>):Void;

    @:native('linc::rtmidi::set_input_callback') //:todo: possibly just turn this into an @:native or untyped __cpp__ (it's one line)
    private static function set_input_callback(midiin:RtMidiIn, id:Int):Void;

}

typedef InputCallback = Float->haxe.io.BytesData->Dynamic->Void;

private typedef InternalCallbackInfo = {
    callback:InputCallback,
    userData:Dynamic,
    midiObj:ExternRtMidiIn
}

@:allow(rtmidi.ExternRtMidiIn)
@:include('linc_rtmidi.h')
private class RtMidiIn_helper {
    static var callbacks:Map<Int, InternalCallbackInfo> = new Map();
    static var internal_cb_set:Bool = false;
    static var nextID:Int = 0;

    static function internal_callback(delta:Float, message:haxe.io.BytesData, id:Int):Void {
        var cb_info = callbacks.get(id);
        if(cb_info != null) {
            cb_info.callback(delta, message, cb_info.userData);
        }
    }

    static function set_input_callback(midiin:ExternRtMidiIn, cb:InputCallback, userData:Dynamic):Void {
        if(!internal_cb_set) {
            internal_cb_set = true;
            @:privateAccess ExternRtMidiIn.init_input_callback(cpp.Callable.fromStaticFunction(internal_callback));
        }

        callbacks.set(nextID, {
            callback:cb,
            userData:userData,
            midiObj:midiin
        });

        @:privateAccess ExternRtMidiIn.set_input_callback(midiin, nextID);
        nextID++;
    }

    static function cancel_callback(midiin:ExternRtMidiIn):Void {
        for(key in callbacks.keys()) {
            var val:ExternRtMidiIn = callbacks.get(key).midiObj;
            if(val == midiin) {
                @:privateAccess midiin.cancel_callback();
                callbacks.remove(key);
                return;
            }
        }
    }
}