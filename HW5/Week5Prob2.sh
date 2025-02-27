#!/bin/sh
#SBATCH -A class-ecoevo283
#SBATCH --job-name=Week5Prob2    # Job name
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=3G
#SBATCH --error=Week5Prob2.%A_%a.err
#SBATCH --output=Week5Prob2.%A_%a.out
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue


module load  bcftools/1.15.1

out="/pub/nujagar/work_EE283/Week_5/Prob1"

bcftools filter -i 'FS<40.0 && SOR<3 && MQ>40.0 && MQRankSum>-5.0 && MQRankSum<5 && QD>2.0 && ReadPosRankSum>-4.0 && INFO/DP<16000' -O z -o ${out}/filt1_variants.vcf.gz ${out}/all_variants.vcf.gz

bcftools filter -S . -e 'FMT/DP<3 | FMT/GQ<20' -O z -o ${out}/filt2_variants.vcf.gz ${out}/filt1_variants.vcf.gz

bcftools filter -e 'AC==0 || AC==AN' --SnpGap 10 ${out}/filt2_variants.vcf.gz | \
	bcftools view -m2 -M2 -v snps -O z -o ${out}/filt3_variants.vcf.gz
