        library(ggplot2)
        library(tidyverse)
        library(gridExtra)
        library(grid)
        library(patchwork)
        library(pdftools)
        library(png)
        
        # Set the input directory path
        input_dir <- "C:/Users/sosha/Desktop/EE283/HW9/Prob2/ATAseqPlots"
        
        # Set the output directory path
        output_dir <- "C:/Users/sosha/Desktop/EE283/HW9/Prob2"
        
        # Get list of PDF files
        pdf_files <- list.files(input_dir, pattern = "\\.pdf$", full.names = TRUE)
        
        # Function to convert PDF to PNG and then to grob
        pdf_to_grob <- function(file) {
          png_file <- tempfile(fileext = ".png")
          pdftools::pdf_convert(file, filenames = png_file, dpi = 300)
          img <- png::readPNG(png_file)
          g <- rasterGrob(img)
          file.remove(png_file)
          return(g)
        }
        
        # Convert PDFs to grobs
        P1 <- pdf_to_grob(pdf_files[1])
        P2 <- pdf_to_grob(pdf_files[2])
        P3 <- pdf_to_grob(pdf_files[3])
        P4 <- pdf_to_grob(pdf_files[4])
        
        # Create and save the 4-panel figure using grid.arrange
        png(file.path(output_dir, "figure1.png"), width = 7, height = 6, units = "in", res=600)
        grid.draw(grid.arrange(P3, P2, P1, P4, ncol=2))
        dev.off()
