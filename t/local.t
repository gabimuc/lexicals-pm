use Test::More tests => 7;
use lexicals;
use Data::Dumper;

my %h_outside = ( a => 1, b => 2);
my @a_outside = ( 'x', 'y', 3);
my $s_outside = 42;
my $r_outside = \$s_outside;
my $r2_outside = \\$_soutside;


sub foo {
    my %h_inside = ( a => 1, b => 2);
    my @a_inside = ( 'x', 'y', 3);
    my $s_inside = 42;
    my $r_inside = \$s;
    my $r2_inside = \\$s;
    my $l_inside = lexicals;
    my $x_inside = 7;
    my @x_inside = (3, 4);
    my %x_inside = (1, 3, 2, 1);

    $l_inside = lexicals;
    is $l_inside->{x_inside}, 7, 'Scalar wins on match';
    is ref($l_inside->{h_inside}), 'HASH', 'lexical hashes are ok';
    is ref($l_inside->{a_inside}), 'ARRAY', 'lexical arrays are ok';
    is ref($l_inside->{r_inside}), 'SCALAR', 'lexical refs are ok';
    is ref($l_inside->{r2_inside}), 'REF', 'lexical refs are ok';
    is ref($l_inside->{s_inside}), '', 'lexical scalars are ok';
    is ${$l_inside->{r2_inside}}, $l_inside->{r_inside}, 'references are correct';
}

foo();
