#ifndef _LINC_RTMIDI_CPP_
#define _LINC_RTMIDI_CPP_

#include <hxcpp.h>
#include "./linc_rtmidi.h"

namespace linc {
    namespace rtmidi {
        static InternalInputCallbackFN input_fn = 0;
        static bool inited_callback = false;
        static void InternalInputCallback(double delta, std::vector< unsigned char> *message, void * userData) {
            // ::cpp::Pointer<RtMidiIn>* midiin = (::cpp::Pointer<RtMidiIn>*)userData;
            int* id = (int*)userData;
            int msgSize = message->size();

            cpp::ArrayBase _message = Array_obj<unsigned char>::__new(msgSize, 0);
            memcpy(_message->GetBase(), message->data(), msgSize);

            // input_fn((Float)delta, _message, *midiin);
            input_fn((Float)delta, _message, *id);
        }

        void set_callback(::cpp::Pointer<RtMidiIn> midiin, int id) {
            int* _id = new int(id);
            midiin->get_raw()->setCallback(&InternalInputCallback, _id);
        }

        void init_callback(InternalInputCallbackFN fn) {
            if(inited_callback) return;

            input_fn = fn;

            inited_callback = true;
        }
        // void 
    } // rtmidi
} // linc

#endif //_LINC_RTMIDI_CPP_