#include "jsc-perl.h"


#define RET_BOOL(exp) RETVAL = (exp) ? &PL_sv_yes : &PL_sv_no


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
        RET_BOOL(JSValueIsUndefined(self->ctx, self->val));

    OUTPUT:
        RETVAL


SV*
IsNull (JSPValue *self)
    CODE:
        RET_BOOL(JSValueIsNull(self->ctx, self->val));

    OUTPUT:
        RETVAL


SV*
IsBoolean (JSPValue *self);
    CODE:
        RET_BOOL(JSValueIsBoolean(self->ctx, self->val));

    OUTPUT:
        RETVAL


SV*
IsNumber (JSPValue *self);
    CODE:
        RET_BOOL(JSValueIsNumber(self->ctx, self->val));

    OUTPUT:
        RETVAL


SV*
IsString (JSPValue *self);
    CODE:
        RET_BOOL(JSValueIsString(self->ctx, self->val));

    OUTPUT:
        RETVAL


SV*
IsObject (JSPValue *self);
    CODE:
        RET_BOOL(JSValueIsObject(self->ctx, self->val));

    OUTPUT:
        RETVAL


void
DESTROY (JSPValue *self)
    CODE:
        JSValueUnprotect(self->ctx, self->val);
        JSGlobalContextRelease((JSGlobalContextRef) self->ctx);
        Safefree(self);
