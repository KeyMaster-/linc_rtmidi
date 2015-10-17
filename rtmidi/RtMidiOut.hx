package rtmidi;

@:forward(destroy, getCurrentApi, openPort, closePort, isPortOpen, getPortCount, getPortName, sendMessage, setErrorCallback)
abstract RtMidiOut(ExternRtMidiOut) {
    inline public function new() {
        this = @:privateAccess ExternRtMidiOut.create();
        @:privateAccess this.onCreate(toRtMidi());
    }

    @:from
    static public inline function fromRtMidi(rtmidi:RtMidi):RtMidiOut {
        return untyped __cpp__("{0}->reinterpret()", rtmidi);
    }

    @:to
    public inline function toRtMidi():RtMidi {
        return untyped __cpp__("{0}->reinterpret()", this);
    }

    public inline function openPort(portNumber:UInt = 0, portName:String = "RtMidi Output"):Void {
        this.openPort(portNumber, portName);
    }

    public inline function openVirtualPort(portName:String = "RtMidi Output"):Void {
        this.openVirtualPort(portName);
    }

}