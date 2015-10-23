import rtmidi.RtMidi.ErrorType;
import rtmidi.RtMidiOut;

    #if (!mac && !android && !ios && !linux && !windows)
        #error "You should define a target, please read and modify build.hxml"
    #end

    // Example usage the error callback
class Main {
    static function main() {
        var midiout = new RtMidiOut();
        var nPorts = midiout.getPortCount();
        if(nPorts == 0) {
            midiout.openPort(0); //This will call the default error callback, raising a 'no devices found' error
        }
        else {
            midiout.openPort(0);
            midiout.openPort(0); //This will call the default error callback, triggering a warning that a connection already existed
        }

        midiout.setErrorCallback(errorCallback);

        midiout.openPort(0); //This time, the custom error callback will be called, showing either a 'no devices found' error or a warning

        midiout.destroy();
    } //main

    static function errorCallback(type:ErrorType, message:String) {
        trace('${getErrorString(type)}: $message');
    } //errorCallback

    static function getErrorString(type:ErrorType):String {
        switch(type) {
            case WARNING:
                return 'WARNING';
            case DEBUG_WARNING:
                return 'DEBUG_WARNING';
            case UNSPECIFIED:
                return 'UNSPECIFIED';
            case NO_DEVICES_FOUND:
                return 'NO_DEVICES_FOUND';
            case INVALID_DEVICE:
                return 'INVALID_DEVICE';
            case MEMORY_ERROR:
                return 'MEMORY_ERROR';
            case INVALID_PARAMETER:
                return 'INVALID_PARAMETER';
            case INVALID_USE:
                return 'INVALID_USE';
            case DRIVER_ERROR:
                return 'DRIVER_ERROR';
            case SYSTEM_ERROR:
                return 'SYSTEM_ERROR';
            case THREAD_ERROR:
                return 'THREAD_ERROR';
        } //switch type
    } //getErrorString
} //Main