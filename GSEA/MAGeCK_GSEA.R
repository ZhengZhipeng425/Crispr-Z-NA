gdata <- Low_vs_lnput_positive

genelist = gdata$`pos|lfc`
names(genelist) = gdata$id
genelist = sort(genelist, decreasing = FALSE)

gseResLow = EnrichAnalyzer(genelist, method = "GSEA", type = "Pathway", organism = "hsa")
# GSEA作图

# pathway = "Processing of Capped Intron-Containing Pre-mRNA"
ID = "REACTOME_379716"
idx = which(gseResHigh$ID == ID)
p = gseaplot2(gseResHigh, idx,base_size = 15, title = gseResHigh[idx]$Description)
p[[3]][["labels"]][["x"]] = ""
p[[3]][["labels"]][["y"]] = "log2FC"
p[[1]][["labels"]][["y"]] = "Normalized Enrichment Score"

p


ggsave(paste(gseResHigh[idx]$Description, "_Low.png"), plot = last_plot(),dpi = 600, width = 9, height = 6)

