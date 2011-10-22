#include "jsc-perl.h"


MODULE = JavaScriptCore::JSGlobalContext  PACKAGE = JavaScriptCore::JSGlobalContext  PREFIX = JSGlobalContext


JSGlobalContext
JSGlobalContextCreate (SV *class)
    C_ARGS: /* FIXME need a JSClassRef */ NULL


JSGlobalContext
JSGlobalContextCreateInGroup (SV *class, JSContextGroup group)
    C_ARGS: group, NULL /* fixme , JSClass globalObjectClass */


void
GarbageCollect (JSGlobalContext self)
    CODE:
        JSGarbageCollect(self);


void
DESTROY (JSGlobalContext self)
    CODE:
        JSGlobalContextRelease(self);
