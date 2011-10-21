#include "jsc-perl.h"


MODULE = JavaScriptCore::JSContext  PACKAGE = JavaScriptCore::JSContext  PREFIX = JSContext



JSValue
JSValueMakeUndefined(JSContext ctx)
    C_ARGS: ctx


JSValue
JSValueMakeNull(JSContext ctx)
    C_ARGS: ctx


JSValue
JSValueMakeBoolean(JSContext ctx, int val)
    C_ARGS: ctx, val


JSValue
JSValueMakeNumber(JSContext ctx, double val)
    C_ARGS: ctx, val



MODULE = JavaScriptCore::JSValue  PACKAGE = JavaScriptCore::JSValue  PREFIX = JSValue


void
DESTROY (JSValue self)
    CODE:
        /* FIXME pass the context JSValueUnprotect(self); */
