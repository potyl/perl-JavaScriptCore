#include "jsc-perl.h"


MODULE = JavaScriptCore  PACKAGE = JavaScriptCore  PREFIX = jsc_


BOOT:
#include "register.xsh"
#include "boot.xsh"
