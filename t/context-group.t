#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use Data::Dumper;


BEGIN {
    use_ok('JavaScriptCore');
}


sub main {
    my $context = JavaScriptCore::JSContextGroup->Create();
    isa_ok($context, 'JavaScriptCore::JSContextGroup');
    return 0;
}


exit main() unless caller;
