import rtmidi.RtMidiIn;
import rtmidi.RtMidiOut;
import rtmidi.RtMidi;

    #if (!mac && !android && !ios && !linux && !windows)
        #error "You should define a target, please read and modify build.hxml"
    #end

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

        var userData = {
            buttons:buttonActivated,
            done:false
        }
        
        midiin.setCallback(
            function(delta:Float, data:haxe.io.BytesData, userData:Dynamic) {
                var message = haxe.io.Bytes.ofData(data);
                if(message.get(2) == 0 || message.get(0) == 176) return; //ignore button up events
                var key = message.get(1);
                var row = Math.floor(key / 16);
                var column = key % 16;
                if(row > 7 || column > 8) return;
                if(row == 7 && column == 8) {
                    //turn everything off
                    message.set(0, 176); 
                    message.set(1, 0);
                    message.set(2, 0);
                    midiout.sendMessage(message.getData());
                    userData.done = true;
                    return;
                }

                userData.buttons[row * 8 + column] = !userData.buttons[row * 8 + column];
                if(userData.buttons[row * 8 + column]) {
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

            }, //callback function 
            userData);

        while(!userData.done) {}

        midiin.cancelCallback();

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