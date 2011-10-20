#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use Data::Dumper;


BEGIN {
    use_ok('JavaScriptCore');
}


sub main {
    my $context = JavaScriptCore::JSGlobalContext->Create();
    isa_ok($context, 'JavaScriptCore::JSGlobalContext');
    return 0;
}


exit main() unless caller;
