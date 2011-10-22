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
    ok($val->IsUndefined, "Is undefined");
    is($val->GetType, "undefined", "Is undefined type");

    $context->GarbageCollect();

    return 0;
}


exit main() unless caller;
