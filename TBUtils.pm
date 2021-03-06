# The Button of Osorock
#
# Copyright (C) 2015 Stanislav Demyanovich <stan@angrybubo.com>
#
# This software is provided 'as-is', without any express or
# implied warranty. In no event will the authors be held
# liable for any damages arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute
# it freely, subject to the following restrictions:
#
# 1.  The origin of this software must not be misrepresented;
#     you must not claim that you wrote the original software.
#     If you use this software in a product, an acknowledgment
#     in the product documentation would be appreciated but
#     is not required.
#
# 2.  Altered source versions must be plainly marked as such,
#     and must not be misrepresented as being the original software.
#
# 3.  This notice may not be removed or altered from any
#     source distribution.

package TBUtils;

use strict;
use warnings;

use Exporter;
use vars qw( @ISA @EXPORT );

@ISA = qw(Exporter);
@EXPORT = ( "trim", "debugWarn" );



sub trim # trim( $string ) removes whitespace on both ends of $string
{
    my $s = shift;
    $s =~ s/^\s+|\s+$//g;
    return $s;
};

sub getNthChar # getNthChar( $string, $n ) gets $n-th char from $string
{
    my $s = shift;
    my $n = shift;

    my $c = substr( $s, $n, 1 );

    return $c;
}

sub debugWarn
{
    my $str = shift;

    if ( $main::debugOption and $main::debugOption > 0 )
    {
        warn( $str );
    }
}


1;
