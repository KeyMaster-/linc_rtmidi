import rtmidi.RtMidiIn;
import rtmidi.RtMidiOut;

    #if (!mac && !android && !ios && !linux && !windows)
        #error "You should define a target, please read and modify build.hxml"
    #end

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

        var message:haxe.io.Bytes = haxe.io.Bytes.alloc(3);
        while(true) {
            midiin.getMessage(message.getData());
            if(message.getData().length > 0) {
                if(message.get(2) == 0) continue; //ignore button up

                var key = message.get(1);
                var row = Math.floor(key / 16);
                var column = key % 16;

                if(row > 7 || column > 8) continue;
                if(row == 7 && column == 8) break;

                buttonActivated[row * 8 + column] = !buttonActivated[row * 8 + column];
                if(buttonActivated[row * 8 + column]) {
                    //Turn pressed button on to full bright yellow
                    message.set(0, 144);
                    message.set(1, key);
                    message.set(2, 16 * 3 + 3 + 12);
                    midiout.sendMessage(message.getData());
                }
                else {
                    //Turn pressed button off
                    message.set(0, 128);
                    message.set(1, key);
                    midiout.sendMessage(message.getData());
                }
                trace('row: $row, column: $column');
            }
        }
        
        //Turn the whole launchpad off
        message.set(0, 176);
        message.set(1, 0);
        message.set(2, 0);
        midiout.sendMessage(message.getData());

        midiout.destroy();
        midiin.destroy();
    } //main
} //Main