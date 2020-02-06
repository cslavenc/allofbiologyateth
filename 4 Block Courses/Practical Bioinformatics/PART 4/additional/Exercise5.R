library(MultiAssayExperiment)
library(SingleCellExperiment)
library(SummarizedExperiment)
library(Seurat)
library(scran)
library(scater)


mae <- readRDS("GSE45719.rds")
experiments(mae)
mae_gene <- experiments(mae)[["gene"]]
mae_gene

counts <- assays(mae_gene)[["count"]]
col_data <- data.frame(cell_id=colData(mae)$geo_accession)

so <- CreateSeuratObject(counts=counts, project="deng", min.cells=3,
                         min.features = 200, meta.data = col_data)
so
so <- subset(x=so, subset = nFeature_RNA>5000 & nFeature_RNA<20000)
so <- NormalizeData(object=so, nnormalization.method = "LogNormalize", 
                    scale.factor=1e4)
so <- FindVariableFeatures(object=so, selection.method="vst", 
                           nfeatures=5000)
top5 <- head(VariableFeatures(so), 5)
top5
LabelPoints(plot=VariableFeaturePlot(so), points=top5, repel=TRUE)
so <- ScaleData(so)

# PCA
so <- RunPCA(object=so, ndims.print = 1:3, nfeatures.print=5)
DimPlot(object=so, reduction= "pca")
DimHeatmap(so, dims = 1, cells = 500, balanced = TRUE) # first PC
DimHeatmap(so, dims = 1:6, cells = 500, balanced = TRUE) # first 6 PCs

# Select PCs
ElbowPlot(so)

# Cluster
so <- FindNeighbors(so, dims = 1:10)
so <- FindClusters(so, resolution = 0.5)
# Clustering results:
head(Idents(so), 5)

# Make sce
so_sce <- SingleCellExperiment(assays=list(counts=so@assays$RNA@counts, logcounts=so@assays$RNA@data),
                               colData = so@meta.data, reducedDims = lapply(so@reductions, function(u) u@cell.embeddings))
assayNames(so_sce)
names(colData(so_sce))
reducedDimNames(so_sce)


# Run tSNE
so_sce <- runTSNE(so_sce, components = 2, ntop = 500, exprs_values = "logcounts")

# Run UMAP
so_sce <- runUMAP(so_sce, ncomponents=2, ntop=500, exprs_values = "logcounts")

# Plot
multiplot(cols = 2,
          plotTSNE(so_sce, colour_by = "seurat_clusters") + 
            ggtitle("Tsne - (no global structure)"),
          plotUMAP(so_sce, colour_by = "seurat_clusters") + 
            ggtitle("UMAP - (global structure)"))


# Markers
so_markers <- findMarkers(so_sce, clusters = so_sce$seurat_clusters, lfc = 1, direction = "up") #higher expression or nay

# View markers for 1st cluster
head(so_markers[[1]])

VlnPlot(so, features = "ENSMUSG00000050708.15")

"""
gs <- c("ENSMUSG00000050708.15", "ENSMUSG00000057666.18", "ENSMUSG00000029304.14", "ENSMUSG00000074768.5")
ps <- lapply(gs, function(g) plotPCA(so_sce, colour_by = g))
multiplot(cols = 4, plotlist = ps)
"""

# Filter FDR < 0.05
so_markers <- lapply(so_markers, 
                       function(u) u[u$FDR < 0.05, ])

# Count markers for each cluster
sapply(so_markers, nrow)

# Pull out marker genes
marker_gs <- sapply(so_markers, rownames)
marker_gs <- unlist(marker_gs)

# Plot top 10 marker genes for each cluster
plotHeatmap(
  object = so_sce, 
  features = marker_gs, 
  colour_columns_by = "seurat_clusters", 
  show_colnames = FALSE)
