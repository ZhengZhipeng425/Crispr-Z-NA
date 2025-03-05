# 读取高亮基因列表
tmp <- read.csv('/Users/zhengzhipeng/Documents/GitHub/Crispr-Z-NA/sg.csv', header = FALSE)
highlight_genes <- as.character(tmp[,1])  # 确保是字符型

# 读取数据
data <- read.csv('/Users/zhengzhipeng/Documents/GitHub/Z-NA-Crispr-Screening/Crispr Sequencing data/AnalysisScripts/High_vs_lnput.positive.csv')

# 按 LFC 值降序排列
data_sorted <- data[order(data$pos.lfc, decreasing = TRUE), ]
data_sorted$x_coord <- seq(1, nrow(data_sorted), by = 1)

# 设置颜色、大小、透明度等
data_sorted$color <- ifelse(data_sorted$id %in% highlight_genes, "red", "gray")
data_sorted$size <- ifelse(data_sorted$id %in% highlight_genes, 1.5, 0.7)
data_sorted$label <- ifelse(data_sorted$id %in% highlight_genes, data_sorted$id, "")

# 计算 x 轴终点的位置
max_x <- length(unique(data_sorted$id))  # 基因数量
extra_offset <- 8000  # 额外偏移量，调整以优化可读性
label_x <- max_x + extra_offset  # 标签最终的 x 轴位置

# 均匀分配每个标签的 y 轴位置
label_y_values <- seq(max(data_sorted$pos.lfc), min(data_sorted$pos.lfc), length.out = sum(data_sorted$color == "red"))

# 筛选高亮基因
highlight_data <- data_sorted[data_sorted$color == "red", ]  

# 按 y 轴值（pos.lfc）排序，确保标签从上到下排布
highlight_data <- highlight_data[order(-highlight_data$pos.lfc), ]  

# 将 label_y 分配给对应的红色基因
highlight_data$label_y <- label_y_values

# 根据基因名（id）将 label_y 值传递到 data_sorted 中
data_sorted$label_y <- ifelse(data_sorted$id %in% highlight_data$id, 
                              highlight_data$label_y[match(data_sorted$id, highlight_data$id)], 
                              NA)

# 生成图形对象
plot <- ggplot(data_sorted, aes(x = x_coord, y = pos.lfc)) +
  geom_hline(yintercept = 0, color = "#323232", linewidth = 0.5) +
  geom_hline(yintercept = 0.7, linetype = "dashed", color = "#6DAEDB", linewidth = 0.5) +
  geom_hline(yintercept = -0.7, linetype = "dashed", color = "#6DAEDB", linewidth = 0.5) +
  geom_point(aes(color = factor(color), size = size, alpha = ifelse(color == "gray", 1, 0))) +
  geom_point(data = data_sorted[data_sorted$color == "red", ], aes(color = factor(color), size = size, alpha = 1)) +
  
  
  # 连接数据点到右侧标签的折线
  geom_segment(data = data_sorted[data_sorted$color == "red" & data_sorted$pos.lfc > 0.7, ],
               aes(x = x_coord, xend = max_x + 200,  # 先连接到右侧固定偏移位置
                   y = pos.lfc, yend = label_y),
               color = "black", linewidth = 0.1, alpha = 0.5) +
  
  # 在 label_y 处加水平线，连接到最终的标签位置
  geom_segment(data = data_sorted[data_sorted$color == "red" & data_sorted$pos.lfc > 0.7, ],
               aes(x = max_x + 200, xend = label_x, 
                   y = label_y, yend = label_y),
               color = "black", linewidth = 0.1, alpha = 0.5) +
  
  # 在右侧显示基因标签
  geom_text(data = data_sorted[data_sorted$color == "red" & data_sorted$pos.lfc > 0.7, ],
            aes(x = label_x, y = label_y, label = label),
            size = 3, hjust = 0) +
  
  labs(title = "LFC", x = "Gene", y = "Log2 Fold Change") +
  scale_color_manual(values = c("gray", "#EE7647")) +
  scale_size_continuous(range = c(0, 1.2)) +
  scale_alpha_continuous(range = c(0, 1)) +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y = element_text(size = 10),
    axis.ticks.y = element_line(),
    plot.margin = margin(20, 20, 20, 20),  # 右侧留出空间
    axis.line.y.left = element_line(color = "#323232", linewidth = 0.5),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "white", color = "white"),
    plot.background = element_rect(fill = "white", color = "white")
  ) +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.05)), breaks = c(2, 0.7, 0, -0.7, 2, 4)) +
  scale_x_discrete(expand = expansion(mult = c(0.02, 0.02))) +
  scale_x_continuous(limits = c(min(data_sorted$x_coord), max(data_sorted$x_coord) + 10000))+
  guides(color = "none", size = "none", alpha = "none")

# 保存图形到文件
ggsave("~/Documents/GitHub/Crispr-Z-NA/Highpositive_waterfall_demo3.png", plot, bg = "transparent", dpi = 800)
