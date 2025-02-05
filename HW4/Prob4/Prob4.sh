#!/bin/bash
#SBATCH --job-name=Week4Prob4    ## Name of the job.
#SBATCH -A class-ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=1  ## number of cores the job needs
#SBATCH --error=Week4Prob4.%A_%a.err
#SBATCH --output=Week4Prob4.%A_%a.out
#SBATCH --mem-per-cpu=3G    ## can go from 3-6GB/core std queue
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue

# Load miniconda module (adjust path if necessary)
module load miniconda3/24/9.2

# Initialize conda for this shell session
eval "$(conda shell.bash hook)"

# Activate your environment
conda activate deeptools_env

# Directory for bam files
A4="/dfs6/pub/nujagar/work_EE283/Week_2/DNAseq/Aligned/ADL06_1.sort.bam"
A5="/dfs6/pub/nujagar/work_EE283/Week_2/DNAseq/Aligned/ADL09_1.sort.bam"
dir="/dfs6/pub/nujagar/work_EE283/Week_4/Prob4"

# Index BAM files
samtools index $A4
samtools index $A5

# Run bamCoverage
bamCoverage -b $A4 -o ${dir}/A4_ext.bedgraph --extendReads 500 --normalizeUsing RPKM --region X:1903000:1905000 --binSize 10 --outFileFormat bedgraph
bamCoverage -b $A5 -o ${dir}/A5_ext.bedgraph --extendReads 500 --normalizeUsing RPKM --region X:1903000:1905000 --binSize 10 --outFileFormat bedgraph
