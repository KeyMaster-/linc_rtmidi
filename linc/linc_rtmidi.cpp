#ifndef _LINC_RTMIDI_CPP_
#define _LINC_RTMIDI_CPP_

#include <hxcpp.h>
#include "./linc_rtmidi.h"

namespace linc {
    namespace rtmidi {
        static InternalInputCallbackFN input_fn = 0;
        static InternalErrorCallbackFN error_fn = 0;
        static bool inited_input_callback = false;
        static bool inited_error_callback = false;

        static void InternalInputCallback(double delta, std::vector< unsigned char> *message, void * userData) {
            int* id = (int*)userData;
            int msgSize = message->size();

            cpp::ArrayBase _message = Array_obj<unsigned char>::__new(msgSize, 0);
            memcpy(_message->GetBase(), message->data(), msgSize);

            input_fn((Float)delta, _message, *id);
        }

        static void InternalErrorCallback(RtMidiError::Type type, const std::string &errorText) {
            error_fn((int)type, (::String)(errorText.c_str()));
        }

        void init_input_callback(InternalInputCallbackFN fn) {
            if(inited_input_callback) return;

            input_fn = fn;

            inited_input_callback = true;
        }

        void set_input_callback(::cpp::Pointer<RtMidiIn> midiin, int id) {
            int* _id = new int(id);
            midiin->get_raw()->setCallback(&InternalInputCallback, _id);
        }

        void init_error_callback(InternalErrorCallbackFN fn) {
            if(inited_error_callback) return;

            error_fn = fn;

            inited_error_callback = true;
        }

        void set_error_callback(::cpp::Pointer<RtMidi> midi) {
            midi->get_raw()->setErrorCallback(&InternalErrorCallback);
        }
        // void 
    } // rtmidi
} // linc

#endif //_LINC_RTMIDI_CPP_