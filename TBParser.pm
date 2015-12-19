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

package TBParser;
use Moose;

use strict;
use warnings;

use TBUtils 'debugWarn';

has dictRef => ( is => 'rw' );

sub parseLine
{
    my $self = shift;
    my $line = shift;
    my $lineNum = shift;

    debugWarn( "Parsing the line: $lineNum. \"" . TBUtils::trim( $line ) . "\"\n" );

    for my $word ( split( /\s+/, $line ) )
    {
        if ( not exists( $self->dictRef->{ $word } ) )
        {
            $self->dictRef->{ $word } = 1;
        }
        else
        {
            $self->dictRef->{ $word }++;
        }
        debugWarn( "--- DBG: \"$word\" processed.\n" );
    }
}

1;
