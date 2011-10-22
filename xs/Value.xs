#include "jsc-perl.h"


MODULE = JavaScriptCore::JSContext  PACKAGE = JavaScriptCore::JSContext  PREFIX = JSContext


JSPValue*
MakeUndefined (JSContext ctx)
    PREINIT:
        JSPValue *p_value;

    CODE:
        Newxz(p_value, 1, JSPValue);
        p_value->ctx = ctx;
        p_value->val = JSValueMakeUndefined(ctx);
        JSGlobalContextRetain((JSGlobalContextRef) p_value->ctx);
        RETVAL = p_value;

    OUTPUT:
        RETVAL


MODULE = JavaScriptCore::JSValue  PACKAGE = JavaScriptCore::JSValue  PREFIX = JSValue


void
DESTROY (JSPValue *self)
    CODE:
        JSValueUnprotect(self->ctx, self->val);
        JSGlobalContextRelease((JSGlobalContextRef) self->ctx);
        Safefree(self);
