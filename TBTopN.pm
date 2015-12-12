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

package TBTopN;

use strict;
use warnings;

use TBUtils;

sub generateReport
{
    my $N = shift;
    my $dictRef = shift;

    my $report = "";
    my %wordsByFreq = ();
    for my $word ( keys( %{ $dictRef } ) )
    {
        my $freq = $dictRef->{ $word };
        if ( not exists( $wordsByFreq{ $freq } ) )
        {
            my @words = ( $word );
            $wordsByFreq{ $freq } = \@words;
        }
        else
        {
            my $arrayRef = $wordsByFreq{ $freq };
            push( @$arrayRef, $word );
        }
    }

    my @freqs = sort { $b <=> $a } keys( %wordsByFreq );
    debugWarn( "--- DBG: top$N report: freqs num = " . ( $#freqs + 1 ) . "\n" );
    if ( $N > $#freqs + 1 and $main::strictOption and $main::strictOption > 0 )
    {
        $report = "Мало частот для строгого top:$N";
    }
    else
    {
        $report = "Суть в нескольких словах:";
        for ( my $i = 0; $i <= $#freqs and $i < $N; ++$i )
        {
            my $freq = $freqs[ $i ];
            my $arrayRef = $wordsByFreq{$freq};
            for my $word ( @$arrayRef )
            {
                $report .= " $word";
            }
        }
    }

    return TBUtils::trim( $report ). "\n";
}


1;
