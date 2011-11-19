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

    test_check_script($ctx);
    test_evaluate($ctx);

    $ctx->GarbageCollect();

    return 0;
}


sub test_check_script {
    my ($ctx) = @_;

    my $syntax_check = $ctx->CheckScriptSyntax("x = 1;", __FILE__, __LINE__);
    ok($syntax_check, "Syntax is OK");

    $syntax_check = $ctx->CheckScriptSyntax("x = ", __FILE__, __LINE__);
    ok(!$syntax_check, "Syntax is NOT OK");
}


sub test_evaluate {
    my ($ctx) = @_;
    my $value;


    # Number (int)
    $value = $ctx->EvaluateScript("2 + 4", undef, __FILE__, __LINE__);
    is($value->GetType, 'number', "EvaluateScript returning a number");
    ok(!$value->IsUndefined, "value is not undefined");
    ok(!$value->IsNull, "value is not null");
    ok(!$value->IsBoolean, "value is not boolean");
    ok($value->IsNumber, "value is number");
    ok(!$value->IsString, "value is not string");
    ok(!$value->IsObject, "value is not object");
    is($value->ToNumber, 6, "EvaluateScript number value");
    is($value->ToPerl, 6, "EvaluateScript to perl");


    # Number (float)
    $value = $ctx->EvaluateScript("1/3", undef, __FILE__, __LINE__);
    is($value->GetType, 'number', "EvaluateScript returning a number");
    ok(!$value->IsUndefined, "value is not undefined");
    ok(!$value->IsNull, "value is not null");
    ok(!$value->IsBoolean, "value is not boolean");
    ok($value->IsNumber, "value is number");
    ok(!$value->IsString, "value is not string");
    ok(!$value->IsObject, "value is not object");
    is(sprintf("%.4f", $value->ToNumber), '0.3333', "EvaluateScript number value");
    is(sprintf("%.4f", $value->ToPerl), '0.3333', "EvaluateScript to perl");


    # Boolean (False)
    $value = $ctx->EvaluateScript("2 > 4", undef, __FILE__, __LINE__);
    is($value->GetType, 'boolean', "EvaluateScript returning a boolean");
    ok(!$value->IsUndefined, "value is not undefined");
    ok(!$value->IsNull, "value is not null");
    ok($value->IsBoolean, "value is boolean");
    ok(!$value->IsNumber, "value is not number");
    ok(!$value->IsString, "value is not string");
    ok(!$value->IsObject, "value is not object");
    ok(!$value->ToBoolean, "EvaluateScript boolean value");
    ok(!$value->ToPerl, "EvaluateScript to perl");


    # Boolean (True)
    $value = $ctx->EvaluateScript("2 < 4", undef, __FILE__, __LINE__);
    is($value->GetType, 'boolean', "EvaluateScript returning a boolean");
    ok(!$value->IsUndefined, "value is not undefined");
    ok(!$value->IsNull, "value is not null");
    ok($value->IsBoolean, "value is boolean");
    ok(!$value->IsNumber, "value is not number");
    ok(!$value->IsString, "value is not string");
    ok(!$value->IsObject, "value is not object");
    ok($value->ToBoolean, "EvaluateScript boolean value");
    ok($value->ToPerl, "EvaluateScript to perl");


    # String
    $value = $ctx->EvaluateScript("'100'", undef, __FILE__, __LINE__);
    is($value->GetType, 'string', "EvaluateScript returning a string");
    ok(!$value->IsUndefined, "value is not undefined");
    ok(!$value->IsNull, "value is not null");
    ok(!$value->IsBoolean, "value is not boolean");
    ok(!$value->IsNumber, "value is not number");
    ok($value->IsString, "value is string");
    ok(!$value->IsObject, "value is not object");
    is($value->ToString, '100', "EvaluateScript string value");
    is($value->ToPerl, '100', "EvaluateScript to perl");


    # Object
    $value = $ctx->EvaluateScript("[ 100 ]", undef, __FILE__, __LINE__);
    is($value->GetType, 'object', "EvaluateScript returning an object");
    ok(!$value->IsUndefined, "value is not undefined");
    ok(!$value->IsNull, "value is not null");
    ok(!$value->IsBoolean, "value is not boolean");
    ok(!$value->IsNumber, "value is not number");
    ok(!$value->IsString, "value is not string");
    ok($value->IsObject, "value is object");
    my $js_obj = $value->ToObject;
    is($value->ToObject, '100', "EvaluateScript string value");
    is_deeply($value->ToPerl, [ 100 ], "EvaluateScript to perl");


    # JS compilation error
    my $passed = 0;
    my $line;
    eval {
        $line = __LINE__ + 1;
        $ctx->EvaluateScript("+ 2 + ;", undef, __FILE__, $line);
        1;
    } or do {
        my $error = $@ || {};
        delete $error->{sourceId}; # Random stuff that we can't check
        my $expected = {
            line      => $line,
            sourceURL => __FILE__,
        };
        $passed = is_deeply($error, $expected, "Exception matches");
    };

    fail("EvaluateScript throws error") unless $passed;
}

exit main() unless caller;
