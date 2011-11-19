#include "jsc-perl.h"


MODULE = JavaScriptCore::JSObject  PACKAGE = JavaScriptCore::JSObject


void
DESTROY (JSPObject *self)
    CODE:
        JSValueUnprotect(self->ctx, self->obj);
        JSGlobalContextRelease((JSGlobalContextRef) self->ctx);
        free(self);

