#!/usr/bin/perl
    use strict;
    use warnings;
my $input=$ARGV[0];#"AeAeg_Aag2_Cas9_repA.fastqUnmapped.out.mate1"
my $inpath=$ARGV[1];
my @name=split(/\./,$input);
open IN, "$inpath/blastresults/$input.blastn" or die;
my %hs;
my $c;
foreach(<IN>){
  chomp;
    my @a= split("\t",$_);
    #if (/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/){}
#0:readsname;1accession;2E;3start;4end;5qu_len;6ma_start;7map_end;8iden;9coverage;10kidom;11species;12commname;13blatnam
if ($a[10] =~ /Viruses/){$hs{"$a[0]"}=$a[11];}
};
close IN;
open IN2,"$inpath/starresults/$input" or die;
open OUT,">$inpath/blastresults/$name[0]".".virus.fasta" or die;
while (<IN2>) {
	chomp;
	if (/>(.*)/) {
    my @a= split(" ",$1);
		$c="$a[0]";
		}
		else {
      if (exists $hs{$c} ){print OUT ">$c\-$hs{$c}\n$_\n";undef $c;}
		};
			};
close IN2;
