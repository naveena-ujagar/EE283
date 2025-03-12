 #manhattan plot from malathion dataset week 8
        library(tidyverse)
        library(qqman)
        library(cowplot)
        library(gridGraphics)
        library(dplyr)
        library(ggplot2)
        library(patchwork)
        library(gridExtra)
        library(grid)
        library(readr)
        
        setwd("/Users/sosha/Desktop/EE283/HW8")
        
        #check levels
        model1 <- read_tsv("genome_wide_scan_results.tsv")
        View(model1)
        levels(as.factor(model1$chr))
        unique(model1$chr)
        
        # Function to preprocess data for Manhattan plot
        res1 <- read_tsv("genome_wide_scan_results.tsv") %>%
          mutate(
            SNP = paste0(chr, "_", pos), #create uniquue SNP identifier (chr_position)
            CHR = case_when(              # Convert chromosome names to numeric values
              chr == "chrX"  ~ 1,
              chr == "chr2L" ~ 2,
              chr == "chr2R" ~ 3,
              chr == "chr3L" ~ 4,
              chr == "chr3R" ~ 5,
              TRUE ~ NA_real_  # Assign NA instead of coercing
            ),
            BP = pos,            #base pair position remains the same
            P = neg_log10_p  # Dynamically select the significance column (neg log10 p-values)
          ) %>%
          drop_na(CHR) %>%  # Remove NAs safely
          select(CHR, BP, SNP, P) #keep only essential columns
        unique(res1$CHR)
        colnames(res1)
        
        # Check for unexpected chromosome names
        unexpected_chr <- setdiff(unique(model1$chr), c("chrX", "chr2L", "chr2R", "chr3L", "chr3R"))
        print(unexpected_chr)  # This will show any values not accounted for in case_when()
        
        res2 <- read_tsv("genome_wide_scan_results_model2.tsv") %>%
          mutate(
            SNP = paste0(chr, "_", pos), #create uniquue SNP identifier (chr_position)
            CHR = case_when(              # Convert chromosome names to numeric values
              chr == "chrX"  ~ 1,
              chr == "chr2L" ~ 2,
              chr == "chr2R" ~ 3,
              chr == "chr3L" ~ 4,
              chr == "chr3R" ~ 5,
              TRUE ~ NA_real_  # Assign NA instead of coercing
            ),
            BP = pos,            #base pair position remains the same
            P = neg_log10_p  # Dynamically select the significance column (neg log10 p-values)
          ) %>%
          drop_na(CHR) %>%  # Remove NAs safely
          select(CHR, BP, SNP, P) #keep only essential columns
        unique(res2$CHR)
        colnames(res2)
        View(res1)
        View(res2)
        
        pdf("C:/Users/sosha/Desktop/EE283/HW9/Prob3/P3_manhattan_plots.pdf", height = 10, width = 9)
        
        # Set up a 2x1 plotting layout with equal heights
        layout(matrix(c(1,2), nrow=2, ncol=1), heights=c(1,1))
        
        # Plot the first Manhattan plot
        manhattan(res1, main = "Significant SNPs from Model 1",
                  ylim = c(0, 10), cex = 0.6, cex.axis = 0.9,
                  col = c("blue4", "orange3"),
                  suggestiveline = -log10(1e-05),
                  genomewideline = -log10(5e-08),
                  logp = TRUE)
        
        # Plot the second Manhattan plot
        manhattan(res2, main = "Significant SNPs from Model 2",
                  ylim = c(0, 10), cex = 0.6, cex.axis = 0.9,
                  col = c("blue4", "orange3"),
                  suggestiveline = -log10(1e-05),
                  genomewideline = -log10(5e-08),
                  logp = TRUE)
        
        dev.off()
        
