library(ggplot2)#柱状图和点状图
library(enrichplot)#GO,KEGG,GSEA
library(clusterProfiler)#GO,KEGG,GSEA
library(GOplot)#弦图，弦表图，系统聚类图
library(DOSE)
library(ggnewscale)
library(topGO)#绘制通路网络图
library(circlize)#绘制富集分析圈图
library(ComplexHeatmap)#绘制图例
library(org.Hs.eg.db)

#指定富集分析的物种库
GO_database <- 'org.Hs.eg.db' #GO分析指定物种，物种缩写索引表详见http://bioconductor.org/packages/release/BiocViews.html#___OrgDb
GO<-enrichGO( HP$id,#GO富集分析
              OrgDb = GO_database,
              keyType = "ENTREZID",#设定读取的gene ID类型
              ont = "ALL",#(ont为ALL因此包括 Biological Process,Cellular Component,Mollecular Function三部分）
              pvalueCutoff = 1,#设定p值阈值
              qvalueCutoff = 0.3,#设定q值阈值
              readable = T )

GO@result$TermLabel <- paste0(GO@result$Description, "[", GO@result$ONTOLOGY, "] ")

ggplot(GO@result, aes(y = reorder(TermLabel, -p.adjust), x = Count, fill = p.adjust)) + 
  #facet_grid(ONTOLOGY ~ ., scales = "free") +
  geom_bar(stat = "identity", width = 0.8) +  # 设置 bar 的宽度 
  labs(x = "Count", y = NULL, title = NULL) +
  scale_fill_gradient(low = "#EE7647", high = "#6DAEDB") +  
  scale_x_continuous(expand = c(0, 0), limits = c(0, max(GO@result$Count) * 1.5)) +
  scale_y_discrete(labels = scales::wrap_format(20)) +  # 15字符换行
  theme(axis.text.y = element_text(size = 10), # 修改pathway标签字体大小
        axis.text.x = element_text(size = 8),
        axis.title = element_text(size = 10),
        legend.text = element_text(size = 8),    # 调整图例文本的字体大小
        legend.title = element_text(size = 10),   # 调整图例标题的字体大小
        strip.text = element_text(size = 8) # 修改ontology字体大小
  )

ggsave("GO_LP.png", width = 8, height = 7, dpi = 300)
