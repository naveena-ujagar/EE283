        # Create a data frame with -log10(p) values from both models
        comparison_df <- data.frame(
          SNP = res1$SNP,  # Assuming both data frames have a common SNP column
          p1 = res1$P,     # -log10(p) for Model 1
          p2 = res2$P      # -log10(p) for Model 2
        )
        
        # Scatter plot to compare -log10(p) values
        gg3 <- ggplot(comparison_df, aes(x = p1, y = p2)) +
          geom_point(alpha = 0.5, color = "gray") +  # Gray points for general comparison
          geom_smooth(method = "lm", color = "blue") +  # Optional: linear regression line
          ggtitle("Comparison of -log10(p) from Model 1 and Model 2") +
          xlab("Model 1 -log10(p)") +
          ylab("Model 2 -log10(p)") +
          theme_minimal()
        
        # Combine all three plots
        lay <- rbind(
          c(1,1,1,3),  # P1 spans 3 columns, P2 takes 1 column
          c(2,2,2,3)  # P1 spans 3 columns, P3 takes 1 column
        )
        
        pdf("C:/Users/sosha/Desktop/EE283/HW9/Prob3/PlotArrange.pdf", height = 7, width = 30)
        
        # Arrange and display the plots using the custom layout
        grid.arrange(gg1, gg2, gg3, layout_matrix = lay)
        
        # Close the PDF device to save the image
        dev.off()
        
