# $Id: LibXSLT.pm,v 1.2 2001/12/19 13:59:13 matt Exp $

package XML::Filter::XSLT::LibXSLT;
use strict;

use XML::LibXSLT;
use XML::LibXML::SAX::Builder;
use XML::LibXML::SAX::Parser;

use vars qw(@ISA);
@ISA = qw(XML::LibXML::SAX::Builder);

sub new {
    my $class = shift;
    my %params = @_;
    my $self = bless \%params, $class;
    # copy logic from XML::SAX::Base for getting "something" out of Source key.
    # parse stylesheet
    # store
    # return
    my $parser = XML::LibXML->new;
    my $styledoc;
    if (defined $self->{Source}{CharacterStream}) {
        die "CharacterStream is not supported";
    }
    elsif (defined $self->{Source}{ByteStream}) {
        $styledoc = $parser->parse_fh($self->{Source}{ByteStream}, $self->{Source}{SystemId} || '');
    }
    elsif (defined $self->{Source}{String}) {
        $styledoc = $parser->parse_string($self->{Source}{String}, $self->{Source}{SystemId} || '');
    }
    elsif (defined $self->{Source}{SystemId}) {
        $styledoc = $parser->parse_file($self->{Source}{SystemId});
    }
    
    if (!$styledoc) {
        die "Could not create stylesheet DOM";
    }

    $self->{StylesheetDOM} = $styledoc;

    return $self;
}

sub end_document {
    my $self = shift;
    my $dom = $self->SUPER::end_document(@_);
    # parse stylesheet 
    my $xslt = XML::LibXSLT->new;
    my $stylesheet = $xslt->parse_stylesheet($self->{StylesheetDOM});
    # transform
    my $results = $stylesheet->transform($dom);
    # serialize to Handler and co.
    my $parser = XML::LibXML::SAX::Parser->new(%$self);
    $parser->generate($results);
}

1;
__END__

=head1 NAME

XML::Filter::XSLT::LibXSLT - LibXSLT SAX Filter

=head1 SYNOPSIS

None - use via XML::Filter::XSLT please.

=head1 DESCRIPTION

See above. This is a black box!

=cut
