#!/bin/bash
#SBATCH --job-name=AlignDNAseqReads    ## Name of the job.
#SBATCH -A class-ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=1  ## number of cores the job needs
#SBATCH --error=AlignDNAseqReads.err
#SBATCH --output=AlignDNAseqReads.out
#SBATCH --mem-per-cpu=3G    ## can go from 3-6GB/core std queue
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue

##Load modules needed
module load samtools
module load bwa
module load picard-tools/2.27.1

##Index the reference genome
ref='/pub/nujagar/work_EE283/Week_2/DNAseq/Ref/dmel-all-chromosome-r6.13.fasta'
bwa index $ref
samtools faidx $ref
java -jar /opt/apps/picard-tools/2.27.1/picard.jar \
CreateSequenceDictionary R=$ref O='/pub/nujagar/work_EE283/Week_2/DNAseq/Ref/dm6.dict'

