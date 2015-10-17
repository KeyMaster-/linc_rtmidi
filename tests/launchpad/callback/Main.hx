import rtmidi.RtMidiIn;
import rtmidi.RtMidiOut;
import rtmidi.RtMidi;
import rtmidi.RtMidi.ErrorType;
class Main {
    static function main() {
        var midiin = new RtMidiIn();
        
        var nPorts:Int = midiin.getPortCount();

        midiin.setErrorCallback(cb);
        var midiout = new RtMidiOut();
        // midiin.openPort(0);
        midiout.openPort(0);

        if(nPorts == 0)  {
            trace('No input ports available, exiting!');
            midiin.destroy();
            return;
        }
        

        var buttonActivated:Array<Bool> = [for(i in 0...72) false];

        var done = false;
        midiin.setCallback(
            function(delta:Float, data:haxe.io.BytesData, userData:Dynamic) {
                var message = haxe.io.Bytes.ofData(data);
                if(message.get(2) == 0 || message.get(0) == 176) return;
                var key = message.get(1);
                var row = Math.floor(key / 16);
                var column = key % 16;
                if(row == 7 && column == 8) {
                    //turn everything off
                    message.set(0, 176); 
                    message.set(1, 0);
                    message.set(2, 0);
                    midiout.sendMessage(message.getData());
                    done = true;
                    return;
                }

                userData[row * 8 + column] = !userData[row * 8 + column];
                if(userData[row * 8 + column]) {
                    //set pressed button to full bright yellow
                    message.set(0, 144);
                    message.set(1, key);
                    message.set(2, 16 * 3 + 3 + 12);
                    midiout.sendMessage(message.getData());
                }
                else {
                    // turn pressed key off
                    message.set(0, 128);
                    message.set(1, key);
                    midiout.sendMessage(message.getData());
                }
                trace('row: $row, column: $column');

            }, 
            buttonActivated);

        while(!done) {}

        midiin.cancelCallback();

        midiout.destroy();
        midiin.destroy();
    } //main

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
        }

    }

    static function cb(type:ErrorType, msg:String):Void {
        trace('${getErrorString(type)}: $msg');
    }

} //Test