#include "jsc-perl.h"


MODULE = JavaScriptCore::JSContextGroup  PACKAGE = JavaScriptCore::JSContextGroup  PREFIX = JSContextGroup


JSContextGroup JSContextGroupCreate(SV *class)
    C_ARGS: /* empty */
