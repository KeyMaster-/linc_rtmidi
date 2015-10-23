import rtmidi.RtMidiOut;
import rtmidi.RtMidi;

    #if (!mac && !android && !ios && !linux && !windows)
        #error "You should define a target, please read and modify build.hxml"
    #end

class Main {
    static function main() {
        var midiout = new RtMidiOut();
        if(!chooseMidiPort(midiout)) {
            midiout.destroy();
            return;
        }

        var message:haxe.io.Bytes = haxe.io.Bytes.alloc(2);

        // Program change: 192, 5;
        message.set(0, 192);
        message.set(1, 5);
        midiout.sendMessage(message.getData());

        Sys.sleep(0.5);

        message.set(0, 0xF1);
        message.set(1, 60);
        midiout.sendMessage(message.getData());

        message = haxe.io.Bytes.alloc(3);

        //Control change: 176, 7, 100 (volume)
        message.set(0, 176);
        message.set(1, 7);
        message.set(2, 100);
        midiout.sendMessage(message.getData());

        // Note On: 144, 64, 90
        message.set(0, 144);
        message.set(1, 64);
        message.set(2, 90);
        midiout.sendMessage(message.getData());

        Sys.sleep(0.5);

        //Note off: 128, 64, 40
        message.set(0, 128);
        message.set(1, 64);
        message.set(2, 40);
        midiout.sendMessage(message.getData());

        Sys.sleep(0.5);

        // Control Change: 176, 7, 40
        message.set(0, 176);
        message.set(1, 7);
        message.set(2, 40);
        midiout.sendMessage(message.getData());

        Sys.sleep(0.5);

        message = haxe.io.Bytes.alloc(6);

        // Sysex: 240, 67, 4, 3, 2, 247
        message.set(0, 240);
        message.set(1, 67);
        message.set(2, 4);
        message.set(3, 3);
        message.set(4, 2);
        message.set(5, 247);
        midiout.sendMessage(message.getData());

        midiout.destroy();
    } //main

    static function chooseMidiPort(rtmidi:RtMidiOut):Bool {
        Sys.print('Would you like to open a virtual output port? [y/n] ');
        var input = Sys.stdin().readLine();
        if(input == 'y') {
            rtmidi.openVirtualPort();
            return true;
        }
        Sys.print('\n');

        var i = 0;
        var nPorts = rtmidi.getPortCount();

        if(nPorts == 0) {
            Sys.println('No output ports available!');
            return false;
        }

        if(nPorts == 1) {
            Sys.println('Opening ${rtmidi.getPortName()}');
        }
        else {
            var portName = '';
            for(i in 0...nPorts) {
                portName = rtmidi.getPortName(i);
                Sys.println('  Output port #$i: $portName');
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