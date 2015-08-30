package rtmidi;

@:include('linc_rtmidi.h')
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('rtmidi'))

@:native('RtMidiIn*')
extern class RtMidiIn {
    @:native('new RtMidiIn')
    static function create():RtMidiIn;
    
    inline function destroy():Void {
        untyped __cpp__("delete {0}; {0} = NULL;", this);
    }

    // @:native('getVersion')
    // static function getVersion():String;

    // static function getCompiledApi():Array<Api>; //inherited from RtMidi

    // getCurrentApi():Api;

    @:native('openPort')
    private function _openPort(portNumber:UInt = 0, portName:cpp.ConstCharStar):Void;
    inline function openPort(portNumber:UInt = 0, portName:String = "RtMidi Input"):Void return _openPort(portNumber, cast portName);

    @:native('openVirtualPort')
    private function _openVirtualPort(portName:cpp.ConstCharStar):Void;
    inline function openVirtualPort(portName:String = "RtMidi Input"):Void return _openVirtualPort(cast portName);

    // function setCallback(callback:RtMidiCallback, userData:Dynamic):Void

    @:native('cancelCallback')
    function cancelCallback():Void;

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

    inline function getMessage(into:haxe.io.BytesData):Int {
        untyped __cpp__("std::vector<unsigned char> msg"); //possible var name conflict
        untyped __cpp__("double stamp"); //possible var name conflict
        untyped __cpp__("stamp = {0}->getMessage(&msg)", this);
        untyped __cpp__("{0}->__SetSize(msg.size());", into); //msg.size() could be put into an int, but more name conflicts possible then
        untyped __cpp__("for(int i=0; i<msg.size(); i++) {0}->__unsafe_set(i, msg[i]);", into);
        return untyped __cpp__("stamp");
    }

    // function setErrorCallback(callback:RtMidiErrorCallback):Void
}