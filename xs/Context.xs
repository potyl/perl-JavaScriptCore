#include "jsc-perl.h"


MODULE = JavaScriptCore::JSContext  PACKAGE = JavaScriptCore::JSContext  PREFIX = JSContext


JSContext
JSContextCreate (SV *class)
    CODE:
        /* FIXME need a JSClassRef */
        RETVAL = JSGlobalContextCreate(NULL);

    OUTPUT:
        RETVAL


JSContext
JSContextCreateInGroup (SV *class, JSContextGroup group)
    CODE:
        /* FIXME JSClass globalObjectClass */
        RETVAL = JSGlobalContextCreateInGroup(group, NULL);

    OUTPUT:
        RETVAL


void
GarbageCollect (JSGlobalContext self)
    CODE:
        JSGarbageCollect(self);


JSPValue*
EvaluateScript (JSContext ctx, SV *sv_script, SV *sv_this, SV *sv_src, int line);
    PREINIT:
        JSStringRef script;
        JSObjectRef thisObject;
        JSStringRef sourceURL;
        int startingLineNumber;
        JSValueRef exception;

        const JSChar *str;
        size_t len;
        JSValueRef value;
        JSPValue *p_value;

    CODE:
        str = (const JSChar *) SvPV(sv_script, len);
        script = JSStringCreateWithCharacters(str, len);

        thisObject = NULL; /* FIXME use sv_this */

        str = (const JSChar *) SvPV(sv_script, len);
        sourceURL = JSStringCreateWithCharacters(str, len);

        exception = NULL;

        value = JSEvaluateScript(ctx, script, thisObject, sourceURL, line, &exception);
        JSStringRelease(script);
        JSStringRelease(sourceURL);

        /* FIXME raise an exception */

        Newxz(p_value, 1, JSPValue);
        p_value->ctx = ctx;
        JSGlobalContextRetain((JSGlobalContextRef) p_value->ctx);

        p_value->val = value;
        RETVAL = p_value;

    OUTPUT:
        RETVAL


void
DESTROY (JSGlobalContext self)
    CODE:
        JSGlobalContextRelease(self);
