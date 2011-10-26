#include "jsc-perl.h"

EXTERN_C XS(boot_JavaScriptCore__JSContextGroup);
EXTERN_C XS(boot_JavaScriptCore__JSContext);
EXTERN_C XS(boot_JavaScriptCore__JSValue);


MODULE = JavaScriptCore  PACKAGE = JavaScriptCore  PREFIX = jsc_


BOOT:
    JSC_PERL_CALL_BOOT (boot_JavaScriptCore__JSContextGroup);
    JSC_PERL_CALL_BOOT (boot_JavaScriptCore__JSContext);
    JSC_PERL_CALL_BOOT (boot_JavaScriptCore__JSValue);

