#!/bin/sh
#SBATCH -A class-ecoevo283
#SBATCH --job-name=Week5Prob1    # Job name
#SBATCH --cpus-per-task=4 		 
#SBATCH --mem-per-cpu=8G
#SBATCH --error=Week5Prob1.%A_%a.err
#SBATCH --output=Week5Prob1.%A_%a.out
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue


module load java/1.8.0
module load gatk/4.2.6.1 
module load picard-tools/2.27.1  
module load samtools/1.15.1


bamdir="/pub/nujagar/work_EE283/Week_2/DNAseq/Aligned"
out="/pub/nujagar/work_EE283/Week_5/Prob1"
ref="/pub/nujagar/work_EE283/Week_2/DNAseq/Ref/dmel-all-chromosome-r6.13.fasta"
prefix=`head -n $SLURM_ARRAY_TASK_ID ${bamdir}/prefix.txt | tail -n 1`


/opt/apps/gatk/4.2.6.1/gatk HaplotypeCaller -R $ref \
	-I ${out}/${prefix}.dedup.bam \
	--minimum-mapping-quality 30 \
	-ERC GVCF \
	-O ${out}/${prefix}.g.vcf.gz

/opt/apps/gatk/4.2.6.1/gatk CombineGVCFs -R $ref $(printf -- '-V %s ' ${out}/*.g.vcf.gz) -O ${out}/allsample.g.vcf.gz
