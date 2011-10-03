use Test::More tests => 4;
use lexicals;
use PadWalker;
use strict;
use warnings;

sub example {
    my $self = shift;
    my $is = 'xxx';
    is $is , 'xxx', 'simple lexical scalar value';
    example_pad($is);
    example_lex($is);
}

sub example_pad {
    my $is = shift;

    my $pad_lex = PadWalker::peek_my(0);
    #print "padwalker is is ${$pad_lex->{'$is'}}\n"; 
    is ${$pad_lex->{'$is'}}, $is, 'padwalker() scalar value';
    #print "padwalker is is $pad_lex->{'$is'}\n"; 
    is $pad_lex->{'$is'}, \$is, 'padwalker() scalar ref';
}

sub example_lex {
    my $is = shift;

    my $lex_lex = lexicals;
    #print "lexical is is $lex_lex->{'is'}\n"; 
    is $lex_lex->{'is'}, $is, 'lexicals() single dereferenced scalar value';
}

bless({})->example();
