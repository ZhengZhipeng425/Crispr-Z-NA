
# This part was used to conduct Low_Positive

gdata <- gdata <- High_vs_lnput_positive %>%
  filter(`pos|lfc` >= 0.7 | `pos|lfc` <= -0.7, `pos|p-value` <= 0.05)


genelist = gdata$`pos|lfc`
names(genelist) = gdata$id
genelist = sort(genelist, decreasing = FALSE)

ortRes2 = EnrichAnalyzer(genelist[1:200], method = "ORT", 
                         type = "KEGG", organism = "hsa")

ortResFliter = EnrichedFilter(ortRes2)
# ---------------------
  
# hgtRes1 = EnrichAnalyzer(genelist[1:200], method = "HGT", 
#                          type = "Pathway", organism = "hsa")
# hgtRes1@result$geneID = hgtRes1@result$geneName
# cnetplot(hgtRes1, 5)
# tmp <- pairwise_termsim(hgtRes1)
# emapplot(tmp, showCategory = 5, layout = "kk")

# ------------------------
  
#修改气泡图横向缩放度：coord_fixed(ratio=1/200)
ggplot(ortResFliter[1:10,] ,aes(x=NES,y=Description)) +
geom_point(aes(size=Count,color=p.adjust)) +
theme_bw() +
labs(y="",x="NES") +
scale_color_gradient(low="#6DAEDB",high="#EE7647") +
#scale_x_continuous(breaks = seq(0,0.005, by = 0.002)) +
coord_fixed(1/3)


ggsave("KEGG_HP.png", dpi = 600, width = 10, height = 8)

