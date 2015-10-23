import rtmidi.RtMidiIn;
import rtmidi.RtMidiOut;
import rtmidi.RtMidi;

    #if (!mac && !android && !ios && !linux && !windows)
        #error "You should define a target, please read and modify build.hxml"
    #end

    // Example usage of midi input, using the message queue
class Main {
    static function main() {
        var midiin = new RtMidiIn();
        if(!chooseMidiPort(midiin)) {
            midiin.destroy();
            return;
        }
        midiin.ignoreTypes(false, false, false);

        Sys.println('Reading MIDI input for 5 seconds...');
        var stamp:Float;
        var message = haxe.io.Bytes.alloc(1);

        var t:Float = haxe.Timer.stamp();
        while(haxe.Timer.stamp() - t < 5) { // run for 5 seconds

            var stamp = midiin.getMessage(message.getData());
            var msgLength = message.getData().length;
            for(i in 0...msgLength){
                Sys.print('Byte $i = ${message.get(i)}, ');
            }
            if(msgLength > 0) {
                Sys.print('stamp = $stamp\n');
            }

            Sys.sleep(0.01);
        }

        midiin.destroy();
    } //main

    static function chooseMidiPort(rtmidi:RtMidi):Bool {
        Sys.print('Would you like to open a virtual input port? [y/n] ');
        var input = Sys.stdin().readLine();
        if(input == 'y') {
            rtmidi.openVirtualPort();
            return true;
        }
        Sys.print('\n');

        var i = 0;
        var nPorts = rtmidi.getPortCount();

        if(nPorts == 0) {
            Sys.println('No input ports available!');
            return false;
        }

        if(nPorts == 1) {
            Sys.println('Opening ${rtmidi.getPortName()}');
        }
        else {
            var portName = '';
            for(i in 0...nPorts) {
                portName = rtmidi.getPortName(i);
                Sys.println('  Input port #$i: $portName');
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