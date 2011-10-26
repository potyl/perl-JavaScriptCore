#!/usr/bin/env perl

=head1 NAME

jsc.pl - Embed WebKit's JavaScript engine

=head1 SYNOPSIS

    jsc.pl FILE

Simple usage:

    jsc.pl test.js

=head1 DESCRIPTION

Run JavaScript from Perl.

=cut

use strict;
use warnings;

use JavaScriptCore;
use JSON qw(decode_json);
use Data::Dumper;

sub main {
    my ($file) = @ARGV or die "Usage: $0 FILE\n";
    
    my $context = JavaScriptCore::JSContext->Create();
    
    print "Ok\n";
    return 0;
}


exit main() unless caller;
