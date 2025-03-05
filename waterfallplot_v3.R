# This version is designed to perform genes' tags in legend rather along with points themselves.
# 高亮基因存储在数组中
tmp <- read.csv('/Users/zhengzhipeng/Documents/GitHub/Crispr-Z-NA/sg.csv')
highlight_genes <- as.array(tmp[,1])

# 读取数据
data <- read.csv('/Users/zhengzhipeng/Documents/GitHub/Z-NA-Crispr-Screening/Crispr Sequencing data/AnalysisScripts/Low_vs_lnput.positive.csv')

# 按 LFC 值降序排列
data_sorted <- data[order(data$pos.lfc, decreasing = TRUE), ]

# 设置颜色、大小、透明度等
data_sorted$color <- ifelse(data_sorted$id %in% highlight_genes, "red", "gray")
data_sorted$size <- ifelse(data_sorted$id %in% highlight_genes, 1.5, 0.7)
data_sorted$label <- ifelse(data_sorted$id %in% highlight_genes, data_sorted$id, "")

# 生成图形对象
plot <- ggplot(data_sorted, aes(x = reorder(id, -pos.lfc), y = pos.lfc)) +
  geom_hline(yintercept = 0, color = "#323232", linewidth = 0.5) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "#6DAEDB", linewidth = 0.5) +
  geom_hline(yintercept = -1, linetype = "dashed", color = "#6DAEDB", linewidth = 0.5) +
  geom_point(aes(color = color, size = size, alpha = ifelse(color == "gray", 1, 0))) +
  geom_point(data = data_sorted[data_sorted$color == "red", ], aes(color = color, size = size, alpha = 1)) +
  # 使用 geom_text_repel 让标签自动避开
  geom_text_repel(aes(label = label), 
                  size = 2,           # 文字大小
                  box.padding = 1,  # 文字与点的间距
                  max.overlaps = 3000,  # 允许的最大重叠数量
                  segment.color = "gray") +  # 连接点的线条颜色
  labs(title = "LFC", x = "Gene", y = "Log2 Fold Change") +
  scale_color_manual(values = c("gray", "#EE7647")) +
  scale_size_continuous(range = c(0, 1.2)) +
  scale_alpha_continuous(range = c(0, 1)) +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y = element_text(size = 10),
    axis.ticks.y = element_line(),
    plot.margin = margin(20, 20, 20, 20),
    axis.line.y.left = element_line(color = "#323232", linewidth = 0.5),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "white", color = "white"),
    plot.background = element_rect(fill = "white", color = "white")
  ) +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.05))) +
  scale_x_discrete(expand = expansion(mult = c(0.02, 0.02))) +
  guides(color = "none", size = "none", alpha = "none")

# 保存图形到文件
ggsave("~/Documents/GitHub/Crispr-Z-NA/lowpositive_waterfall_demo.png", plot, bg = "transparent", dpi = 800)