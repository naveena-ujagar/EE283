## Naveena Ujagar
## EE283 Week 8 HW

        # Download dataset for HW
        url <- "http://wfitch.bio.uci.edu/~tdlong/allhaps.malathion.200kb.txt.gz"
        destfile <- "allhaps.malathion.200kb.txt.gz"
        download.file(url, destfile, method = "auto")
        
        # read the data
        library(tidyverse)
        mal = read_tsv("allhaps.malathion.200kb.txt.gz")
        
        # select the first position in the genome
        mal2 = mal %>% filter(chr=="chrX" & pos==316075)
        mal2
        levels(as.factor(mal2$pool))
        levels(as.factor(mal2$founder))	
        
        # fit a model for the change at any given location in the genome
        mal2 = mal2 %>% mutate(treat=str_sub(pool,2,2))
        anova(lm(asin(sqrt(freq)) ~ treat + founder + treat:founder, data=mal2))

## Prob1----
        # Define the function to fit the model and extract p-value
        fit_model <- function(df) {
          df <- df %>% mutate(treat = str_sub(pool, 2, 2))
          
          # Check if there's enough variation in the data to fit the model
          if (length(unique(df$treat)) < 2 || length(unique(df$founder)) < 2) {
            return(tibble(neg_log10_p = NA))
          }
          
          tryCatch({
            model <- lm(asin(sqrt(freq)) ~ treat + founder + treat:founder, data = df)
            anova_result <- anova(model)
            p_value <- anova_result$`Pr(>F)`[1]  # Extract p-value for 'treat'
            return(tibble(neg_log10_p = -log10(p_value)))
          }, error = function(e) {
            return(tibble(neg_log10_p = NA))
          })
        }
        
        # Perform the genome-wide scan
        results1 <- mal %>%
          group_by(chr, pos) %>%
          nest() %>%
          mutate(model_results = map(data, fit_model)) %>%
          unnest(model_results) %>%
          ungroup()
        
        # Write results to a file
        write_tsv(results1, "genome_wide_scan_results.tsv")
        
## Prob2----
        # Define the function to fit the model and extract p-value
        fit_model <- function(df) {
          df <- df %>% mutate(treat = str_sub(pool, 2, 2))
          
          # Check if there's enough variation in the data to fit the model
          if (length(unique(df$treat)) < 2 || length(unique(df$founder)) < 2) {
            return(tibble(neg_log10_p = NA))
          }
          
          tryCatch({
            model <- lm(asin(sqrt(freq)) ~ founder + treat %in% founder, data = df)
            anova_result <- anova(model)
            p_value <- anova_result$`Pr(>F)`[2]  # Extract p-value for 'treat %in% founder'
            return(tibble(neg_log10_p = -log10(p_value)))
          }, error = function(e) {
            return(tibble(neg_log10_p = NA))
          })
        }
        
        # Perform the genome-wide scan
        results2 <- mal %>%
          group_by(chr, pos) %>%
          nest() %>%
          mutate(model_results = map(data, fit_model)) %>%
          unnest(model_results) %>%
          ungroup()
        
        # Write results to a file
        write_tsv(results2, "genome_wide_scan_results_model2.tsv")

## Prob3----
        # Merge the results using a join operation
        merged_results <- results1 %>%
          inner_join(results2, by = c("chr", "pos"))
        
        # Write merged results to a file
        write_tsv(merged_results, "merged_genome_wide_scan_results.tsv")
