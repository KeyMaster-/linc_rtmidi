package rtmidi;
import rtmidi.RtMidi.Api;

@:include('linc_rtmidi.h')
@:native('::cpp::Pointer<RtMidiIn>')
extern class RtMidiIn extends RtMidi {
    static inline function create(api:Api = Api.UNSPECIFIED, clientName:String = "RtMidi Input Client", queueSizeLimit:UInt = 100):RtMidiIn {
        return cast untyped __cpp__("::cpp::Pointer<RtMidiIn>(new RtMidiIn((RtMidi::Api)({0}), (const ::cpp::Char *){1}, {2}))", api, clientName, queueSizeLimit); //:todo: manual cast to ConstCharStar okay?
    }
    
    inline function destroy():Void {
        untyped __cpp__("{0}->destroy()", this); //:todo: cancel callback?
    }

    @:native('get_raw()->getCurrentApi')
    function getCurrentApi():Api;

    @:native('get_raw()->openPort')
    private function _openPort(portNumber:UInt = 0, portName:cpp.ConstCharStar):Void;
    inline function openPort(portNumber:UInt = 0, portName:String = "RtMidi Input"):Void _openPort(portNumber, cast portName);

    @:native('get_raw()->openVirtualPort')
    private function _openVirtualPort(portName:cpp.ConstCharStar):Void;
    inline function openVirtualPort(portName:String = "RtMidi Input"):Void _openVirtualPort(cast portName);

    inline function setCallback(cb:Callback, userData:Dynamic):Void {
        RtMidiIn_helper.set_callback(this, cb, userData);
    }

    @:native('linc::rtmidi::init_callback')
    private static function init_callback(cb:cpp.Callable<Float->haxe.io.BytesData->Int->Void>):Void;

    @:native('linc::rtmidi::set_callback') //:todo: possibly just turn this into an @:native or untyped __cpp__ (it's one line)
    private static function set_callback(midiin:RtMidiIn, id:Int):Void;

    inline function cancelCallback():Void {
        RtMidiIn_helper.cancel_callback(this);
    }

    @:native('get_raw()->cancelCallback')
    private function cancel_callback():Void;

    @:native('get_raw()->closePort')
    function closePort():Void;

    @:native('get_raw()->isPortOpen')
    function isPortOpen():Bool;

    @:native('get_raw()->getPortCount')
    function getPortCount():UInt;

    inline function getPortName(portNumber:UInt = 0):String {
        return cast untyped __cpp__("{0}->get_raw()->getPortName({1}).c_str()", this, portNumber);
    }

    @:native('get_raw()->ignoreTypes')
    function ignoreTypes(midiSysex:Bool = true, midiTime:Bool = true, midiSense:Bool = true):Void;

    inline function getMessage(message:haxe.io.BytesData):Float {
        untyped __cpp__("std::vector<unsigned char> __msg");
        untyped __cpp__("double __stamp = {0}->getMessage(&__msg)", this);
        untyped __cpp__("int __msgSize = __msg.size()");
        untyped __cpp__("{0}->__SetSize(__msgSize)", message);
        untyped __cpp__("memcpy({0}->GetBase(), __msg.data(), __msgSize)", message);
        return cast untyped __cpp__("__stamp");
    }
    // function setErrorCallback(callback:RtMidiErrorCallback):Void
}

private typedef InternalCallbackInfo = {
    callback:Callback,
    userData:Dynamic,
    midiObj:RtMidiIn
}

@:allow(rtmidi.RtMidiIn)
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

    static function set_callback(midiin:RtMidiIn, cb:Callback, userData:Dynamic):Void {
        if(!internal_cb_set) {
            internal_cb_set = true;
            @:privateAccess RtMidiIn.init_callback(cpp.Callable.fromStaticFunction(internal_callback));
        }

        callbacks.set(nextID, {
            callback:cb,
            userData:userData,
            midiObj:midiin
        });

        @:privateAccess RtMidiIn.set_callback(midiin, nextID);
        nextID++;
    }

    static function cancel_callback(midiin:RtMidiIn):Void {
        for(key in callbacks.keys()) {
            var val:RtMidiIn = callbacks.get(key).midiObj;
            if(val == midiin) {
                @:privateAccess midiin.cancel_callback();
                callbacks.remove(key);
                return;
            }
        }
    }
}

typedef Callback = Float->haxe.io.BytesData->Dynamic->Void;