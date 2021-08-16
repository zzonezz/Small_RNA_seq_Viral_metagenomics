#!/bin/bash
echo "This script is to ungzip, move trimed Illumina sequencing data to user's folder"
echo local=`pwd`
echo -n "please input your main sqeuencing reulst folder:"
read inputpath
echo -n "Please input your destination folder:"
read outputpath
module load python3
module load cutadapt
echo -n "Do you need cut adapt "AGATCGGAAGAGCACACGTCT" and remove reads < 16bp(Y/N):"
read cutadapt
if [[ "$cutadapt" =~ Y ]] || [[ "$cutadapt" =~ y ]]; then
adapt="AGATCGGAAGAGCACACGTCT"
m=16
else
  echo -n "Please input adapt sequence:"
  read adapt
  echo -n "Please input minimum reads length:"
  read m
fi
for dir in `ls $inputpath`
do

        for file in `ls $inputpath/$dir`
        do
        if [[ "$file" =~ fastq.gz$ ]]; then
          cutadapt -a $adapt -m $m --max-n 3 --cores=0 --fasta -o $outputpath/${file%.*}.fasta $inputpath/$dir/$file
                echo "cutadapt: $file done"

        fi
        done

done
