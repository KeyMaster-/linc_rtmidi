#ifndef _LINC_RTMIDI_H_
#define _LINC_RTMIDI_H_

#include "../lib/rtmidi/RtMidi.h"
#include <hxcpp.h>

namespace linc {
    namespace rtmidi {
        typedef ::cpp::Function < Void(Float, Array<unsigned char>, int) > InternalInputCallbackFN;
        typedef ::cpp::Function < Void(int, ::String) > InternalErrorCallbackFN;
        extern void initInputCallback(InternalInputCallbackFN callback);
        extern void setInputCallback(::cpp::Pointer<RtMidiIn> midiin, int id);
        extern void initErrorCallback(InternalErrorCallbackFN callback);
        extern void setErrorCallback(::cpp::Pointer<RtMidi> midi);
    }
}

#endif // _LINC_RTMIDI_H_