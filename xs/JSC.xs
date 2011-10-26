#include "jsc-perl.h"

#define GPERL_CALL_BOOT JSC_PERL_CALL_BOOT

EXTERN_C XS(boot_JavaScriptCore__JSContextGroup);
EXTERN_C XS(boot_JavaScriptCore__JSContext);
EXTERN_C XS(boot_JavaScriptCore__JSValue);

MODULE = JavaScriptCore  PACKAGE = JavaScriptCore  PREFIX = jsc_


BOOT:
#include "boot.xsh"

