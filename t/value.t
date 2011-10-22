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

    my $val = $context->MakeUndefined();
    ok($val->IsUndefined, "undefined is undefined ?");
    is($val->GetType, "undefined", "undefine type");
    ok(!$val->IsNull, "undefined is null?");
    ok(!$val->IsBoolean, "undefined is boolean?");
    ok(!$val->IsNumber, "undefined is number?");
    ok(!$val->IsString, "undefined is string?");
    ok(!$val->IsObject, "undefined is object?");

    $context->GarbageCollect();

    return 0;
}


exit main() unless caller;
