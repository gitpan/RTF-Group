use strict;
use Carp;

use RTF::Group 1.02, ( paragraph => 'par' );
no warnings;

my $count = 1;

$|=0; message("Module loaded");

sub message
  {
    my $name = shift;
    print sprintf('%3d. ', $count++),
      ucfirst($name),
      ( " " x ( 30-length($name) ) ),
      ( ($|)?"failed":"ok" ),
      "\n";

    if ($!) { croak; }
  }

{
  my $g1 = new RTF::Group();

  $| = ($g1->as_string ne '');
  message("empty group is blank");

  unless ($|)
    {
      foreach (my $i=1; (($i<=5) and (!$|)); $i++)
	{
	  $g1->append($i);
	  my $guess = "\{" . join(" ", (1..$i)) . "\}";
	  $| = ($g1->as_string ne $guess);
	  message("group with " . plural($i, "atom"));
	}
    }

{
  my @array = qw(1 2 3);
  my $g1 = RTF::Group->new( @array );
  my $g2 = RTF::Group->new( $g1 );
  $| = ($g2->as_string ne join("", "\{" x 2,join(" ", @array),"\}" x 2));
  message("Subgroup");
}

  unless ($|)
    {
      $| = ($g1->as_string ne $g1->string);
      message("string alias with as_string");
    }

}

unless ($|)
{
  sub test_generator
  {
    my $arg_ref = shift;
    return 1+$$arg_ref;
  }

  my $x = time();
  my $g2 = RTF::Group->new( \&test_generator, \$x );
  $| = ($g2->as_string ne ("\{".(1+$x)."\}"));
  message("subroutine reference");
  
}

unless ($|)
{
  my $g1 = new RTF::Group();
  $g1->paragraph;
  $| = ($g1->as_string ne "\{\\par\}");
  message("RTF control method");
}

sub plural
  {
    my ($num, $word) = @_;
    return join(" ", $num, $word) .
      ( ($num != 1)
	? ( ($word =~ m/s$/i) ? "es" : "s" )
	: ""
      );
  }

exit $|;
