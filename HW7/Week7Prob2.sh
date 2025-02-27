#!/bin/sh
#SBATCH -A class-ecoevo283
#SBATCH --job-name=Week7Prob2    # Job name 
#SBATCH --cpus-per-task 64
#SBATCH --mem-per-cpu=3G
#SBATCH --error=Week7Prob2.%A_%a.err
#SBATCH --output=Week7Prob2.%A_%a.out

module load subread/2.0.3

gtf="/pub/nujagar/work_EE283/Week_2/DNAseq/Ref/dm6.gtf"
dir="pub/nujagar/work_EE283/Week_7/Prob2"
# the gtf should match the genome you aligned to
# coordinates and chromosome names

# the program expects a space delimited set of files...
myfile=`cat ${dir}/shortRNAseq.names.txt | tr "\n" " "`
featureCounts -p -T 8 -t exon -g gene_id -Q 30 -F GTF -a $gtf -o ${dir}/fly_counts.txt $myfile
