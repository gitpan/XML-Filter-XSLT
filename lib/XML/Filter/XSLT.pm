# $Id: XSLT.pm,v 1.1.1.1 2001/12/18 22:12:40 matt Exp $

package XML::Filter::XSLT;
use strict;
use vars qw($VERSION);

$VERSION = 0.01;

sub new {
    my $class = shift;
    # try and load XSLT engines
    eval {
        require XML::Filter::XSLT::LibXSLT;
    };
    if (!$@) {
        return XML::Filter::XSLT::LibXSLT->new(@_);
    }

    die "No XSLT engines available";
}

1;
__END__

=head1 NAME

XML::Filter::XSLT - XSLT as a SAX Filter

=head1 SYNOPSIS

  use XML::SAX::ParserFactory;
  use XML::Filter::XSLT;
  use XML::SAX::Writer;

  my $writer = XML::SAX::Writer->new();
  my $filter = XML::Filter::XSLT->new(Handler => $writer);
  my $parser = XML::SAX::ParserFactory->parser(
                  Handler => $filter);
  $filter->set_stylesheet_uri("foo.xsl");
  $parser->parse_uri("foo.xml");

=head1 DESCRIPTION

=head1 AUTHOR

=head1 LICENSE

=cut
