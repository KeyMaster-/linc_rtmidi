
import rtmidi.*;
import rtmidi.RtMidi.Api;

    #if (!mac && !android && !ios && !linux && !windows)
        #error "You should define a target, please read and modify build.hxml"
    #end


class Test {

    static function main() {
        trace(RtMidi.getVersion());
        var apis_ = RtMidi.getCompiledApi();
        trace('The following APIs are available:');
        for(api in apis_) {
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

        var nPorts:Int = midiin.getPortCount();
        trace('There are $nPorts MIDI input sources available.');

        for(i in 0...nPorts) {
            var portName = midiin.getPortName(i);
            trace('Input Port #${i+1}: $portName');
        }

        midiin.openPort(0);
        midiout.openPort(0);

        midiin.setCallback();

        var firstTime = haxe.Timer.stamp();
        while(haxe.Timer.stamp() - firstTime < 5) {}

        // var buttonActivated:Array<Bool> = [for(i in 0...72) false];

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

        midiout.destroy();
        midiin.destroy();
    } //main

    // function test(cb:Float->haxe.io.BytesData->Dynamic->Void):Void {
    //     trace(cb);
    // }

    // function test2(a:Float, b:haxe.io.BytesData, c:Dynamic):Void {
    //     trace('something');
    // }

} //Test