#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use Data::Dumper;


BEGIN {
    use_ok('JavaScriptCore');
}


sub main {
    my $ctx = JavaScriptCore::JSContext->Create();
    isa_ok($ctx, 'JavaScriptCore::JSContext');

    test_undefined($ctx);
    test_null($ctx);

    test_boolean($ctx, 1);
    test_boolean($ctx, 0);

    test_number($ctx, 0);
    test_number($ctx, 1.34);
    test_number($ctx, -10.23);

    test_string($ctx, "hello");

    test_json($ctx, '[ "a", 11 ]');
    test_object($ctx);

    $ctx->GarbageCollect();

    return 0;
}


sub test_undefined {
    my ($ctx) = @_;

    my $type = 'undefined';

    my $var = $ctx->MakeUndefined();
    is($var->GetType, $type, "$type type");
    ok($var->IsUndefined, "$type is undefined ?");
    ok(!$var->IsNull, "$type is null?");
    ok(!$var->IsBoolean, "$type is boolean?");
    ok(!$var->IsNumber, "$type is number?");
    ok(!$var->IsString, "$type is string?");
    ok(!$var->IsObject, "$type is object?");
}


sub test_null {
    my ($ctx) = @_;

    my $type = 'null';

    my $var = $ctx->MakeNull();
    is($var->GetType, $type, "$type type");
    ok(!$var->IsUndefined, "$type is undefined ?");
    ok($var->IsNull, "$type is null?");
    ok(!$var->IsBoolean, "$type is boolean?");
    ok(!$var->IsNumber, "$type is number?");
    ok(!$var->IsString, "$type is string?");
    ok(!$var->IsObject, "$type is object?");
}


sub test_boolean {
    my ($ctx, $value) = @_;

    my $type = 'boolean';

    my $var = $ctx->MakeBoolean($value);
    is($var->GetType, $type, "$type type");
    ok(!$var->IsUndefined, "$type is undefined ?");
    ok(!$var->IsNull, "$type is null?");
    ok($var->IsBoolean, "$type is boolean?");
    ok(!$var->IsNumber, "$type is number?");
    ok(!$var->IsString, "$type is string?");
    ok(!$var->IsObject, "$type is object?");
}


sub test_number {
    my ($ctx, $value) = @_;

    my $type = 'number';

    my $var = $ctx->MakeNumber($value);
    is($var->GetType, $type, "$type type");
    ok(!$var->IsUndefined, "$type is undefined ?");
    ok(!$var->IsNull, "$type is null?");
    ok(!$var->IsBoolean, "$type is boolean?");
    ok($var->IsNumber, "$type is number?");
    ok(!$var->IsString, "$type is string?");
    ok(!$var->IsObject, "$type is object?");
}


sub test_string {
    my ($ctx, $value) = @_;

    my $type = 'string';

    my $var = $ctx->MakeString($value);
    is($var->GetType, $type, "$type type");
    ok(!$var->IsUndefined, "$type is undefined ?");
    ok(!$var->IsNull, "$type is null?");
    ok(!$var->IsBoolean, "$type is boolean?");
    ok(!$var->IsNumber, "$type is number?");
    ok($var->IsString, "$type is string?");
    ok(!$var->IsObject, "$type is object?");
}


sub test_json {
    my ($ctx, $value) = @_;

    my $type = 'json';

    my $var = $ctx->MakeFromJSONString($value);
    is($var->GetType, "object", "$type type");
    ok(!$var->IsUndefined, "$type is undefined ?");
    ok(!$var->IsNull, "$type is null?");
    ok(!$var->IsBoolean, "$type is boolean?");
    ok(!$var->IsNumber, "$type is number?");
    ok(!$var->IsString, "$type is string?");
    ok($var->IsObject, "$type is object?");
}


sub test_object {
    my ($ctx) = @_;

    my $type = 'object';
    my $var = $ctx->EvaluateScript("[ 'two', 2 ]", undef, __FILE__, __LINE__);
    is($var->GetType, "object", "$type type");
    ok(!$var->IsUndefined, "$type is undefined ?");
    ok(!$var->IsNull, "$type is null?");
    ok(!$var->IsBoolean, "$type is boolean?");
    ok(!$var->IsNumber, "$type is number?");
    ok(!$var->IsString, "$type is string?");
    ok($var->IsObject, "$type is object?");

    my $obj = $var->ToObject;
    ok($obj->isa('JavaScriptCore::JSObject'), "ToObject returns a JSObject");
    my $prototype = $obj->GetPrototype();
    is($prototype->GetType, 'object', "Prototype is an object");
    is_deeply($prototype->ToPerl, {}, "Prototype as perl value");
}

exit main() unless caller;
