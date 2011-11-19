#include "jsc-perl.h"


MODULE = JavaScriptCore::JSObject  PACKAGE = JavaScriptCore::JSObject


JSPValue*
GetPrototype(JSPObject *self)
    PREINIT:
        JSValueRef js_prototype;
        JSPValue   *p_retval;
        JSContext ctx;

    CODE:
        ctx = self->ctx;
        js_prototype = JSObjectGetPrototype(self->ctx, self->obj);

        RETVAL = malloc(sizeof(JSPObject));
        RETVAL->ctx = self->ctx;
        JSGlobalContextRetain((JSGlobalContextRef) RETVAL->ctx);
        RETVAL->val = js_prototype;

    OUTPUT:
        RETVAL


void
DESTROY (JSPObject *self)
    CODE:
        JSValueUnprotect(self->ctx, self->obj);
        JSGlobalContextRelease((JSGlobalContextRef) self->ctx);
        free(self);

