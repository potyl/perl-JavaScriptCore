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


char*
GetType (JSPValue *self)
    CODE:
        switch (JSValueGetType(self->ctx, self->val)) {
            case kJSTypeUndefined:
                RETVAL = "undefined";
            break;

            case kJSTypeNull:
                RETVAL = "null";
            break;

            case kJSTypeBoolean:
                RETVAL = "boolean";
            break;

            case kJSTypeNumber:
                RETVAL = "number";
            break;

            case kJSTypeString:
                RETVAL = "string";
            break;

            case kJSTypeObject:
                RETVAL = "object";
            break;

            default:
                RETVAL = "????";
            break;
        }

    OUTPUT:
        RETVAL


SV*
IsUndefined (JSPValue *self)
    CODE:
        RETVAL = JSValueIsUndefined(self->ctx, self->val)
            ? &PL_sv_yes
            : &PL_sv_no
        ;

    OUTPUT:
        RETVAL


void
DESTROY (JSPValue *self)
    CODE:
        JSValueUnprotect(self->ctx, self->val);
        JSGlobalContextRelease((JSGlobalContextRef) self->ctx);
        Safefree(self);
