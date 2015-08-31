package rtmidi;
import rtmidi.RtMidi.Api;

// @:include('linc_rtmidi.h')
@:native('RtMidiIn*')
extern class RtMidiIn extends RtMidi {
    static inline function create(api:Api = Api.UNSPECIFIED, clientName:String = "RtMidi Input Client", queueSizeLimit:UInt = 100):RtMidiIn {
        return cast untyped __cpp__("new RtMidiIn((RtMidi::Api)({0}), (const ::cpp::Char *){1}, {2})", api, clientName, queueSizeLimit); //:todo: manual cast to ConstCharStar okay?
    }
    
    inline function destroy():Void {
        untyped __cpp__("delete {0}; {0} = NULL", this);
    }

    @:native('getCurrentApi')
    function getCurrentApi():Api;

    @:native('openPort')
    private function _openPort(portNumber:UInt = 0, portName:cpp.ConstCharStar):Void;
    inline function openPort(portNumber:UInt = 0, portName:String = "RtMidi Input"):Void _openPort(portNumber, cast portName);

    @:native('openVirtualPort')
    private function _openVirtualPort(portName:cpp.ConstCharStar):Void;
    inline function openVirtualPort(portName:String = "RtMidi Input"):Void _openVirtualPort(cast portName);

    // function setCallback(callback:RtMidiCallback, userData:Dynamic):Void
    // test: create cpp function in linc_rtmidi.h, set it as callback in inline haxe function, cout stuff in the cpp function

    // inline function setCallback(callback:Callback, userData:Dynamic):Void {
    //     var _callback = callback.bind(_, _, userData);
    //     untyped __cpp__("{0}->setCallback(&linc::rtmidi::testCb)", this);
    // }

    // inline function setCallback(callback:Callback, userData:Dynamic):Void {

    // }
    // inline function setCallback(callback:Callback, userData:Dynamic):Void {
    inline function setCallback():Void {
        if(!RtMidiIn_helper.callback_set) {
            RtMidiIn_helper.callback_set = true;
            init_callback(cpp.Callable.fromStaticFunction(RtMidiIn_helper.input_callback));
        }

        set_callback(this);

        //save hx callback
    }

    @:native('linc::rtmidi::init_callback')
    private static function init_callback(cb:cpp.Callable<Int->Void>):Void;

    @:native('linc::rtmidi::set_callback')
    private static function set_callback(midiin:RtMidiIn):Void;

    @:native('cancelCallback')
    function cancelCallback():Void; //change to use helper

    @:native('closePort')
    function closePort():Void;

    @:native('isPortOpen')
    function isPortOpen():Bool;

    @:native('getPortCount')
    function getPortCount():UInt;

    inline function getPortName(portNumber:UInt = 0):String {
        return cast untyped __cpp__("{0}->getPortName({1}).c_str()", this, portNumber);
    }

    @:native('ignoreTypes')
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

@:allow(rtmidi.RtMidiIn)
@:include('linc_rtmidi.h')
private class RtMidiIn_helper {
    static var callback_set:Bool = false;
    static function input_callback(_id:Int):Void {
        trace(_id);
    }
    // static function setCallback(midiIn:RtMidiIn, callback:Callback, userData:Dynamic):Void {

    // }
}

typedef Callback = Float->haxe.io.BytesData->Dynamic->Void;