#!/bin/bash
echo -n "please input your main sqeuencing reulst folder:"
read inputpath
echo -n "Please input your destination folder:"
read outputpath
echo -n "please input your genomeDir folder for STAR alignment:"
read genomeDir #/../../GCA_002204515.1
echo -n "please input your sjdbGTFfile folder for STAR alignment:"
read sjdbGTFfile #/../GCF_002204515.2_AaegL5.0_genomic.gtf
mkdir starresults
module load star
    for file in `ls $outputpath`
        do
            if [[ "$file" =~ .fasta$ ]]; then
              STAR --runThreadN 28   --outFileNamePrefix $outputpath/starresults/${file%.*} --outReadsUnmapped Fastx --quantMode GeneCounts --genomeDir $genomeDir --readFilesIn $outputpath/$file --sjdbGTFfile $sjdbGTFfile --outFilterMismatchNoverLmax 0.05 --outFilterMatchNmin 16 --outFilterScoreMinOverLread 0  --outFilterMatchNminOverLread 0 --alignIntronMax 1
            fi
          done
fi
