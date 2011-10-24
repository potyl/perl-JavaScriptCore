#include <JavaScriptCore/JavaScript.h>
#include <stdio.h>


int main (int argc, char **argv) {

    JSGlobalContextRef ctx;
    JSStringRef script;
    bool isOk;
    JSValueRef result;
    char *js;

    if (argc <= 1) {
        printf("Usage: JavaScript\n");
        return 0;
    }
    js = argv[1];

    ctx = JSGlobalContextCreate(NULL);

    printf("Checking: %s\n", js);
    script = JSStringCreateWithUTF8CString(js);
    isOk = JSCheckScriptSyntax(ctx, script, NULL, 1, NULL);
    printf("is ok? %s\n", isOk ? "TRUE" : "FALSE");

    result = JSEvaluateScript(ctx, script, NULL, NULL, 1, NULL);
    JSStringRelease(script);

    printf("Value %.2f\n", JSValueToNumber(ctx, result, NULL));

    JSGarbageCollect(ctx);
    JSGlobalContextRelease(ctx);

    printf("Ok\n");
    return 0;
}
