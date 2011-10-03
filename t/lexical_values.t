use Test::More tests => 4;
use lexicals;
use PadWalker;
use strict;
use warnings;

sub example {
    my $self = shift;
    my $is = 'xxx';
    is $is , 'xxx', 'simple lexical scalar value';
    # lexicals() has to be calld from within a first-level sub-routine
    my $lex_lex = lexicals;
    is $lex_lex->{'is'}, $is, 'lexicals() single dereferenced scalar value';
    example_pad($is);
}

sub example_pad {
    my $is = shift;

    # one subroutine before lecixals -> one level less
    my $pad_lex = PadWalker::peek_my(0);
    #print "padwalker is is ${$pad_lex->{'$is'}}\n"; 
    is ${$pad_lex->{'$is'}}, $is, 'padwalker() double dereferenced scalar value';
    #print "padwalker is is $pad_lex->{'$is'}\n"; 
    is $pad_lex->{'$is'}, \$is, 'padwalker() single dereferenced scalar ref';
}

bless({})->example();
