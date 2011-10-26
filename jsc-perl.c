#include <jsc-perl.h>

const char*
jsc_perl_get_type (JSContextRef ctx, JSValueRef value) {

    switch (JSValueGetType(ctx, value)) {
        case kJSTypeUndefined:
            return "undefined";
        case kJSTypeNull:
            return "null";
        case kJSTypeBoolean:
            return "boolean";
        case kJSTypeNumber:
            return "number";
        case kJSTypeString:
            return "string";
        case kJSTypeObject:
            return "object";
        default:
            return "????";
    }
}


char*
jsc_perl_js_str_to_str (JSStringRef js_str) {
    int size;
    char* str;

    if (js_str == NULL) return NULL;

    size = JSStringGetMaximumUTF8CStringSize(js_str);
    str = malloc(size);
    JSStringGetUTF8CString(js_str, str, size);
    return str;
}


char*
jsc_perl_js_value_to_json (JSContextRef ctx, JSValueRef value) {
    JSStringRef js_value;
    char *str;

    js_value = JSValueCreateJSONString(ctx, value, 0, NULL);
    if (js_value == NULL) {
        return NULL;
    }
    str = jsc_perl_js_str_to_str(js_value);

    return str;
}


static bool
jsc_perl_js_value_is_dom (JSContextRef ctx, JSValueRef value) {
    JSStringRef js_constructor;
    JSObjectRef constructor;
    
    js_constructor = JSStringCreateWithUTF8CString("Node");
    constructor = JSValueToObject(ctx, JSObjectGetProperty(ctx, JSContextGetGlobalObject(ctx), js_constructor, NULL), NULL);
    JSStringRelease(js_constructor);
    return constructor != NULL ? JSValueIsInstanceOfConstructor(ctx, value, constructor, NULL) : 0;
}


static SV*
jsc_perl_js_value_to_sv_long (JSContextRef ctx, JSValueRef value, GHashTable *g_hash, bool use_globals, bool has_dom_ancestor) {

    if (value == NULL || JSValueIsUndefined(ctx, value) || JSValueIsNull(ctx, value)) {
        return use_globals ? &PL_sv_undef : newSV(0);
    }

    switch (JSValueGetType(ctx, value)) {
        case kJSTypeUndefined:
        case kJSTypeNull:
            return use_globals ? &PL_sv_undef : newSV(0);

        case kJSTypeBoolean:
        {
            bool val = JSValueToBoolean(ctx, value);
            if (use_globals) {
                return val ? &PL_sv_yes : &PL_sv_no;
            }
            return val ? newSViv(1) : newSV(0);
        }

        case kJSTypeNumber:
            return newSVnv(JSValueToNumber(ctx, value, NULL));

        case kJSTypeString:
        {
            JSStringRef js_value;
            char *str;
            SV *sv;

            js_value = JSValueToStringCopy(ctx, value, NULL);
            if (js_value == NULL) {
                return use_globals ? &PL_sv_undef : newSV(0);
            }

            str = jsc_perl_js_str_to_str(js_value);
            JSStringRelease(js_value);
            sv = newSVpv(str, 0);
            free(str);
            return sv;
        }

        case kJSTypeObject:
        {
            JSPropertyNameArrayRef properties = NULL;
            JSObjectRef object;
            size_t count, i;
            JSValueRef jv_prototype;
            char *prototype;
            bool is_array;
            AV *av;
            HV *hv;
            SV *sv;
            bool is_dom;

            is_dom = jsc_perl_js_value_is_dom(ctx, value);
            if (has_dom_ancestor && is_dom) {
                /* Dumping a real DOM element is problematic because it causes
                   the program to crash if we doit all with recursion. There's
                   some weird stuff in the DOM that should not be serialized
                   back into a SV. What we do instead is to limit the DOM
                   recursion to 1 single node.
                 */
                sv = newSV(0);
                g_hash_table_insert(g_hash, (gpointer) value, (gpointer) sv);
                return sv;
            }


            /* Handle circular references by returning the SV that matches the
               JS object.
             */
            sv = g_hash_table_lookup(g_hash, value);
            if (sv != NULL) {return sv;}

            object = JSValueToObject(ctx, value, NULL);
            properties = JSObjectCopyPropertyNames(ctx, object);

            jv_prototype = JSObjectGetPrototype(ctx, object);
            prototype = jsc_perl_js_value_to_json(ctx, jv_prototype);
            if (strcmp(prototype, "[]") == 0) {
                is_array = TRUE;
                av = newAV();
                sv = newRV_inc((SV *) av);
            }
            else {
                is_array = FALSE;
                hv = newHV();
                sv = newRV_inc((SV *) hv);
            }
            free(prototype);

            /* Remember the reference in case that we will see it once more */
            g_hash_table_insert(g_hash, (gpointer) value, (gpointer) sv);

            count = JSPropertyNameArrayGetCount(properties);
            for (i = 0; i < count; ++i) {
                JSStringRef js_name;
                JSValueRef jv_value;
                SV *sv;

                js_name = JSPropertyNameArrayGetNameAtIndex(properties, i);
                jv_value = JSObjectGetProperty(ctx, object, js_name, NULL);

                if (JSValueIsObject(ctx, jv_value)) {
                    JSObjectRef jo_object = JSValueToObject(ctx, jv_value, NULL);
                     if (JSObjectIsFunction(ctx, jo_object) || JSObjectIsConstructor(ctx, jo_object)) {
                        continue;
                    }
                }

                sv = jsc_perl_js_value_to_sv_long(ctx, jv_value, g_hash, FALSE, has_dom_ancestor || is_dom);
                if (is_array) {
                    av_push(av, sv);
                }
                else {
                    char *key;
                    U32 klen;

                    key = jsc_perl_js_str_to_str(js_name);
                    klen = strlen(key);
                    hv_store(hv, key, klen, sv, 0);
                    free(key);
                }
            }
            JSPropertyNameArrayRelease(properties);

            return sv;
        }

        default:
            return use_globals ? &PL_sv_undef : newSV(0);
    }
}


SV*
jsc_perl_js_value_to_sv (JSContextRef ctx, JSValueRef value) {
    GHashTable *g_hash;
    SV *sv;

    g_hash = g_hash_table_new(g_direct_hash, g_direct_equal);
    sv = jsc_perl_js_value_to_sv_long(ctx, value, g_hash, TRUE, FALSE);
    g_hash_table_unref(g_hash);

    return sv;
}


bool
jsc_perl_sv_is_defined (SV *sv)
{
	/* This is copied from gperl_sv_is_defined in Glib's Glib.c */

	if (!sv || !SvANY(sv))
		return FALSE;

	switch (SvTYPE(sv)) {
	    case SVt_PVAV:
		if (AvMAX(sv) >= 0 || SvGMAGICAL(sv)
		    || (SvRMAGICAL(sv) && mg_find(sv, PERL_MAGIC_tied)))
			return TRUE;
		break;
	    case SVt_PVHV:
		if (HvARRAY(sv) || SvGMAGICAL(sv)
		    || (SvRMAGICAL(sv) && mg_find(sv, PERL_MAGIC_tied)))
			return TRUE;
		break;
	    case SVt_PVCV:
		if (CvROOT(sv) || CvXSUB(sv))
			return TRUE;
		break;
	    default:
		if (SvGMAGICAL(sv))
			mg_get(sv);
		if (SvOK(sv))
			return TRUE;
	}

	return FALSE;
}

