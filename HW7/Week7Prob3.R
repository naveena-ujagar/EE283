library(tidyverse)
library(DESeq2)
library(cowplot)

getwd()
sampleInfo = read.table("shortRNAseq.txt")
sampleInfo$FullSampleName = as.character(sampleInfo$FullSampleName)

## I am assuming feature counts finished
countdata = read.table("fly_counts.txt", header=TRUE, row.names=1)
# Remove first five columns (chr, start, end, strand, length)
# or do it the tidy way
countdata = countdata[ ,6:ncol(countdata)]
# Remove crap from colnames in countdata
temp = colnames(countdata)
temp = gsub("X.pub.nujagar.work_EE283.Week_2.RNAseq.Aligned.","",temp)
temp = gsub(".bam","",temp)
colnames(countdata) = temp
## does everything match up...
cbind(temp,sampleInfo$FullSampleName,temp == sampleInfo$FullSampleName)

# create DEseq2 object & run DEseq
dds = DESeqDataSetFromMatrix(countData=countdata, colData=sampleInfo, design=~TissueCode)
dds <- DESeq(dds)
res <- results( dds )
res

plotMA( res, ylim = c(-1, 1) )
plotDispEsts( dds )
hist( res$pvalue, breaks=20, col="grey" )

###  add external annotation to "gene ids"
# log transform
rld = rlog( dds )
## this is where you could just extract the log transformed normalized data for each sample ID, and then roll your own analysis
head( assay(rld) )
mydata = assay(rld)
sampleDists = dist( t( assay(rld) ) )

# heat map
sampleDistMatrix = as.matrix( sampleDists )
rownames(sampleDistMatrix) = rld$TissueCode
colnames(sampleDistMatrix) = NULL
library( "gplots" )
library( "RColorBrewer" )
colours = colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
heatmap.2( sampleDistMatrix, trace="none", col=colours)

# PCs
# wow you can sure tell tissue apart
print( plotPCA( rld, intgroup = "TissueCode") )

# heat map with gene clustering
library( "genefilter" )
# these are the top genes (that tell tissue apart no doubt)
topVarGenes <- head( order( rowVars( assay(rld) ), decreasing=TRUE ), 35 )
heatmap.2( assay(rld)[ topVarGenes, ], scale="row", trace="none", dendrogram="column", col = colorRampPalette( rev(brewer.pal(9, "RdBu")) )(255))

# Create a data frame with the results
volcano_data <- data.frame(
  log2FoldChange = res$log2FoldChange,
  padj = res$padj
)

# Remove NA values
volcano_data <- na.omit(volcano_data)

# Create the volcano plot
library(ggplot2)

ggplot(volcano_data, aes(x = log2FoldChange, y = -log10(padj))) +
  geom_point(aes(color = ifelse(padj < 0.05 & abs(log2FoldChange) > 1, "significant", "not significant")), alpha = 0.6) +
  scale_color_manual(values = c("significant" = "red", "not significant" = "grey50")) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed", color = "blue") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "blue") +
  labs(
    title = "Volcano Plot",
    x = "Log2 Fold Change",
    y = "-Log10 Adjusted P-value"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

# Save the plot (optional)
ggsave("volcano_plot.png", width = 10, height = 8, dpi = 300)
