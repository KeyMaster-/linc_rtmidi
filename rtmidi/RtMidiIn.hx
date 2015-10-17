package rtmidi;

@:forward(destroy, getCurrentApi, setCallback, cancelCallback, ignoreTypes, getMessage, openPort, openVirtualPort, closePort, isPortOpen, getPortCount, getPortName, setErrorCallback)
abstract RtMidiIn(ExternRtMidiIn) {
    inline public function new() {
        this = @:privateAccess ExternRtMidiIn.create();
        @:privateAccess this.on_create(toRtMidi());
    }

    @:from
    static public inline function fromRtMidi(rtmidi:RtMidi):RtMidiIn {
        return untyped __cpp__("{0}->reinterpret()", rtmidi);
    }

    @:to
    public inline function toRtMidi():RtMidi {
        return untyped __cpp__("{0}->reinterpret()", this);
    }

    public inline function openPort(portNumber:UInt = 0, portName:String = "RtMidi Input"):Void {
        this.openPort(portNumber, portName);
    }

    public inline function openVirtualPort(portName:String = "RtMidi Input"):Void {
        this.openVirtualPort(portName);
    }

}