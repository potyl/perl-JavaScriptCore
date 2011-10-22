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

#endif /* _JSC_PERL_H_ */
