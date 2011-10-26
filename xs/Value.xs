#include "jsc-perl.h"


#define RET_BOOL(exp) RETVAL = (exp) ? &PL_sv_yes : &PL_sv_no


MODULE = JavaScriptCore::JSContext  PACKAGE = JavaScriptCore::JSContext  PREFIX = JSContext


JSPValue*
MakeUndefined (JSContext ctx)
    PREINIT:
        JSPValue *p_value;

    CODE:
        p_value = malloc(sizeof(JSPValue));
        p_value->ctx = ctx;
        JSGlobalContextRetain((JSGlobalContextRef) p_value->ctx);

        p_value->val = JSValueMakeUndefined(ctx);
        RETVAL = p_value;

    OUTPUT:
        RETVAL


JSPValue*
MakeNull (JSContext ctx)
    PREINIT:
        JSPValue *p_value;

    CODE:
        p_value = malloc(sizeof(JSPValue));
        p_value->ctx = ctx;
        JSGlobalContextRetain((JSGlobalContextRef) p_value->ctx);

        p_value->val = JSValueMakeNull(ctx);
        RETVAL = p_value;

    OUTPUT:
        RETVAL


JSPValue*
MakeBoolean (JSContext ctx, bool value)
    PREINIT:
        JSPValue *p_value;

    CODE:
        p_value = malloc(sizeof(JSPValue));
        p_value->ctx = ctx;
        JSGlobalContextRetain((JSGlobalContextRef) p_value->ctx);

        p_value->val = JSValueMakeBoolean(ctx, value);
        RETVAL = p_value;

    OUTPUT:
        RETVAL


JSPValue*
MakeNumber (JSContext ctx, double value)
    PREINIT:
        JSPValue *p_value;

    CODE:
        p_value = malloc(sizeof(JSPValue));
        p_value->ctx = ctx;
        JSGlobalContextRetain((JSGlobalContextRef) p_value->ctx);

        p_value->val = JSValueMakeNumber(ctx, value);
        RETVAL = p_value;

    OUTPUT:
        RETVAL


JSPValue*
MakeString (JSContext ctx, SV *value)
    PREINIT:
        JSPValue *p_value;
        JSStringRef js_string;
        const JSChar *str;
        size_t len;

    CODE:
        p_value = malloc(sizeof(JSPValue));
        p_value->ctx = ctx;
        JSGlobalContextRetain((JSGlobalContextRef) p_value->ctx);

        str = (const JSChar *) SvPV(value, len);
        js_string = JSStringCreateWithCharacters(str, len);
        p_value->val = JSValueMakeString(ctx, js_string);
        JSStringRelease(js_string);

        RETVAL = p_value;

    OUTPUT:
        RETVAL


JSPValue*
MakeFromJSONString (JSContext ctx, SV *value)
    PREINIT:
        JSPValue *p_value;
        JSStringRef js_string;
        const JSChar *str;
        size_t len;

    CODE:
        p_value = malloc(sizeof(JSPValue));
        p_value->ctx = ctx;
        JSGlobalContextRetain((JSGlobalContextRef) p_value->ctx);

        str = (const JSChar *) SvPV(value, len);
        js_string = JSStringCreateWithCharacters(str, len);
        p_value->val = JSValueMakeFromJSONString(ctx, js_string);
        JSStringRelease(js_string);

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


SV*
CreateJSONString (JSPValue *self, int indent = 0)
    PREINIT:
        JSValueRef exception;
        JSStringRef json;

    CODE:
        exception = NULL;

        json = JSValueCreateJSONString(self->ctx, self->val, indent, &exception);
        if (json == NULL) {
            RETVAL = &PL_sv_undef;
        }
        else {
            char *str;
            size_t size;

            size = JSStringGetMaximumUTF8CStringSize(json);
            str = malloc(size);
            JSStringGetUTF8CString(json, str, size);
            RETVAL = newSVpv(str, 0);
            free(str);
        }

    OUTPUT:
        RETVAL


SV*
ToPerl (JSPValue *self)
    CODE:
        RETVAL = jsc_perl_js_value_to_sv(self->ctx, self->val);

    OUTPUT:
        RETVAL


void
DESTROY (JSPValue *self)
    CODE:
        JSValueUnprotect(self->ctx, self->val);
        JSGlobalContextRelease((JSGlobalContextRef) self->ctx);
        free(self);

