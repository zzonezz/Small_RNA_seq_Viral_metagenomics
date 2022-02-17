#!/usr/bin/perl
    use strict;
    use warnings;
    my $folder=$ARGV[0];
    my $sample=$ARGV[1];
open IN,"$folder\/$sample" or die;
open OUT,">$folder\/$sample\_virus_seq.txt";
open OUT2,">$folder\/$sample\_virus_tax.txt";
open OUT3,">$folder\/$sample\_virus_hist.txt";
my %sequence;
my %taxnum;
my $key;my $value;
my %smallplus;
my %bigplus;
my %smallminus;
my %bigminus;
my %allseq; my $max=0;
####
foreach(<IN>){if (/viruses/)
  {chomp;
    my @a= split("\t",$_);
    #if (/(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)\t(.*)/){}
#0:readsname;1accession;2E;3start;4end;5qu_len;6ma_start;7map_end;8iden;9coverage;10kidom;11species;12commname;13blatnam

if (abs($a[4]-$a[3])>18){
    unless (exists $sequence{$a[0]}){
      $sequence{$a[0]}="$a[13]\t$a[1]\_$a[11]\t$a[5]\t$a[6]\t$a[7]"; $taxnum{"$a[1]\_$a[11]"}++;
      my $av=($a[6]+$a[7])/2;
      my $tem=$taxnum{"$a[1]\_$a[11]"};if ($a[6]<$a[7]){ $allseq{"$a[1]\_$a[11]$tem"}=$av;}else{$allseq{"$a[1]\_$a[11]$tem"}=0-$av};

####
      if (17<$a[5]&&$a[5]<24){
        if ($a[7]>$a[6]){$smallplus{"$a[1]\_$a[11]"}++;}
        else{$smallminus{"$a[1]\_$a[11]"}++;}}
      elsif (23<$a[5]&&$a[5]<36){
        if ($a[7]>$a[6]){$bigplus{"$a[1]\_$a[11]"}++;}
        else{$bigminus{"$a[1]\_$a[11]"}++;}}
  }
}}
};
close IN;
#####

#####
print OUT "Accesion\tKindom\tSpecies\tRead_len\tStart\tEnd\n";
while (($key,$value)=each %sequence){
 print OUT "$key\t$value\n";
} ;
close OUT;

print OUT2 "Accesion_Virus\tAll\t18\-23\+\t18\-23\-\t24\-35\+\t24\-35\-\tsample\n";
while (($key,$value)=each %taxnum){
unless($smallplus{$key}){$smallplus{$key}=0};
unless($smallminus{$key}){$smallminus{$key}=0};
unless($bigplus{$key}){$bigplus{$key}=0};
unless($bigminus{$key}){$bigminus{$key}=0};
 print OUT2 "$key\t$value\t$smallplus{$key}\t$smallminus{$key}\t$bigplus{$key}\t$bigminus{$key}\t$sample\n";
} ;
close OUT2;

while (($key,$value)=each %taxnum){
  if ($value>$max){$max=$value}
};
foreach my $keys(sort{$taxnum{$a}cmp$taxnum{$b}}keys %taxnum){ print OUT3 "$keys\t"};
print OUT3 "sample\n";
my @max=(1..$max);

foreach my $val (@max){
  foreach my $keys(sort{$taxnum{$a}cmp$taxnum{$b}}keys %taxnum){my $keysval="$keys$val";
  if(exists($allseq{$keysval})){  print OUT3 "$allseq{$keysval}\t"} else{print OUT3 "0\t"}
  };
  print OUT3 "$sample\n";
}

