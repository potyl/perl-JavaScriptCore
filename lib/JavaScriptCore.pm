package JavaScriptCore;

=head1 NAME

JavaScriptCore - WebKit's JavaScript engine

=head1 SYNOPSIS

	use JavaScriptCore;

=head1 DESCRIPTION

This module provides the Perl bindings for WebKit's JavaScript engine.

=cut

use warnings;
use strict;

our $VERSION = '0.01';

# XS stuff
use base 'DynaLoader';
__PACKAGE__->bootstrap($VERSION);


1;

=head1 BUGS

For any kind of help or support simply send a mail to the gtk-perl mailing
list (gtk-perl-list@gnome.org).

=head1 AUTHORS

Emmanuel Rodriguez E<lt>potyl@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Emmanuel Rodriguez.

This library is free software; you can redistribute it and/or modify
it under the same terms of:

=over 4

=item the GNU Lesser General Public License, version 2.1; or

=item the Artistic License, version 2.0.

=back

This module is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

You should have received a copy of the GNU Library General Public
License along with this module; if not, see L<http://www.gnu.org/licenses/>.

For the terms of The Artistic License, see L<perlartistic>.

=cut
