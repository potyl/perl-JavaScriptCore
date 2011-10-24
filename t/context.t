#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use Data::Dumper;


BEGIN {
    use_ok('JavaScriptCore');
}


sub main {
    my $context = JavaScriptCore::JSContext->Create();
    isa_ok($context, 'JavaScriptCore::JSContext');

    $context->GarbageCollect();

    my $value = $context->EvaluateScript("2 + 4", undef, __FILE__, __LINE__);
    is($value->GetType, 'number', "EvaluateScript returned a number");
    ok($value->IsNumber, "EvaluateScript return value");
    print Dumper($value->CreateJSONString());

    my $syntax_is_ok = $context->CheckScriptSyntax("function a() { return 1 }", __FILE__, __LINE__);
    print Dumper($syntax_is_ok);
    ok($syntax_is_ok, "Syntax is OK");

    return 0;
}


exit main() unless caller;
