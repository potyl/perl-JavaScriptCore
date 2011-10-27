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
EvaluateScript (JSContext ctx, SV *sv_script, SV *sv_this = NULL, SV *sv_source = NULL, int line = 0);
    PREINIT:
        JSStringRef script;
        JSObjectRef thisObject;
        JSStringRef source;
        JSValueRef exception;

        JSValueRef value;
        JSPValue *p_value;

    CODE:
        script = sv_script == NULL ? NULL : JSStringCreateWithUTF8CString(SvPVutf8_nolen(sv_script));
        source = sv_source == NULL ? NULL : JSStringCreateWithUTF8CString(SvPVutf8_nolen(sv_source));
        thisObject = NULL; /* FIXME use sv_this */

        exception = NULL;
        value = JSEvaluateScript(ctx, script, thisObject, source, line, &exception);
        if (script != NULL) JSStringRelease(script);
        if (source != NULL) JSStringRelease(source);


        if (exception != NULL) jsc_perl_throw_exception(ctx, exception);

        p_value = malloc(sizeof(JSPValue));
        p_value->ctx = ctx;
        JSGlobalContextRetain((JSGlobalContextRef) p_value->ctx);
        p_value->val = value;

        RETVAL = p_value;

    OUTPUT:
        RETVAL


SV*
CheckScriptSyntax (JSContext ctx, SV *sv_script, SV *sv_source = NULL, int line = 0)
    PREINIT:
        JSStringRef script;
        JSStringRef source;
        JSValueRef exception;
        bool value;

    CODE:
        script = sv_script == NULL ? NULL : JSStringCreateWithUTF8CString(SvPVutf8_nolen(sv_script));
        source = sv_source == NULL ? NULL : JSStringCreateWithUTF8CString(SvPVutf8_nolen(sv_source));

        exception = NULL;
        value = JSCheckScriptSyntax(ctx, script, source, line, &exception);
        if (script != NULL) JSStringRelease(script);
        if (source != NULL) JSStringRelease(source);

        /* FIXME raise an exception */
        RETVAL = value ? &PL_sv_yes : &PL_sv_no;

    OUTPUT:
        RETVAL


void
DESTROY (JSGlobalContext self)
    CODE:
        JSGlobalContextRelease(self);
