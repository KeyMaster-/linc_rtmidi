#ifndef _LINC_RTMIDI_H_
#define _LINC_RTMIDI_H_

#include "../lib/rtmidi/RtMidi.h"
#include <hxcpp.h>

namespace linc {
    namespace rtmidi {
        typedef ::cpp::Function < Void(Float, Array<unsigned char>, int) > InternalInputCallbackFN;
        extern void set_callback(::cpp::Pointer<RtMidiIn> midiin, int id);
        extern void init_callback(InternalInputCallbackFN callback);
    }
}

#endif // _LINC_RTMIDI_H_