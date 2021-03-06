#ifndef _JSC_PERL_H_
#define _JSC_PERL_H_

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <JavaScriptCore/JavaScript.h>


#define JSGlobalContext JSGlobalContextRef
#define JSContextGroup  JSContextGroupRef
#define JSContext       JSContextRef
#define JSValue         JSValueRef
#define JSObject        JSObjectRef


typedef struct _JSPValue {
    JSContext ctx;
    JSValue   val;
} JSPValue;

typedef struct _JSPObject {
    JSContext ctx;
    JSObject  obj;
} JSPObject;

#define jsc_perl_sv_is_ref(sv)    (jsc_perl_sv_is_defined(sv) && SvROK(sv))
#define jsc_sv_to_js(TYPE, VAR)   (jsc_perl_sv_is_ref(VAR) ? INT2PTR(TYPE, SvIV(SvRV(VAR))) : NULL)
#define JSC_PERL_CALL_BOOT(name)  jsc_perl_call_xs(aTHX_ name, cv, mark)


const char* jsc_perl_get_type (JSContextRef ctx, JSValueRef value);
char* jsc_perl_js_str_to_str (JSStringRef js_str);
char* jsc_perl_js_value_to_json (JSContextRef ctx, JSValueRef value);
SV* jsc_perl_js_value_to_sv (JSContextRef ctx, JSValueRef value);
bool jsc_perl_sv_is_defined (SV *sv);
void jsc_perl_call_xs (pTHX_ XSPROTO(subaddr), CV *cv, SV **mark);
void jsc_perl_throw_exception (JSContext ctx, JSValueRef exception);


#endif /* _JSC_PERL_H_ */
