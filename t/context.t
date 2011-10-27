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

    my $value = $ctx->EvaluateScript("2 + 4", undef, __FILE__, __LINE__);
    is($value->GetType, 'number', "EvaluateScript returned a number");
    ok($value->IsNumber, "EvaluateScript return value");

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
