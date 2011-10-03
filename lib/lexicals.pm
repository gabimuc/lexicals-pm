##
# name:      lexicals
# abstract:  Get a hash of your current 'my' variables
# author:    Ingy döt Net <ingy@ingy.net>
# license:   perl
# copyright: 2011
# see:
# - PadWalker
# - Acme::Locals

use 5.10.1;
use strict;
use warnings;
use PadWalker 1.92;

package lexicals;

our $VERSION = '0.21';

use base 'Exporter';
our @EXPORT = qw(lexicals);

sub lexicals {
    use Carp;
    my $pw_all = PadWalker::peek_my(1);
    my $pw_out = PadWalker::peek_my(2);
    my $local = "0";
    return lex_all($pw_all, $pw_out) unless $local; 
    return lex_local($pw_all, $pw_out) if $local; 
    confess "ERROR: No return value for package lexicals";
}

sub lex_local {
    my ($pw_all, $pw_out) = @_;
    use Data::Dumper;
    #print "PW_OUT:\n";
    print Dumper $pw_out;
    # get rid of the uninteresting rubbish in the hash
    delete $pw_all->{$_} for keys %{$pw_out};
    print "PW_all:\n";
    print Dumper $pw_all;
    my $s = "s";
    return +{
        map {
            my $v = $pw_all->{$_};
            $v = $$v if ( ref($v) eq ref(\$s) || ref($v) eq ref(\\$s) );
            s/^[\$\@\%\*]//;
            ($_, $v);
        } reverse sort keys %$pw_all
    };
}
sub lex_all {
    my ($pw_all, $pw_out) = @_;
    use Data::Dumper;
    #print "PW_OUT:\n";
    print Dumper $pw_out;
    # get rid of the uninteresting rubbish in the hash
    delete $pw_all->{$_} for keys %{$pw_out};
    print "PW_all:\n";
    print Dumper $pw_all;
    my $s = "s";
    my $scal = \$s;
    my $ref  = \\$s;
    return +{
        map {
            my $v = $pw_all->{$_};
            $v = $$v if ( ref($v) eq ref($scal) || ref($v) eq ref($ref) );
            s/^[\$\@\%\*]//;
            ($_, $v);
        } reverse sort keys %$pw_all
    };
}

1;

=head1 SYNOPSIS

    use Template::Toolkit::Simple;
    use lexicals;

    sub mail {
        my $self = shift;
        my $name = 'Mr. ' . $self->get_name;
        my $address = $self->fetch_address($name);
        my $stamp = Postage::Stamp->new(0.44);
        my $envelope = tt->render('envelope', lexicals);
    }

=head1 DESCRIPTION

Python has a builtin function called `locals()` that returns the lexically
scoped variables in a name/value mapping. This is a very useful idiom.
Instead of needing to create a hash like this:

    my $hash = {
        foo => $foo,
        bar => $bar,
    };

Just say:

    my $hash = lexicals;

Assuming you have a $foo and $bar defined, you get the same thing.

The `lexicals` module exports a function called `lexicals`. This function
returns the lexicals as a hash reference (in scalar or list context).

=head1 ARRAYS AND HASHES

The above examples deal with lexical scalars. You can also get back lexical
arrays and hashes. Note: since there is no sigil to tell scalars from arrays
from hashes, you can't get back a scalar and an array or hash of the same
name. In this case, SCALAR beats HASH beats ARRAY. Why? Because I said so!
(Actually I just used the sort order of the sigils).

    sub foo {
        my %h = ( O => 'HAI' );
        my @a = [ qw( foo bar baz ) ];
        my $s = 42;
        my %x = ( O => 'HAI' );
        my @x = [ qw( foo bar baz ) ];
        my $x = 42;
        print Dump lexicals;
    }

would yield:

    ---
    a:
    - foo
    - bar
    - baz
    h:
      O: HAI
    s: 42
    x: 42

=head1 NOTE

The C<lexicals> function only reports the lexical variables variables that
were defined before where it gets called.

=cut

##
# =head1 DEBUGGING TRICK
# 
# This could be a handy idiom for debugging:
# 
#     use XXX;
# 
#     sub foo {
#         ...
#         XXX lexicals;     # See your lexicals in the nude.
#         ...
#     }
