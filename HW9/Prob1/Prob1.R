        library(ggplot2)
        library(tidyverse)
        library(nycflights13)
        library(gridExtra)
        library(grid)
        library(patchwork)

        P1 <- ggplot(flights, aes(x=distance,y=arr_delay)) +
          geom_point() + 
          geom_smooth()
        
        temp_flights <- flights %>%
          group_by(carrier) %>%
          summarize(m_arr_delay = mean(arr_delay,na.rm=TRUE))
        
        P2 <- ggplot(temp_flights, aes(x=carrier,y= m_arr_delay)) +
          geom_bar(stat="identity")
        
        P3 <- ggplot(flights, aes(x=carrier, y=arr_delay)) + 
          geom_boxplot()
        
        P4 <- ggplot(flights, aes(x=arr_delay)) +
          geom_histogram()
       
        grid.arrange(P1,P2,P3,P4,ncol=2)
        
        lay <- rbind(c(1,1,1,2),
                     c(1,1,1,3),
                     c(1,1,1,4))
        tiff("figure1.tiff", width = 7, height = 6, units = "in", res=600)
        print(grid.arrange(P1,P2,P3,P4, layout_matrix = lay))
        dev.off()
        
        png("patch.fig1.png", width = 7, height = 6, units="in", res = 600)
        print((P1 | P2) / (P3 | P4))
        dev.off()
        
        Layout = '
        AAAB
        AAAC
        AAAD
        '
        png("FINAL.png", width = 14, height = 12, units="in", res = 600)
        print(P1 + P2 + P3 + P4 + plot_layout(design = Layout) + 
                plot_annotation(tag_levels = 'A'))
        dev.off()
