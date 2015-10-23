import rtmidi.RtMidiIn;
import rtmidi.RtMidiOut;
import rtmidi.RtMidi;

    #if (!mac && !android && !ios && !linux && !windows)
        #error "You should define a target, please read and modify build.hxml"
    #end

    // A demo for the Launchpad S, using the message queue for input
class Main {
    static function main() {
        var midiin = new RtMidiIn();
        if(!chooseMidiPort(midiin, 'input')) {
            midiin.destroy();
            return;
        }

        var midiout = new RtMidiOut();
        if(!chooseMidiPort(midiout, 'output')) {
            midiin.destroy();
            midiout.destroy();
            return;
        }

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

    static function chooseMidiPort(rtmidi:RtMidi, portTypeString:String):Bool {
        Sys.print('Would you like to open a virtual $portTypeString port? [y/n] ');
        var input = Sys.stdin().readLine();
        if(input == 'y') {
            rtmidi.openVirtualPort();
            return true;
        }
        Sys.print('\n');

        var i = 0;
        var nPorts = rtmidi.getPortCount();

        if(nPorts == 0) {
            Sys.println('No $portTypeString ports available!');
            return false;
        }

        if(nPorts == 1) {
            Sys.println('Opening ${rtmidi.getPortName()}');
        }
        else {
            var portName = '';
            for(i in 0...nPorts) {
                portName = rtmidi.getPortName(i);
                Sys.println('  $portTypeString port #$i: $portName');
            }
            do {
                Sys.print('\nChoose a port number: ');
                i = Std.parseInt(Sys.stdin().readLine());
            } while (i >= nPorts);
        }

        Sys.print('\n');
        rtmidi.openPort(i);

        return true;
    }
} //Main