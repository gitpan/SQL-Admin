
package SQL::Admin::Utils;
use base qw( Exporter );

use strict;
use warnings;

our $VERSION = v0.5.0;

######################################################################

use List::Util;

######################################################################

our @EXPORT_OK = (
    qw( refhash refarray ),
    qw( empty ignore not_implemented ),
    qw( token literal aval aexp vlist hvlist),
    qw( type kwset val hoption happend ),

    qw( href ),

    qw( true false alias ),
    qw( expr_stm ),
    qw( expr expr_map expr_list expr_vlist expr_key expr_set expr_type ),

    qw( reflist ),
);

our %EXPORT_TAGS = ( all => \@EXPORT_OK, );

######################################################################
######################################################################
sub refhash ( ;$ ) {                     # ;
    'HASH' eq ref (@_ ? $_[0] : $_);
}


######################################################################
######################################################################
sub refarray ( ;$ ) {                    # ;
    'ARRAY' eq ref (@_ ? $_[0] : $_);
}


######################################################################
######################################################################
sub href ( ;@ ) {                        # ;
    +{@_}
}


######################################################################
######################################################################
sub aexp ( @ ) {                         # ;
    map refarray ($_) ? @$_ : $_, @_
}


######################################################################
######################################################################
sub tree ( @ ) {                         # ;
    +{ $_[0] => [@_[1..$#_]] };
}


######################################################################
######################################################################
sub hmap ( @ ) {                         # ;
    href ($_[0], href (map %$_, grep refhash, @_))
}


######################################################################
######################################################################
sub happend ( @ ) {                      # ;
    my $to = shift;
    hmap %$to, aexp @_;
}


######################################################################
######################################################################
sub hval ( @ ) {                         # ;
    return {} if @_ == 1;
    my $h = { @_ };
    $_ = (values %$_)[0] for grep refhash, values %$h;
    $h
}


######################################################################
######################################################################
sub hmerge   { href (map %$_, grep refhash, @_) }
sub empty {({})}
sub ignore {({})}
sub not_implemented {                    # ;
    +{}
}


######################################################################
######################################################################
sub token ( @ )   { href (@_) }
sub literal ( @ ) { shift }
sub vlist ( @ ) {                        # ;
    [ map values %$_, grep refhash, aexp (@_) ]
}

######################################################################
######################################################################
sub hvlist ( @ ) {                       # ;
    href $_[0], vlist @_;
}

######################################################################
######################################################################
sub alias ( @ ) {                        # ;
    my ($rule, $value) = @_;
    return {} if @_ == 1;

    +{ $rule => (values %$value)[0] };
}


######################################################################
######################################################################
sub expr_type ( @ ) {                    # ;
    my ($type, @params) = @_;
    $type =~ s/^ (?: data_ )? type_ //x;

    expr_set ({ data_type => $type }, aexp reverse @params);
}


######################################################################
######################################################################
sub type ( @ ) {                         # ;
    my ($type, @params) = @_;
    $type =~ s/^ (?: data_ )? type_ //x;

    hmerge ({ data_type => $type }, aexp reverse @params);
}


######################################################################
######################################################################
sub kwset ( @ ) {                        # ;
    shift;
    [ lc join '_', @_ ];
}


######################################################################
######################################################################
sub val ( $ ) {                          # ;
    return undef unless refhash $_[0];
    (values %{ $_[0] })[0];
}

######################################################################
######################################################################
sub hoption ( @ ) {                      # ;
    my ($key, $val) = @_;
    $val = [ $val ] unless refarray $val;

    @$val ? {$key => 1} : {};
}


######################################################################
######################################################################
sub expr ( @ ) {                         # ;
    my $key = shift;
    my $val = List::Util::first { ref } @_;
    $val = pop unless ref $val;

    ($val) = (values %$val)
      if refhash ($val) and 2 > scalar keys %$val;

    +{ $key, $val };
}


######################################################################
######################################################################
sub expr_map ( @ ) {                     # ;
    hmap aexp @_;
}


######################################################################
######################################################################
sub expr_stm ( @ ) {                     # ;
    expr_map @_;
}


######################################################################
######################################################################
sub expr_set ( @ ) {                     # ;
    +{ map %$_, grep refhash, aexp @_ }
}


######################################################################
######################################################################
sub expr_vlist ( @ ) {                   # ;
    +{ $_[0] => vlist @_ };
}


######################################################################
######################################################################
sub expr_list ( @ ) {                    # ;
    +{ shift() => [ grep ref, aexp @_ ] };
}


######################################################################
######################################################################
sub expr_key ( @ ) {                     # ;
    +{ $_[0] => 1 };
}


######################################################################
######################################################################
sub true {
    [ 1 ]
}


######################################################################
######################################################################
sub false {
    [ 0 ]
}


######################################################################
######################################################################
sub reflist ( @ ) {                      # ;
    [ grep ref, @_ ]
}

package SQL::Admin::Utils;

1;

=pod

=head1 NAME

SQL::Admin::Utils

=head1 DESCRIPTION

common utils


