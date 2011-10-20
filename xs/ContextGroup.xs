#include "jsc-perl.h"


MODULE = JavaScriptCore::JSContextGroup  PACKAGE = JavaScriptCore::JSContextGroup  PREFIX = JSContextGroup


JSContextGroup
SContextGroupCreate(SV *class)
    C_ARGS: /* empty */


void
DESTROY(JSContextGroup self)
    CODE:
        JSContextGroupRelease(self);
