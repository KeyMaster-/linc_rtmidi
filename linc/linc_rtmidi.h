#ifndef _LINC_RTMIDI_H_
#define _LINC_RTMIDI_H_

#include "../lib/rtmidi/RtMidi.h"
#include <hxcpp.h>

namespace linc {
    namespace rtmidi {
        typedef ::cpp::Function < Void(int) > InternalInputCallbackFN;
        extern void set_callback(RtMidiIn* midiin);
        extern void init_callback(InternalInputCallbackFN callback);
        // extern void set_input_callback( RtMidiIn* midiin, InternalTimerCallbackFN fn );
         // void InternalInputCallback(double delta, std::vector< unsigned char > *message, void * userData);
    }
}

#endif // _LINC_RTMIDI_H_