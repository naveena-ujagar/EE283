        setwd("/Users/sosha/Desktop/EE283/HW9/Prob3/myManhattan")
        source("myManhattanFunction.R")
        
        pdf("C:/Users/sosha/Desktop/EE283/HW9/Prob3/P3_myManhattan_plots.pdf", height = 15, width = 9)
        
        # Set up a 2x1 plotting layout with equal heights
        layout(matrix(c(1,2), nrow=2, ncol=1), heights=c(1,1))
        
        res1 <- na.omit(res1)
        res2 <- na.omit(res2)
        
        # Plot the first Manhattan plot using myManhattan
        myManhattan(res1, 
                    col = c("blue4", "orange3"),
                    suggestiveline = -log10(1e-05),
                    genomewideline = -log10(5e-08))
        
        # Plot the second Manhattan plot using myManhattan
        myManhattan(res2, 
                    col = c("blue4", "orange3"),
                    suggestiveline = -log10(1e-05),
                    genomewideline = -log10(5e-08))
        
        dev.off()
        
