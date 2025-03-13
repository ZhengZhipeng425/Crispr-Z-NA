# 高亮基因存储在数组中
tmp <- read.csv('/Users/zhengzhipeng/Documents/GitHub/Crispr-Z-NA/sg.csv')
highlight_genes <- as.array(tmp[,1])

# 读取数据
data <- read.csv('/Users/zhengzhipeng/Documents/GitHub/Z-NA-Crispr-Screening/Crispr Sequencing data/AnalysisScripts/High_vs_lnput.positive.csv')

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
  # geom_segment(aes(x = max(data_sorted$id) + 0.5, xend = max(data_sorted$id) + 0.5, y = min(data_sorted$pos.lfc), yend = max(data_sorted$pos.lfc)), color = "green", size = 1) +
  # 绘制所有点，高亮点透明
  geom_point(aes(color = color, size = size, alpha = ifelse(color == "gray", 1, 0))) +
  # 仅绘制高亮点，非高亮点透明
  geom_point(data = data_sorted[data_sorted$color == "red", ], aes(color = color, size = size, alpha = 1)) +
  # 添加标签并将标签显示在右边
  geom_text(aes(label = label), hjust = -0.1, vjust = 0.5, color = "black", size = 3) +
  # geom_text_repel(aes(label = label), size = 4, box.padding = 0.5, max.overlaps = 10) +
  labs(title = "LFC", x = "Gene", y = "Log2 Fold Change") +
  scale_color_manual(values = c("gray", "#EE7647")) +
  scale_size_continuous(range = c(0, 1.2)) +
  scale_alpha_continuous(range = c(0, 1)) +
  # theme_bw() +  # 使用 theme_bw() 设置白色背景
  theme(
    axis.text.x = element_blank(),  # 隐藏 x 轴标签
    axis.ticks.x = element_blank(),  # 隐藏 x 轴刻度线
    axis.text.y = element_text(size = 10),  # 设置 y 轴标签的字体大小
    axis.ticks.y = element_line(),  # 显示 y 轴刻度线
    plot.margin = margin(20, 20, 20, 20),  # 添加适当的图形边距
    axis.line.y.left = element_line(color = "#323232", linewidth = 0.5),  # 添加y竖直坐标轴线
    panel.grid.major = element_blank(),  # 移除主网格线
    panel.grid.minor = element_blank(),  # 移除次网格线
    panel.background = element_rect(fill = "white", color = "white"),  # 设置绘图区背景为白色
    plot.background = element_rect(fill = "white", color = "white")
  ) +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.05))) +  # 在上下添加一些空白
  scale_x_discrete(expand = expansion(mult = c(0.02, 0.02))) +  # 在左右添加一些空白
  guides(color = "none", size = "none", alpha = "none")

# 保存图形到文件，并设置透明背景
ggsave("~/Documents/GitHub/Crispr-Z-NA/plot.png", plot, bg = "transparent", dpi = 800)
