gdata <- gdata <- High_vs_lnput_positive

genelist = gdata$`pos|lfc`
names(genelist) = gdata$id
genelist = sort(genelist, decreasing = FALSE)

gseResHigh = EnrichAnalyzer(genelist, method = "GSEA", type = "Pathway", organism = "hsa")
# GSEA作图

pathway = "Processing of Capped Intron-Containing Pre-mRNA"
idx = which(gseResHigh$Description == pathway)
p = gseaplot2(gseRes1, idx,base_size = 10, title = pathway)
p[[3]][["labels"]][["x"]] = ""
p[[3]][["labels"]][["y"]] = "log2FC"
p[[1]][["labels"]][["y"]] = "Normalized Enrichment Score"

p


ggsave("Demo.png", plot = last_plot(),dpi = 600, width = 12, height = 8)

