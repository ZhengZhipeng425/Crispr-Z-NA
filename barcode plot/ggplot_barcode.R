library(ggplot2)

# 假设sg数据已经准备好了
sg <- High
sg <- sg[order(sg$sgrna_lfc), ]

# 定义x轴的范围
xlim <- c(min(sg$sgrna_lfc) - 1, max(sg$sgrna_lfc) + 1)
gene <- c("IGF2BP1", "JMJD6", "EIF4H")

# 定义y轴的位置
binwidth <- 2
interval <- 0.5
ybottom <- c()
ytop <- c()
for (i in 1:length(gene)) {
  ybottom <- append(ybottom, interval * i + binwidth * (i - 1))
  ytop <- append(ytop, interval * i + binwidth * i)
}

# 创建数据框用于ggplot
plot_data <- data.frame()
for (i in 1:length(gene)) {
  gene_data <- subset(sg, Gene_ID == gene[i])
  plot_data <- rbind(plot_data, data.frame(
    gene = gene[i],
    sgrna_lfc = gene_data$sgrna_lfc,
    ybottom = ybottom[i],
    ytop = ytop[i]
  ))
}

# 创建ggplot
ggplot(plot_data, aes(x = sgrna_lfc, y = factor(gene, levels = gene))) +
  geom_segment(aes(x = sgrna_lfc, xend = sgrna_lfc, y = ybottom, yend = ytop), 
               color = rgb(0.6, 0.6, 0.6, 0.06), size = 0.35) +
  geom_vline(xintercept = 0, linetype = 2, color = "green", size = 0.8) +
  geom_segment(data = plot_data, aes(x = sgrna_lfc, xend = sgrna_lfc, y = ybottom, yend = ytop), 
               color = "red", size = 1.2) +
  geom_rect(aes(xmin = min(xlim) + 1, xmax = max(xlim) - 1, ymin = ybottom, ymax = ytop), 
            color = "black", fill = NA, linewidth = 1.5) +
  scale_x_continuous(limits = xlim, name = "Log2(Fold change)") +
  theme_minimal(base_size = 14) +
  theme(axis.text.y = element_text(angle = 0, hjust = 1, size = 12),
        axis.text.x = element_text(size = 12),
        axis.title.x = element_text(size = 13, margin = margin(t = 10)),
        axis.title.y = element_blank(),
        panel.grid = element_blank(),
        plot.margin = unit(c(1, 1, 1, 1), "cm"))
