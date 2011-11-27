#include "jsc-perl.h"


MODULE = JavaScriptCore::JSContext  PACKAGE = JavaScriptCore::JSContext


JSPObject*
MakeArray (JSContext ctx, AV *av)
    PREINIT:
        JSObjectRef js_object;
        JSValueRef  exception;
        JSPObject   *p_object;
        size_t count;
        JSValueRef  *args;

    CODE:
        if (av != NULL && SvOK(av)) {
            size_t i = 0;
            count = av_len(av) + 1;
            args = malloc(sizeof(JSValueRef) * count);

            for (i = 0; i < count; ++i) {
                SV **sv_ref;

                sv_ref = av_fetch(av, i, FALSE);
                args[i] = jsc_sv_to_js(JSValueRef, *sv_ref);
            }
        }
        else {
            count = 0;
            args = NULL;
        }

        exception = NULL;
        js_object = JSObjectMakeArray(ctx, count, args, &exception);
        if (exception != NULL) jsc_perl_throw_exception(ctx, exception);

        if (js_object == NULL) {
            RETVAL = NULL;
        }
        else {
            p_object = malloc(sizeof(JSPObject));
            p_object->ctx = ctx;
            JSGlobalContextRetain((JSGlobalContextRef) p_object->ctx);

            p_object->obj = js_object;
            RETVAL = p_object;
        }

    OUTPUT:
        RETVAL



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

