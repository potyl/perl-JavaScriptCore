#include "jsc-perl.h"


MODULE = JavaScriptCore::JSGlobalContext  PACKAGE = JavaScriptCore::JSGlobalContext  PREFIX = JSGlobalContext


JSGlobalContext JSGlobalContextCreate(SV *class)
    C_ARGS: /* FIXME need a JSClassRef */ NULL

