
import rtmidi.RtMidiIn;

    #if (!mac && !android && !ios && !linux && !windows)
        #error "You should define a target, please read and modify build.hxml"
    #end


class Test {

    static function main() {
        var midiin:RtMidiIn = RtMidiIn.create();

        //api trace

        var nPorts:Int = midiin.getPortCount();
        trace('There are $nPorts MIDI input sources available.');

        for(i in 0...nPorts) {
            var portName = midiin.getPortName(i);
            trace('Input Port #${i+1}: $portName');
        }

        midiin.openPort(0);
        trace(midiin.isPortOpen());

        var into:haxe.io.BytesData = haxe.io.Bytes.alloc(3).getData();
        var stmp:Float = 0;
        var firstTime = haxe.Timer.stamp();
        while(haxe.Timer.stamp() - firstTime < 5) {
            stmp = midiin.getMessage(into);
            if(into.length > 0) {
                var s = '';
                for(n in 0...into.length) s += 'Byte $n = ${into[n]}, ';
                s += 'stamp = $stmp';
                trace(s);
            }
        }

        // trace(midiin.getPortCount());
        // trace(midiin.isPortOpen());
        // midiin.openVirtualPort('SomeVirtualPort');
        // trace(midiin.getPortName(0));
        // trace(midiin.getPortCount());
        // trace(midiin.isPortOpen());
        // midiin.closePort();
        // trace(midiin.isPortOpen());
        // midiin.openPort(0, "PortName");
        // trace(midiin.isPortOpen());
        // midiin.closePort();
        midiin.destroy();
        // midiin.openVirtualPort('SomeVirtualPort');
        // trace(midiin.getPortCount());
        
    } //main

} //Test