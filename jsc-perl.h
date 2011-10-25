#ifndef _JSC_PERL_H_
#define _JSC_PERL_H_

#include <gperl.h>

#include <JavaScriptCore/JavaScript.h>

#define JSGlobalContext JSGlobalContextRef
#define JSContextGroup  JSContextGroupRef
#define JSContext       JSContextRef
#define JSValue         JSValueRef

#include "jsc-autogen.h"

typedef struct _JSPValue {
    JSContext ctx;
    JSValue   val;
} JSPValue;


const char* jsc_perl_get_type (JSContextRef ctx, JSValueRef value);
char* jsc_perl_js_str_to_str (JSStringRef js_str);
char* jsc_perl_js_value_to_json (JSContextRef ctx, JSValueRef value);
SV* jsc_perl_js_value_to_sv (JSContextRef ctx, JSValueRef value);


#endif /* _JSC_PERL_H_ */
