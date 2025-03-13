
# 示例数据
data <- read.csv('/Users/zhengzhipeng/Documents/GitHub/Z-NA-Crispr-Screening/Crispr Sequencing data/AnalysisScripts/High_vs_lnput.positive.csv')

# 按 LFC 值降序排列
data_sorted <- data[order(data$pos.lfc, decreasing = TRUE), ]

# 设置颜色、大小、透明度等
data_sorted$color <- ifelse(data_sorted$id %in% c("GPR141", "MYLK2"), "red", "gray")
data_sorted$size <- ifelse(data_sorted$id %in% c("GPR141", "MYLK2"), 2, 1)
data_sorted$label <- ifelse(data_sorted$id %in% c("GPR141", "MYLK2"), data_sorted$id, "")
# data_sorted$alpha <- ifelse(data_sorted$color == "red", 1, 0.5)  

ggplot(data_sorted, aes(x = reorder(id, -pos.lfc), y = pos.lfc)) +
  # 第一次绘制：所有点，非高亮点显示，设置高亮点透明
  geom_point(aes(color = color, size = size, alpha = ifelse(color == "gray", 1, 0))) +  # 高亮点透明
  # 第二次绘制：高亮点显示，非高亮点透明
  geom_point(data = data_sorted[data_sorted$color == "red", ],  # 仅绘制高亮点
             aes(color = color, size = size, alpha = 1)) +  # 高亮点透明度设置为 1
  # 添加标签
  geom_text(aes(label = label), vjust = -0.5, color = "black", size = 4) +
  labs(title = "基因 LFC 值散点图", x = "基因", y = "Log2 Fold Change") +
  scale_color_manual(values = c("gray", "red")) +  # 高亮基因为红色，其他基因为灰色
  scale_size_continuous(range = c(1, 2)) +  # 这里设置连续范围，大小为 2 到 4
  scale_alpha_continuous(range = c(0, 1)) +  # 设置透明度范围
  theme_minimal() +
  theme(
    axis.text.x = element_blank(),  # 隐藏 x 轴标签
    axis.ticks.x = element_blank()  # 隐藏 x 轴刻度线
  ) +

  # 隐藏图例（size 和 color）
  guides(color = "none", size = "none", alpha = "none")

