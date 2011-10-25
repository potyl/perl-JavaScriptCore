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
        JSValueRef exception;

        JSValueRef value;
        JSPValue *p_value;

    CODE:
        script = JSStringCreateWithUTF8CString(SvPVutf8_nolen(sv_script));
        thisObject = NULL; /* FIXME use sv_this */
        sourceURL = JSStringCreateWithUTF8CString(SvPVutf8_nolen(sv_src));


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


SV*
CheckScriptSyntax (JSContext ctx, SV *sv_script, SV *sv_src, int line)
    PREINIT:
        JSStringRef script;
        JSStringRef sourceURL;
        JSValueRef exception;
        bool value;

    CODE:
        script = JSStringCreateWithUTF8CString(SvPVutf8_nolen(sv_script));
        sourceURL = JSStringCreateWithUTF8CString(SvPVutf8_nolen(sv_src));

        exception = NULL;
        value = JSCheckScriptSyntax(ctx, script, sourceURL, line, &exception);
        JSStringRelease(script);
        JSStringRelease(sourceURL);

        /* FIXME raise an exception */
        RETVAL = value ? &PL_sv_yes : &PL_sv_no;

    OUTPUT:
        RETVAL


void
DESTROY (JSGlobalContext self)
    CODE:
        JSGlobalContextRelease(self);
