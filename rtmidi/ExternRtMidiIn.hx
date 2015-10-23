package rtmidi;
import rtmidi.RtMidi.Api;

@:include('linc_rtmidi.h')
@:native('::cpp::Pointer<RtMidiIn>')
extern class ExternRtMidiIn extends RtMidi {
    static inline function create(api:Api = Api.UNSPECIFIED, clientName:String = "RtMidi Input Client", queueSizeLimit:UInt = 100):ExternRtMidiIn return _create(api, cast clientName, queueSizeLimit);

    private static inline function _create(api:Api, clientName:cpp.ConstCharStar, queueSizeLimit:UInt):ExternRtMidiIn {
        return cast untyped __cpp__("::cpp::Pointer<RtMidiIn>(new RtMidiIn((RtMidi::Api)({0}), {1}, {2}))", api, clientName, queueSizeLimit);
    }

    inline function destroy():Void {
        cancelCallback();
        untyped __cpp__("{0}->destroy()", this);
    }

    @:native('get_raw()->getCurrentApi')
    function getCurrentApi():Api;

    inline function setCallback(cb:InputCallback, ?userData:Dynamic):Void {
        RtMidiInHelper.setInputCallback(this, cb, userData);
    }

    inline function cancelCallback():Void {
        RtMidiInHelper.cancelCallback(this);
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
    private function cancelInternalCallback():Void;

    @:native('linc::rtmidi::initInputCallback')
    private static function initInternalInputCallback(cb:cpp.Callable<Float->haxe.io.BytesData->Int->Void>):Void;

    @:native('linc::rtmidi::setInputCallback') //:todo: possibly just turn this into an @:native or untyped __cpp__ (it's one line)
    private static function setInternalInputCallback(midiin:RtMidiIn, id:Int):Void;

}

typedef InputCallback = Float->haxe.io.BytesData->Dynamic->Void;

private typedef InternalCallbackInfo = {
    callback:InputCallback,
    userData:Dynamic,
    midiObj:ExternRtMidiIn
}

@:allow(rtmidi.ExternRtMidiIn)
@:include('linc_rtmidi.h')
private class RtMidiInHelper {
    static var callbacks:Map<Int, InternalCallbackInfo> = new Map();
    static var internalCallbackSet:Bool = false;
    static var nextID:Int = 0;

    static function internalCallback(delta:Float, message:haxe.io.BytesData, id:Int):Void {
        var callbackInfo = callbacks.get(id);
        if(callbackInfo != null) {
            callbackInfo.callback(delta, message, callbackInfo.userData);
        }
    }

    static function setInputCallback(midiin:ExternRtMidiIn, cb:InputCallback, userData:Dynamic):Void {
        if(!internalCallbackSet) {
            internalCallbackSet = true;
            @:privateAccess ExternRtMidiIn.initInternalInputCallback(cpp.Callable.fromStaticFunction(internalCallback));
        }

        callbacks.set(nextID, {
            callback:cb,
            userData:userData,
            midiObj:midiin
        });

        @:privateAccess ExternRtMidiIn.setInternalInputCallback(midiin, nextID);
        nextID++;
    }

    static function cancelCallback(midiin:ExternRtMidiIn):Void {
        for(key in callbacks.keys()) {
            var midiObj:ExternRtMidiIn = callbacks.get(key).midiObj;
            if(midiObj == midiin) {
                @:privateAccess midiin.cancelInternalCallback();
                callbacks.remove(key);
                return;
            }
        }
    }
}