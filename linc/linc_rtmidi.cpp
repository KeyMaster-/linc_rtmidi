#ifndef _LINC_RTMIDI_CPP_
#define _LINC_RTMIDI_CPP_

#include <hxcpp.h>
#include "./linc_rtmidi.h"

namespace linc {
    namespace rtmidi {
        static InternalInputCallbackFN input_fn = 0;
        static bool inited_callback = false;
        static void InternalInputCallback(double delta, std::vector< unsigned char > *message, void * userData) {
            // int* callback_id = (int*)userData;
            // input_fn(*callback_id);
            std::cout << "called" << std::endl;
            input_fn(64);
            std::cout << "haxe cb called" << std::endl;
        }

        void set_callback(RtMidiIn* midiin) {
            midiin->setCallback(&InternalInputCallback);
        }

        void init_callback(InternalInputCallbackFN callback) {
            if(inited_callback) return;

            std::cout << "haxe callback set" << std::endl;
            input_fn = callback;

            inited_callback = true;
        }
        // void 
    } // rtmidi
} // linc

#endif //_LINC_RTMIDI_CPP_