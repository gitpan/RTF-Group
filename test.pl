
require 5.6.0;

use Test;

BEGIN { plan tests => 11, todo => [ ] }

use strict;
use Carp;

use RTF::Group 1.10;
ok(1);

use warnings 'RTF::Group';
ok(1);

my $g1 = new RTF::Group();

ok(!defined($g1->as_string));

foreach (my $i=1; $i<=3; $i++)
  {
    $g1->append($i);
    my $guess = "\{" . join(" ", (1..$i)) . "\}";
    ok($g1->as_string eq $guess);
  }

{
  my @array = qw(1 2 3);
  my $g1 = RTF::Group->new( @array );
  my $g2 = RTF::Group->new( $g1 );
  ok($g2->as_string eq join("", "\{" x 2,join(" ", @array),"\}" x 2));

  my $g3 = RTF::Group->new( @array, { subgroup=>0 } );
  ok(!$g3->subgroup);

  $g2->append( $g3 );

  ok($g2->as_string eq join("", "\{" x 2,join(" ", @array),"\}", join(" ", @array), "\}" ));

}

ok($g1->as_string eq $g1->string);

{
  sub test_generator
  {
    my $arg_ref = shift;
    return 1+$$arg_ref;
  }

  my $x = time();
  my $g2 = RTF::Group->new( \&test_generator, \$x );
  ok($g2->as_string eq ("\{".(1+$x)."\}"));
  
}


__END__

