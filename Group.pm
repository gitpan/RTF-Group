package RTF::Group;

use Carp;

use strict;
use vars qw($VERSION);

$VERSION = '0.1';

sub new
{
    my $this = shift;
    my $class = ref($this) || $this;
    my $self = {};
    bless $self, $class;
    $self->initialize();
    $self->append(@_);
    return $self;
}

sub initialize
{
    my $self = shift;

    $self->{GROUP} = ();
}

sub append
{
    my $self = shift;
    push @{$self->{GROUP}}, @_;
}

sub list
{
    my $self = shift;
    my @list = ();

    foreach my $atom (@{$self->{GROUP}})
    {
        my $ref_atom = ref($atom);

        if ($ref_atom =~ m/RTF::Group/)
        {
            push @list, [ $atom->list ];
        }
        elsif ($ref_atom eq "ARRAY")
        {
            my $subgroup = new RTF::Group(@{$atom});
            push @list, $subgroup->list();
        }
        elsif ($ref_atom eq "SCALAR")
        {
            push @list, ${$atom}, if (length(${$atom}));
        }
        elsif ($ref_atom ne "")
        {
            croak "Cannot handle reference to $ref_atom";
        }
        else
        {
            push @list, $atom, if (length($atom));
        }
    }

    return @list;
}

sub list_as_string
{
    my ($atom, $string);

    unless (@_) {
        return undef;
    }

    $string = "\{";

    foreach $atom (@_)
    {
        my $ref_atom = ref($atom);

        if ($ref_atom eq "ARRAY")
        {
            $string .= list_as_string(@{$atom});
        }
        else
        {
            $atom =~ s/[!\\]?([\{\}])/\\$1/g; # escape unescaped brackets
            if (($atom !~ m/^[\\\;\{\}]/) and ($string !~ m/[\}\{\s]$/))
            {
                $string .= " ";
            }
            $string .= $atom;
        }
    }
    $string .= "\}";
    return $string;
}

sub is_empty
{
    my $self = shift;
    return ($self->list() == 0);
}

sub string
{
    my $self = shift;
    return list_as_string( $self->list() );
}

1;
__END__

=head1 NAME

RTF::Group - Base class for manipulating Rich Text Format (RTF) groups

=head1 DESCRIPTION

This is a base class for manipulating RTF groups.  Groups are stored internally
as lists. Lists may contain (sub)groups or atoms (raw text or control words).

Unlike the behavior of groups in the original RTF::Document module (versions 0.63
and earlier), references to arrays (lists) are I<not> treated as subgroups, but
are dereferenced when expanded (as lists or strings).

This allows more flexibility for changing control codes within a group, without
having to know their exact location, or to use kluges like I<splice> on the
arrays.

=head1 METHODS

=head2 new

    $group = new RTF::Group LIST;

Creates a new group. If LIST is specified, it is appended to the group.

=head2 append

    $group->append LIST;

Appends LIST to the group. LIST may be plain text, controls, other groups, or
references to a SCALAR or another LIST.

=head2 list

    @RTF = $group->list();

Returns the group as a list (array). Subgroups are lists within the list.
This is useful for parsers.

=head2 string

    print $group->string();

Returns the group as a string that would appear in an RTF document.

=head2 is_empty

    if ($group->is_empty) { ... }

Returns true if the group is empty, false if it contains something. Zero-length
strings are considered nothing.

=head1 AUTHOR

Robert Rothenberg <wlkngowl@unix.asb.com>

=head1 LICENSE

Copyright (c) 1999 Robert Rothenberg. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut


