
import rtmidi.RtMidiOut;
import rtmidi.RtMidiIn;
import rtmidi.RtMidi;
import rtmidi.RtMidi.Api;

    #if (!mac && !android && !ios && !linux && !windows)
        #error "You should define a target, please read and modify build.hxml"
    #end


class Test {

    static function main() {
        trace(RtMidi.getVersion());
        var apis = RtMidi.getCompiledApi();
        trace('The following APIs are available:');
        for(api in apis) {
            switch(api) {
                case Api.UNSPECIFIED:
                    trace('Unspecified');
                case Api.MACOSX_CORE:
                    trace('Mac OSX Core');
                case Api.LINUX_ALSA:
                    trace('Linux ALSA');
                case Api.UNIX_JACK:
                    trace('Unix Jack');
                case Api.WINDOWS_MM:
                    trace('Windows MM');
                case Api.RTMIDI_DUMMY:
                    trace('RtMidi Dummy');
            }
        }

        var midiin:RtMidiIn = RtMidiIn.create();
        var midiout:RtMidiOut = RtMidiOut.create();

        var b = haxe.io.Bytes.alloc(3).getData();

        var nPorts:Int = midiin.getPortCount();
        trace('There are $nPorts MIDI input sources available.');

        for(i in 0...nPorts) {
            var portName = midiin.getPortName(i);
            trace('Input Port #${i+1}: $portName');
        }

        midiin.openPort(0);
        midiout.openPort(0);

        // var midi:RtMidi = untyped __cpp__( "{0}->reinterpret( )", midiin);
        // var midi:RtMidi = midiin;
        // var dyn:Dynamic = midiin;
        // var midi:RtMidi = dyn;
        // trace(midi.getPortCount());

        // midiin.openVirtualPort();
        // midiout.openVirtualPort();

        var buttonActivated:Array<Bool> = [for(i in 0...72) false];

            // queue input use
        // var message:haxe.io.Bytes = haxe.io.Bytes.alloc(3);
        // while(true) {
        //     midiin.getMessage(message.getData());
        //     if(message.getData().length > 0) { //:todo: fix this?
        //         if(message.get(2) == 0) continue; //ignore button up

        //         var key = message.get(1);
        //         var row = Math.floor(key / 16);
        //         var column = key % 16;

        //         if(row > 7 || column > 8) continue;
        //         if(row == 7 && column == 8) break;

        //         buttonActivated[row * 8 + column] = !buttonActivated[row * 8 + column];
        //         if(buttonActivated[row * 8 + column]) {
        //             message.set(0, 144);
        //             message.set(1, key);
        //             message.set(2, 16 * 3 + 3 + 12); //full bright yellow
        //             midiout.sendMessage(message.getData());
        //         }
        //         else {
        //             message.set(0, 128);
        //             message.set(1, key);
        //             midiout.sendMessage(message.getData());
        //         }
        //         trace('row: $row, column: $column');
        //     }
        // }
        // message.set(0, 176);
        // message.set(1, 0);
        // message.set(2, 0);
        // midiout.sendMessage(message.getData());

            // callback input use
        var done = false;
        midiin.setCallback(
            function(delta:Float, data:haxe.io.BytesData, userData:Dynamic) {
                var message = haxe.io.Bytes.ofData(data);
                if(message.get(2) == 0 || message.get(0) == 176) return;
                var key = message.get(1);
                var row = Math.floor(key / 16);
                var column = key % 16;
                if(row == 7 && column == 8) {
                    message.set(0, 176);
                    message.set(1, 0);
                    message.set(2, 0);
                    midiout.sendMessage(message.getData());
                    done = true;
                    return;
                }

                userData[row * 8 + column] = !userData[row * 8 + column];
                if(userData[row * 8 + column]) {
                    message.set(0, 144);
                    message.set(1, key);
                    message.set(2, 16 * 3 + 3 + 12); //full bright yellow
                    midiout.sendMessage(message.getData());
                }
                else {
                    message.set(0, 128);
                    message.set(1, key);
                    midiout.sendMessage(message.getData());
                }
                trace('row: $row, column: $column');

            }, 
            buttonActivated);

        while(!done) {}

        // var t = haxe.Timer.stamp();
        // while(haxe.Timer.stamp() - t < 5) {}

        midiin.cancelCallback();

        midiout.destroy();
        midiin.destroy();
    } //main
} //Test