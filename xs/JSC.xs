#include "jsc-perl.h"

/* HACK: boot.xsh includes lines that look like:

    GPERL_CALL_BOOT (boot_JavaScriptCore__JSContext);
    GPERL_CALL_BOOT (boot_JavaScriptCore__JSContextGroup);
    GPERL_CALL_BOOT (boot_JavaScriptCore__JSValue);

   We use a macro to transform:
    GPERL_CALL_BOOT (boot_JavaScriptCore__JSContext);

   Into:
     EXTERN_C XS (boo_JavaScriptCore__JSContext);

 */
#define GPERL_CALL_BOOT(boot) EXTERN_C XS(boot)
#include "boot.xsh"
#undef GPERL_CALL_BOOT

/* HACK: we not tell GPERL_CALL_BOOT to generate:
     JSC_PERL_CALL_BOOT (boo_JavaScriptCore__JSContext);
 */
#define GPERL_CALL_BOOT JSC_PERL_CALL_BOOT


MODULE = JavaScriptCore  PACKAGE = JavaScriptCore  PREFIX = jsc_


BOOT:
#include "boot.xsh"

