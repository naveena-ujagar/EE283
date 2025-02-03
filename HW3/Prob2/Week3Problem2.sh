#!/bin/bash
#SBATCH --job-name=Week3Problem2    ## Name of the job.
#SBATCH -A class-ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=1  ## number of cores the job needs
#SBATCH --error=Week3Problem2.err
#SBATCH --output=Week3Problem2.out
#SBATCH --mem-per-cpu=3G    ## can go from 3-6GB/core std queue
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue


module load fastqc/0.11.9 
module load trimmomatic/0.39
module load java/1.8.0

# Run fastqc on a pair of ATACseq fastq files
dir="/pub/nujagar/work_EE283/Week_2/ATACseq"

READ1=${dir}/RawData/A4_ED_2_R1.fq.gz
READ2=${dir}/RawData/A4_ED_2_R2.fq.gz

# NOTE: initially my symlinks didnt have .fq.gz extensions, and fastqc couldnt parse them correctly. Updated my symlinks to have the .fq.gz extension
fastqc ${READ1} ${READ2} -o ${dir}/FastQC



# *** Run trimmomatic
# Trimmomatic
dirout="/pub/nujagar/work_EE283/Week_2/ATACseq/Trimmed"
trimmodir="/opt/apps/trimmomatic/0.39"
java -jar ${trimmodir}/trimmomatic-0.39.jar PE -threads 4 \
    ${READ1} ${READ2} \
    ${dirout}/A4_ED_2_R1_paired.fq ${dirout}/A4_ED_2_R1_unpaired.fq \
    ${dirout}/A4_ED_2_R2_paired.fq ${dirout}/A4_ED_2_R2_unpaired.fq \
    ILLUMINACLIP:${trimmodir}/adapters/NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36


# *** Rerun fastqc
fastqc ${dirout}/A4_ED_2_R1_paired.fq ${dirout}/A4_ED_2_R2_paired.fq -o ${dir}/TrimmedFastQC
