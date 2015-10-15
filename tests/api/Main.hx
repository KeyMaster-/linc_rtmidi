import rtmidi.RtMidiOut;
import rtmidi.RtMidiIn;
import rtmidi.RtMidi;
import rtmidi.RtMidi.Api;

    #if (!mac && !android && !ios && !linux && !windows)
        #error "You should define a target, please read and modify build.hxml"
    #end


class Main {

    static function main() {
        trace(RtMidi.getVersion());
        var apis = RtMidi.getCompiledApi();
        trace('The following APIs are available:');
        for(api in apis) {
            printApi(api);
        }

        var midiin = new RtMidiIn();
        trace('The current midi in api:');
        printApi(midiin.getCurrentApi());

        var midiout = new RtMidiOut();
        trace('The current midi out api:');
        printApi(midiout.getCurrentApi());
        
        midiout.destroy();
        midiin.destroy();
    } //main

    static function printApi(api:Api) {
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
} //Test