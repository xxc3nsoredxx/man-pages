#!/usr/bin/perl -w
#
#	BuildLinuxMan.pl	: Build Linux manpages book
#	Deri James		: 15 Dec 2022
#
#	Params:-
#
#               $1 = Directory holding the man pages
#
# (C) Copyright 2022, Deri James
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details
# (http://www.gnu.org/licenses/gpl-2.0.html).
#

use strict;

my $dir=shift || '.';
my @aliases=`egrep -l '^\\.so' $dir/man*/*`;
my %alias;
my %target;
my $inTS=0;
my $inBlock=0;

my %Sections=
(
    "1"	=> "General Commands Manual",
    "2"	=> "System Calls Manual",
    "2type"	=> "System Calls Manual (types)",
    "3"	=> "Library Functions Manual",
    "3const"	=> "Library Functions Manual (constants)",
    "3head"	=> "Library Functions Manual (headers)",
    "3type"	=> "Library Functions Manual (types)",
    "4"	=> "Kernel Interfaces Manual",
    "5"	=> "File Formats Manual",
    "6"	=> "Games Manual",
    "7"	=> "Miscellaneous Information Manual",
    "8"	=> "System Manager's Manual",
    "9"	=> "Kernel Developer's Manual",
);

my $Section='';

LoadAlias();
BuildBook();

my $cmdstring="-Tpdf -k -pet -M. -F. -mandoc -manmark -dpaper=a4 -P-pa4 -rC1 -rCHECKSTYLE=3";

system("groff -Tpdf -ms LMBfront.t -Z > LMBfront.Z");
system("groff -z -dPDF.EXPORT=1 -dLABEL.REFS=1 T $cmdstring 2>&1 | LC_ALL=C grep '^\\. *ds' | groff -Tpdf $cmdstring - T -Z > LinuxManBook.Z");
system("./gropdf -F. LMBfront.Z LinuxManBook.Z > LinuxManBook.pdf");
unlink "LinuxManBook.Z","LMBfront.Z";  # If you want to clean up

# Aliases are the man pages which .so another man page, so build a hash of them so
# that when we are processing referenced man page we can add the target for the
# bookmark.

sub LoadAlias
{
    foreach my $fn (@aliases)
    {
	chomp($fn);
	my (@pth)=split('/',$fn);
	my $nm=pop(@pth);
	my $bkmark="$1_$2" if $nm=~m/(.*)\.(\w+)/;

	if (open(F,"<$fn"))
	{
	    while (<F>)
	    {
		next if m/^\.\\"/;

		if (m/^.so\s+(man\w+\/(.+)\.(.+?))$/)
		{
		    $alias{$bkmark}=["$2_$3",$2,$3];
		    push(@{$target{"$2_$3"}},$bkmark);
		    last;
		}
		else
		{
		    print STDERR "Alias fail: $fn\n";
		}
	    }

	    close(F);
	}
	else
	{
	    print STDERR "Open fail: $fn\n";
	}
    }
}

sub BuildBook
{
    open(BK,">T");

    foreach my $fn (sort sortman glob("$dir/man*/*"))
    {
	my ($nm,$sec,$srt)=GetNmSec($fn);

        my $bkmark="$1_$2" if $nm=~m/(.*)\.(\w+)/;
        my $title= "$1\\($2\\)";

# If this is an alias, just add it to the outline panel.

        if (exists($alias{$bkmark}))
        {
            print BK ".eo\n.device ps:exec [/Dest /$alias{$bkmark}->[0] /Title ($title) /Level 2 /OUT pdfmark\n.ec\n";
	    print BK ".if dPDF.EXPORT .tm .ds pdf:look($bkmark) $alias{$bkmark}->[1]($alias{$bkmark}->[2])\n";
	    next;
	}

	print BK ".\\\" >>>>>> $1($2) <<<<<<\n";

	if (open(F,'<',$fn))
        {
            while (<F>)
            {
                if (m/^\.\\"/)
                {
                    print BK $_;
                    next;
                }

                chomp;

# This code is to determine whether we are within a tbl block and in a text block
# T{ and T}. This is fudge code particularly for the syscalls(7) page.

                $inTS=1 if m/\.TS/;
                $inTS=0,$inBlock=0 if m/\.TE/;

                s/\r$//;    # In case edited under windows i.e. CR/LF
                s/\s+$//;
                next if !$_;
#               s/^\s+//;

                if (m/^\.BR\s+([-\w\\.]+)\s+\((.+?)\)(.*)/)
                {
                    my $bkmark="$1";
                    my $sec=$2;
                    my $after=$3;
                    my $dest=$bkmark;
                    $dest=~s/\\-/-/g;
                    $_=".MR \"$bkmark\" \"$sec\" \"$after\" \"$dest\"";
                }

                s/^\.BI \\fB/.BI /;
		s/^\.BR\s+(\S+)\s*$/.B $1/;
                s/^\.BI\s+(\S+)\s*$/.B $1/;
                s/^\.IR\s+(\S+)\s*$/.I $1/;

# Fiddling for syscalls(7) :-(

                if ($inTS)
                {
                    my @cols=split(/\t/,$_);

                    foreach my $c (@cols)
                    {
                        $inBlock+=()=$c=~m/T\{/g;
                        $inBlock-=()=$c=~m/T\}/g;

                        my $mtch=$c=~s/\s*\\fB([-\w.]+)\\fP\((\w+)\)/\n.MR $1 $2 \\c\n/g;
                        $c="T{\n${c}\nT}" if $mtch and !$inBlock;
                    }

                    $_=join("\t",@cols);
                    s/\n\n/\n/g;
                }

                if (m/^\.TH\s+([-\w\\.]+)\s+(\w+)/)
                {

                    # if new section add top level bookmark

                    if ($sec ne $Section)
                    {
			print BK ".nr PDFOUTLINE.FOLDLEVEL 1\n.fl\n";
			print BK ".pdfbookmark 1 $Sections{$sec}\n";
			print BK ".nr PDFOUTLINE.FOLDLEVEL 2\n";
			$Section=$sec;
                    }

                    print BK "$_\n";

# Add a level two bookmark. We don't set it in the TH macro since the name passed
# may be different from the filename, i.e. file = unimplemented.2, TH = UNIMPLEMENTED 2

                    print BK ".pdfbookmark -T $bkmark 2 $1($2)\n";

# If this page is referenced by an alias plant a destination label for the alias.

                    if (exists($target{$bkmark}))
                    {
                        foreach my $targ (@{$target{$bkmark}})
			{
			    print BK ".pdf*href.set $targ\n";
			}
		    }

		    next;
		}

		print BK "$_\n";

	    }

	    close(F);

	}
    }

    close(BK);
}

sub GetNmSec
{
    my (@pth)=split('/',shift);
    my $nm=pop(@pth);
    my $sec=substr(pop(@pth),3);
    my $srt=$nm;
    $srt=~s/^_+//;
    $srt="$sec/$srt";
    return($nm,$sec,$srt);
}

sub sortman
{
# Sort - ignore case but frig it so that intro is the first entry.

    my (undef,$s1,$c)=GetNmSec($a);
    my (undef,$s2,$d)=GetNmSec($b);

    my $cmp=$s1 cmp $s2;
    return $cmp if $cmp;
    return -1 if ($c=~m/\/intro/ and $d!~m/\/intro/);
    return  1 if ($d=~m/\/intro/ and $c!~m/\/intro/);
    return (lc($c) cmp lc($d));
}
