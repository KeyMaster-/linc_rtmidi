import rtmidi.RtMidiIn;
import rtmidi.RtMidiOut;

class Main {

    static function main() {
        var midiin = new RtMidiIn();
        
        var nPorts:Int = midiin.getPortCount();

        if(nPorts == 0)  {
            trace('No input ports available, exiting!');
            midiin.destroy();
            return;
        }

        var midiout = new RtMidiOut();
        midiin.openPort(0);
        midiout.openPort(0);

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
} //Test