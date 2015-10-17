import rtmidi.RtMidi;
import rtmidi.RtMidiIn;
import rtmidi.RtMidiOut;

    #if (!mac && !android && !ios && !linux && !windows)
        #error "You should define a target, please read and modify build.hxml"
    #end

class Main {
    static function main() {
        trace('RtMidi version: ' + RtMidi.getVersion());

        var apis = RtMidi.getCompiledApi();
        trace('Compiled APIs:');
        for(api in apis) {
            trace(getApiString(api));
        }

        var midiin = new RtMidiIn();
        trace('Current input API: ' + getApiString(midiin.getCurrentApi()));

        var nPorts:Int = midiin.getPortCount();
        trace('There are $nPorts MIDI input sources available.');

        for(i in 0...nPorts) {
            var portName = midiin.getPortName(i);
            trace('  Input Port #${i+1}: $portName');
        }

        var midiout = new RtMidiOut();
        trace('Current output API: ' + getApiString(midiin.getCurrentApi()));

        nPorts = midiout.getPortCount();
        trace('There are $nPorts MIDI output ports available.');

        for(i in 0...nPorts) {
            var portName = midiout.getPortName(i);
            trace('  Output Port #${i+1}: $portName');
        }

        midiout.destroy();
        midiin.destroy();
    } //main

    static function getApiString(api:Api):String {
        switch(api) {
            case Api.UNSPECIFIED:
                return 'Unspecified';
            case Api.MACOSX_CORE:
                return 'OS-X CoreMidi';
            case Api.LINUX_ALSA:
                return 'Linux ALSA';
            case Api.UNIX_JACK:
                return 'Jack Client';
            case Api.WINDOWS_MM:
                return 'Windows MultiMedia';
            case Api.RTMIDI_DUMMY:
                return 'RtMidi Dummy';
        } //switch api
    } //getApiString
} //Main