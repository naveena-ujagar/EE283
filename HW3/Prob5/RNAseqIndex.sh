#!/bin/bash
#SBATCH --job-name=RNAseqIndex    ## Name of the job.
#SBATCH -A class-ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=8  ## number of cores the job needs
#SBATCH --error=RNAseqIndex.err
#SBATCH --output=RNAseqIndex.out
#SBATCH --mem-per-cpu=16G    ## can go from 3-6GB/core std queue
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue


module load hisat2/2.2.1
dir="/pub/nujagar/work_EE283/Week_2/DNAseq/Ref"
fa="${dir}/dmel-all-chromosome-r6.13.fasta"
gtf="${dir}/dmel-al-r6.13.gtf"

python hisat2_extract_splice_sites.py $gtf > "/pub/nujagar/work_EE283/Week_2/RNAseq/Index/dm6.ss"
python hisat2_extract_exons.py $gtf > "/pub/nujagar/work_EE283/Week_2/RNAseq/Index/dm6.exon"
hisat2-build -p 8 --exon "/pub/nujagar/work_EE283/Week_2/RNAseq/Index/dm6.exon" --ss "/pub/nujagar/work_EE283/Week_2/RNAseq/Index/dm6.ss" \
 $fa "/pub/nujagar/work_EE283/Week_2/RNAseq/Index/dm6_trans"




