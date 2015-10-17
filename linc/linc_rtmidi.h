#ifndef _LINC_RTMIDI_H_
#define _LINC_RTMIDI_H_

#include "../lib/rtmidi/RtMidi.h"
#include <hxcpp.h>

namespace linc {
    namespace rtmidi {
        typedef ::cpp::Function < Void(Float, Array<unsigned char>, int) > InternalInputCallbackFN;
        typedef ::cpp::Function < Void(int, ::String) > InternalErrorCallbackFN;
        extern void init_input_callback(InternalInputCallbackFN callback);
        extern void set_input_callback(::cpp::Pointer<RtMidiIn> midiin, int id);
        extern void init_error_callback(InternalErrorCallbackFN callback);
        extern void set_error_callback(::cpp::Pointer<RtMidi> midi);
    }
}

#endif // _LINC_RTMIDI_H_