## Naveena Ujagar
## EE283 HW10
## Introduction to scRNA-seq integration: https://github.com/satijalab/seurat/blob/HEAD/vignettes/integration_introduction.Rmd

        library(Seurat)
        library(SeuratData)
        library(patchwork)

# install dataset
        InstallData("ifnb")

# load dataset
        ifnb <- LoadData("ifnb")

# split the RNA measurements into two layers one for control cells, one for stimulated cells
        ifnb[["RNA"]] <- split(ifnb[["RNA"]], f = ifnb$stim)
        ifnb
        
# perform analysis without integration
# run standard anlaysis workflow
        ifnb <- NormalizeData(ifnb)
        ifnb <- FindVariableFeatures(ifnb)
        ifnb <- ScaleData(ifnb)
        ifnb <- RunPCA(ifnb)
        ifnb <- FindNeighbors(ifnb, dims = 1:30, reduction = "pca")
        ifnb <- FindClusters(ifnb, resolution = 2, cluster.name = "unintegrated_clusters")
        ifnb <- RunUMAP(ifnb, dims = 1:30, reduction = "pca", reduction.name = "umap.unintegrated")
        DimPlot(ifnb, reduction = "umap.unintegrated", group.by = c("stim", "seurat_clusters"))

# perform integration
        ifnb <- IntegrateLayers(object = ifnb, method = CCAIntegration, orig.reduction = "pca", new.reduction = "integrated.cca",
                                verbose = FALSE)
        
        # re-join layers after integration
        ifnb[["RNA"]] <- JoinLayers(ifnb[["RNA"]])
        
        ifnb <- FindNeighbors(ifnb, reduction = "integrated.cca", dims = 1:30)
        ifnb <- FindClusters(ifnb, resolution = 1)
        
        ifnb <- RunUMAP(ifnb, dims = 1:30, reduction = "integrated.cca")
        
        # Visualization
        DimPlot(ifnb, reduction = "umap", group.by = c("stim", "seurat_annotations"))
        DimPlot(ifnb, reduction = "umap", split.by = "stim")

# identify conserved cell type markers
        Idents(ifnb) <- "seurat_annotations"
        nk.markers <- FindConservedMarkers(ifnb, ident.1 = "NK", grouping.var = "stim", verbose = FALSE)
        head(nk.markers)
        
        # NEEDS TO BE FIXED AND SET ORDER CORRECTLY
        Idents(ifnb) <- factor(Idents(ifnb), levels = c("pDC", "Eryth", "Mk", "DC", "CD14 Mono", "CD16 Mono",
                                                        "B Activated", "B", "CD8 T", "NK", "T activated", "CD4 Naive T", "CD4 Memory T"))
        
        markers.to.plot <- c("CD3D", "CREM", "HSPH1", "SELL", "GIMAP5", "CACYBP", "GNLY", "NKG7", "CCL5",
                             "CD8A", "MS4A1", "CD79A", "MIR155HG", "NME1", "FCGR3A", "VMO1", "CCL2", "S100A9", "HLA-DQA1",
                             "GPR183", "PPBP", "GNG11", "HBA2", "HBB", "TSPAN13", "IL3RA", "IGJ", "PRSS57")
        DotPlot(ifnb, features = markers.to.plot, cols = c("blue", "red"), dot.scale = 8, split.by = "stim") +
          RotatedAxis()
        
# identify differential expressed genes across conditions
        library(ggplot2)
        library(cowplot)
        theme_set(theme_cowplot())
        
        # AggregateExpression: aggregate cells of a similar type and condition together to create “pseudobulk” profiles
        aggregate_ifnb <- AggregateExpression(ifnb, group.by = c("seurat_annotations", "stim"), return.seurat = TRUE)
        genes.to.label = c("ISG15", "LY6E", "IFI6", "ISG20", "MX1", "IFIT2", "IFIT1", "CXCL10", "CCL8")
        
        p1 <- CellScatter(aggregate_ifnb, "CD14 Mono_CTRL", "CD14 Mono_STIM", highlight = genes.to.label)
        p2 <- LabelPoints(plot = p1, points = genes.to.label, repel = TRUE)
        
        p3 <- CellScatter(aggregate_ifnb, "CD4 Naive T_CTRL", "CD4 Naive T_STIM", highlight = genes.to.label)
        p4 <- LabelPoints(plot = p3, points = genes.to.label, repel = TRUE)
        
        # compare pseudobulk profiles of two cell types (naive CD4 T cells, and CD14 monocytes), and compare their gene expression profiles before and after stimulation. 
        p2 + p4
        
        # look at CD4 Memory T cells (specific interest in Th17 cell markers) - my own test, not on tutorial
        genes.to.label2 = c("IL17A","IL17F","RORgt","IL22","IL21","IL23R","IFNg","CD101","TIMD4")
        p5 <- CellScatter(aggregate_ifnb, "CD4 Memory T_CTRL", "CD4 Memory T_STIM", highlight = genes.to.label2)
        p6 <- LabelPoints(plot = p5, points = genes.to.label2, repel = T)
        p6 #not a lot going on with Th17 markers...
        
        # output a list of genes that change in CD4 Memory T cells bw CTRL and STIM (conditions)
        ifnb$celltype.stim <- paste(ifnb$seurat_annotations, ifnb$stim, sep = "_")
        Idents(ifnb) <- "celltype.stim"
        TMem.interferon.response <- FindMarkers(ifnb, ident.1 = "CD4 Memory T_STIM", ident.2 = "CD4 Memory T_CTRL", verbose = FALSE)
        head(TMem.interferon.response, n = 15)
        
        # redo the Th17 markers try (p6) with the top differential genes bw conditions
        genes.to.label3 = c("ISG15","IFI6","ISG20","IFIT1","IFIT3","LY6E","MX1","MT2A")
        p7 <- CellScatter(aggregate_ifnb, "CD4 Memory T_CTRL", "CD4 Memory T_STIM", highlight = genes.to.label2)
        p8 <- LabelPoints(plot = p7, points = genes.to.label3, repel = T)
        p8 # plotted markers that change in CD4 Memory T cells bw conditions
        
        # visualize gene expression changes for markers for T and B cells
        FeaturePlot(ifnb, features = c("CD3D", "CD19"), split.by = "stim", 
                    max.cutoff = 3, cols = c("grey", "red"), reduction = "umap")
        
        #Different way to visualize gene expression changes
        plots <- VlnPlot(ifnb, features = c("CD3D","CD19"), split.by = "stim", group.by = "seurat_annotations",
                         pt.size = 0, combine = FALSE)
        wrap_plots(plots = plots, ncol = 1)
        
# perform integration with SCTransform-normalized datasets (alternative to log-normalization)
        # Better at removing technical effects, especially sequencing depth.
        # Improves normalization for genes with low expression levels.
        # Can lead to better downstream analysis results (e.g., clustering, differential expression).
        # Can take longer/computationally intensive
        ifnb2 <- LoadData("ifnb")
        
        # split datasets and process without integration
        ifnb2[["RNA"]] <- split(ifnb2[["RNA"]], f = ifnb2$stim)
        ifnb2 <- SCTransform(ifnb2)
        ifnb2 <- RunPCA(ifnb2)
        ifnb2 <- RunUMAP(ifnb2, dims = 1:30)
        DimPlot(ifnb2, reduction = "umap", group.by = c("stim", "seurat_annotations"))
        
        # integrate datasets
        ifnb2 <- IntegrateLayers(object = ifnb2, method = CCAIntegration, normalization.method = "SCT", verbose = F)
        ifnb2 <- FindNeighbors(ifnb2, reduction = "integrated.dr", dims = 1:30)
        ifnb2 <- FindClusters(ifnb2, resolution = 0.6)
        ifnb2 <- RunUMAP(ifnb2, dims = 1:30, reduction = "integrated.dr")
        DimPlot(ifnb2, reduction = "umap", group.by = c("stim", "seurat_annotations"))
        
        # perform differential expression
        ifnb2 <- PrepSCTFindMarkers(ifnb2)
        ifnb2$celltype.stim <- paste(ifnb2$seurat_annotations, ifnb2$stim, sep = "_")
        Idents(ifnb2) <- "celltype.stim"
        b.interferon.response <- FindMarkers(ifnb2, ident.1 = "B_STIM", ident.2 = "B_CTRL", verbose = FALSE)
        
        
