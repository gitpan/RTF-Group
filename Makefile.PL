require 5.005;

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'      => 'RTF::Group',
    'VERSION_FROM' => 'Group.pm', # finds $VERSION
    'PREREQ_PM'		=> {
       'warnings::register' => 0,
       'Carp'               => 0,
     },
  ($] ge '5.005') ? (
    'AUTHOR'   => 'Robert Rothenberg (rrwo@cpan.org)',
    'ABSTRACT' => 'Manipulate low-level RTF groups',
  ) : (),
);
