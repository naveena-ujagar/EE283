#!/bin/bash
#SBATCH --job-name=RealDNAseqAlign    ## Name of the job.
#SBATCH -A class-ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=12  ## number of cores the job needs
#SBATCH --error=RealDNAseqAlign.%A_%a.err
#SBATCH --output=RealDNAseqAlign.%A_%a.out
#SBATCH --mem-per-cpu=3G    ## can go from 3-6GB/core std queue
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue
#SBATCH --array=1-12  

module load bwa/0.7.8
module load samtools/1.15.1  

# idx contains index files
idx="/pub/nujagar/work_EE283/Week_2/DNAseq/Ref/dmel-all-chromosome-r6.13.fasta"
data="/pub/nujagar/work_EE283/Week_2/DNAseq/RawData"
out="/pub/nujagar/work_EE283/Week_2/DNAseq/Aligned"

#first create prefixes txt file (not in this script) in the RawData directory
#ls raw/DNAseq2/*1.fq.gz | sed 's/_1.fq.gz//' >prefixes.txt

prefix=`head -n $SLURM_ARRAY_TASK_ID ${data}/prefixes.txt | tail -n 1`


bwa mem -t $SLURM_CPUS_PER_TASK -M $idx ${data}/${prefix}_1.fq.gz ${data}/${prefix}_2.fq.gz \
	| samtools sort - -@ $SLURM_CPUS_PER_TASK -m 4G -o ${out}/${prefix}.sort.bam
