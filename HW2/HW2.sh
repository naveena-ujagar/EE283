## DNAseq Symlink
#!/bin/bash
#SBATCH --job-name=DNAseqSymlink    ## Name of the job.
#SBATCH -A class-ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=1  ## number of cores the job needs
#SBATCH --array=1-12       ## discussed more below
#SBATCH --error=DNAseqSymlink_%J.err
#SBATCH --output=DNAseqSymlink_%J.out
#SBATCH --mem-per-cpu=3G    ## can go from 3-6GB/core std queue
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue
SourceDir='/data/class/ecoevo283/public/Bioinformatics_Course/DNAseq'
DestDir='/pub/nujagar/work_EE283/Week_2/DNAseq/RawData'
FILES="$SourceDir/*"
for f in $FILES
do
        ff=$(basename $f)
        echo "Processing $ff file..."
        ln -s $SourceDir/$ff $DestDir/$ff
done


## ATACseq Symlink
#!/bin/bash
#SBATCH --job-name=ATACseqSymlink    ## Name of the job.
#SBATCH -A class-ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=1  ## number of cores the job needs
#SBATCH --array=1-12       ## discussed more below
#SBATCH --error=ATACseqSymlink_%J.err
#SBATCH --output=ATACseqSymlink_%J.out
#SBATCH --mem-per-cpu=3G    ## can go from 3-6GB/core std queue
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue
SourceDir="/data/class/ecoevo283/public/Bioinformatics_Course/ATACseq"
DestDir="/pub/nujagar/work_EE283/Week_2/ATACseq/RawData"
File="README.ATACseq.txt"
while read p
do
   echo "${p}"
   barcode=$(echo $p | cut -f1 -d" ")
   genotype=$(echo $p | cut -f2 -d" ")
   tissue=$(echo $p | cut -f3 -d" ")
   bioRep=$(echo $p | cut -f4 -d" ")
   READ1=$(find ${SourceDir}/ -type f -iname "*_${barcode}_R1.fq.gz")
   READ2=$(find ${SourceDir}/ -type f -iname "*_${barcode}_R2.fq.gz")
# now create the symlink name plus path
if [ -f "$READ1" ] && [ -f "$READ2" ]; then
       # Create informative names for the symlinks
       LINK1="${DestDir}/${genotype}_${tissue}_${bioRep}_R1.fq.gz"
       LINK2="${DestDir}/${genotype}_${tissue}_${bioRep}_R2.fq.gz"
        # now make the symlink
        ln -s "$READ1" "$LINK1"
        ln -s "$READ2" "$LINK2"
fi
done < $File


## RNAseq Symlink
#!/bin/bash
#SBATCH --job-name=RNAseqSymlink    ## Name of the job.
#SBATCH -A class-ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --cpus-per-task=1  ## number of cores the job needs
#SBATCH --array=1-12       ## discussed more below
#SBATCH --error=RNAseqSymlink_%J.err
#SBATCH --output=RNAseqSymlink_%J.out
#SBATCH --mem-per-cpu=3G    ## can go from 3-6GB/core std queue
#SBATCH --time=1-00:00:00   ## 1 day, up to 14 std queue
SourceDir="/data/class/ecoevo283/public/Bioinformatics_Course/RNAseq"
DestDir="/pub/nujagar/work_EE283/Week_2/RNAseq/RawData"


tail -n +2 ${SourceDir}/RNAseq384_SampleCoding.txt > ${DestDir}/RNAseq.labels.txt #cut header off txt file and put into Destination folder
File="${DestDir}/RNAseq.labels.txt" #read file with header cutoff from previous line

while read  p
do
   echo "${p}"
   SampleNumber=$(echo "$p" | cut -f1 -d" ")
   Multiplexi5index=$(echo "$p" | cut -f2 -d" ")
   i7index=$(echo "$p" | cut -f4 -d" ")
   Lane=$(echo "$p" | cut -f3 -d" ")
   FullSampleName=$(echo "$p" | cut -f5 -d" ")

   READ1=$(find "${SourceDir}/" -type f -iname "*_${i7index}_R1.fq.gz")
   READ2=$(find "${SourceDir}/" -type f -iname "*_${i7index}_R2.fq.gz")

   # now create the symlink name plus path
   if [ -f "$READ1" ] && [ -f "$READ2" ]; then
       # Create informative names for the symlinks
       LINK1="${DestDir}/${SampleName}_${FullSampleName}_${Lane}__R1.fq.gz"
       LINK2="${DestDir}/${SampleName}_${FullSampleName}_${Lane}_R2.fq.gz"

       # now make the symlink
       ln -s "$READ1" "$LINK1"
       ln -s "$READ2" "$LINK2"
   fi
done < "$File"

