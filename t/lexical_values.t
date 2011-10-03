use Test::More tests => 7;
use lexicals;
use PadWalker;
use strict;
use warnings;

my $outside = "tscha";

use Data::Dumper;

sub example {
    my $self = shift;
    my $is = 'xxx';
    is $is , 'xxx', 'simple lexical scalar value';
    # lexicals() has to be calld from within a first-level sub-routine
    my $lex_lex = lexicals;
    is $lex_lex->{'is'}, $is, 'inside lexicals() single dereferenced scalar value';
    is $lex_lex->{'outside'}, undef, 'outside lexicals() single dereferenced scalar value';
    example_pad($is);
}

sub example_pad {
    my $is = shift;

    # one subroutine before lecixals -> one level less
    my $pad_lex = PadWalker::peek_my(0);
    #print "padwalker is is ${$pad_lex->{'$is'}}\n"; 
    is ${$pad_lex->{'$is'}}, $is, 'inside padwalker() double dereferenced scalar value';
    is ${$pad_lex->{'$outside'}}, $outside, 'padwalker() double dereferenced scalar value';
    #print "padwalker is is $pad_lex->{'$is'}\n"; 
    is $pad_lex->{'$is'}, \$is, 'inside padwalker() single dereferenced scalar ref';
    is $pad_lex->{'$outside'}, \$outside, 'padwalker() single dereferenced scalar ref';
    #print Dumper $pad_lex;
}

bless({})->example();
