#!/usr/bin/perl -w

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

package main;

use strict;
use warnings;

use File::Basename 'basename';
use Cwd;
use TBUtils 'debugWarn';
use TBParser;
use TBTopN;


our $debugOption = 0; # set this to 1 for enable debug output. 0 by default ( on should use --debug option )
our $strictOption = 0; # set this to 1 strict report generating. 0 otherwise
our $reportTypeOption = "top"; # where is only one type presented for now
our $reportTypeOption_1 = 1; # should i use array for report type params?

sub generateReport
{
    my $dictRef = shift;
    my $report = "";

    if ( $reportTypeOption eq "top" )
    {
        debugWarn( "--- DBG: generating report of type \"top:N\" :: \"$reportTypeOption:$reportTypeOption_1\"\n" );
        $report = TBTopN::generateReport( $reportTypeOption_1, $dictRef );
    }
    else
    {
        debugWarn( "--- ERROR: report type \"$reportTypeOption\" is not implemented. Force using \"top:1\"" );
        $report = TBTopN::generateReport( 1, $dictRef );
    }

    return $report;
}

sub printHelp
{
    print( "Usage:\n" );
    print( "./" . basename( $0 ) . " --help\n" );
    print( "\tPrints current help screen\n" );
    print( "./" . basename( $0 ) . " [--report-type type] [--debug] [--strict]\n" );
    print( "\t--report-type\tdefines the report type\n" );
    print( "\t\tValid types are:\n" );
    print( "\t\t\ttop:<N> (<N> is a number of top positions will be reported)\n" );
    print( "\t\tDefault type is:\ttop:1\n" );
    print( "\t--debug \tturns on debug output\n" );
    print( "\t--strict \tenables strict report generation\n" );
}

#
# main
#
my $numArgs = $#ARGV + 1;
my $baseDir = Cwd::abs_path( "." );

if ( $numArgs >= 1 )
{
    my @extraArgs = ();
    while ( @ARGV )
    {
        my $option = shift( @ARGV );
        if ( $option eq "--help" )
        {
            printHelp();
            exit 0;
        }
        # elsif ( $option eq "--single_option" )
        # {
        # }
        # elsif ( $option eq "--pair_option" )
        # {
        #     my $arg = shift @ARGV || do
        #                             {
        #                                 warn( "--- FATAL: wrong command line args: value should follow --pair_option option\n" );
        #                                 warn( "Please, use --help option for usage." );
        #                                 exit 1;
        #                             };
        #     $oldFile = abs_path( $arg );
        # }
        elsif ( $option eq "--debug" )
        {
            $debugOption = 1;
        }
        elsif ( $option eq "--strict" )
        {
            $strictOption = 1;
        }
        elsif ( $option eq "--report-type" )
        {
            my $arg = shift @ARGV || do
                                    {
                                        warn( "--- FATAL: wrong command line args: report type should follow --report option\n" );
                                        warn( "\tPlease, use --help option for usage.\n" );
                                        exit 1;
                                    };
            if ( $arg =~ m/^(top):(\d+)$/ )
            {
                debugWarn( "--- DBG: report type is 'top:$2'\n" );
                $reportTypeOption = $1;
                $reportTypeOption_1 = $2;
            }
            else
            {
                debugWarn( "--- ERROR: wrong report type \"$arg\"! Using default report type.\n" );
                debugWarn( "\tPlease, use --help option for usage.\n" );
            }
        }
        else
        {
            push( @extraArgs, $option );
        }
    }

    if ( $#extraArgs + 1 > 0 )
    {
        debugWarn( "--- INFO: Ignoring extra args: @extraArgs\n" );
    }
}
else
{
    # We can live without explicit options
    # So do nothing
}

debugWarn( "\n--- INFO: options:\n" );
# debugWarn( "--- INFO:\toption: \"$optionValue\"\n" );
debugWarn( "--- INFO:\tdebug: \"$debugOption\"\n" );
debugWarn( "--- INFO:\tstrict: \"$strictOption\"\n" );
debugWarn( "--- INFO:\treport type: \"$reportTypeOption\"\n" );
debugWarn( "--- INFO:\treport type arg1: \"$reportTypeOption_1\"\n" );

my %dictionary = ();
my $parser = TBParser->new( dictRef => \%dictionary );
while ( <STDIN> )
{
    $parser->parseLine( $_, $. );
}


debugWarn( "--- DBG: Dictionary:\n" );
if ( $debugOption )
{
    for my $word ( keys( %dictionary ) )
    {
        debugWarn( "--- DBG: Word = \"$word\", frequency = " . $dictionary{ $word } . "\n" );
    }
}

my $report = generateReport( \%dictionary );
debugWarn( "---\n" );
print( $report );
