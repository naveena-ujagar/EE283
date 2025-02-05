#!/bin/bash
#SBATCH --job-name=Week4Prob1    ## Name of the job.
#SBATCH -A class-ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=1  ## number of cores the job needs
#SBATCH --error=Week4Prob1.%A_%a.err
#SBATCH --output=Week4Prob1.%A_%a.out
#SBATCH --mem-per-cpu=3G    ## can go from 3-6GB/core std queue
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue



module load samtools/1.15.1
module load bedtools2/2.30.0

#Directory for bam files
A4="/dfs6/pub/nujagar/work_EE283/Week_2/DNAseq/Aligned/ADL06_1.sort.bam"
A5="/dfs6/pub/nujagar/work_EE283/Week_2/DNAseq/Aligned/ADL09_1.sort.bam"
dir="/dfs6/pub/nujagar/work_EE283/Week_4/Prob1"

# *** Prob 1: extract all reads from an interval in a genome from A4 and A5 Bam files ****

# samtools idxstats [bamfile] to determine chromosome formatting 
interval="X:1880000-2000000"

# extract the read IDs that we will search for

samtools view $A4 $interval | cut -f1 > ${dir}/A4.IDs.txt
samtools view $A5 $interval | cut -f1 > ${dir}/A5.IDs.txt


# All reads that map to chromosome X
samtools view $A4 | grep -f ${dir}/A4.IDs.txt |\
    awk '{if($3 == "X"){printf(">%s\n%s\n",$1,$10)}}' >${dir}/A4_X.fa

samtools view $A5 | grep -f ${dir}/A5.IDs.txt |\
    awk '{if($3 == "X"){printf(">%s\n%s\n",$1,$10)}}' >${dir}/A5_X.fa


##Successful output!
