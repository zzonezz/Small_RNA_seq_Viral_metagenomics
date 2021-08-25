#!/bin/bash
echo -n "please input your main sqeuencing reulst folder:"
read inputpath
echo -n "Please input your destination folder:"
read outputpath

mkdir $outputpath/blastresults
for file in `ls $outputpath/starresults`
do
if [[ "$file" =~ Unmapped.out.mate1$ ]]; then
echo "
#!/bin/bash -l
#$ -N blastn-${file%.Unmapped.out.mate1}
#$ -l h_rt=96:00:00
#$ -m as
#$ -P lau-bumc
#$ -o ${file%.Unmapped.out.mate1}.o.txt
#$ -e ${file%.Unmapped.out.mate1}.e.txt
#$ -l mem_total=252G
#$ -pe omp 28
module load blast+
blastn  -query $outputpath/starresults/$file -out $outputpath/blastresults/${file%.Unmapped.out.mate1}.blastn -db nt -outfmt \"6 qseqid sacc evalue qstart qend qlen sstart send pident qcovs sskingdoms sscinames scomnames sblastnames\"  -max_target_seqs 1 -num_threads 28 -word_size 11
perl /projectnb/lau-bumc/zhengzhu/test/virusreads.pl ${file%.Unmapped.out.mate1} $outputpath
/projectnb/lau-bumc/zhengzhu/ncbi-blast-2.11.0+/bin/./blastn  -query $outputpath/blastresults/${file%%.*}.virus.fasta -out $outputpath/blastresults/${file%%.*}.virus.blastn -db /projectnb/lau-bumc/zhengzhu/BLASTDB/ref_viruses_rep_genomes -outfmt \"6 qseqid sacc evalue qstart qend qlen sstart send pident qcovs sskingdoms sscinames scomnames sblastnames\"  -max_target_seqs 1 -num_threads 28 -word_size 11
perl /projectnb/lau-bumc/zhengzhu/test/virusdistribution3.pl $outputpath/blastresults ${file%.Unmapped.out.mate1}
" > $outputpath/blastresults/$file.sh
qsub $outputpath/blastresults/$file.sh
rm -f $outputpath/blastresults/$file.sh
fi
done
fi
