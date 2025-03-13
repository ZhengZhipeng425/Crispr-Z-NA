# 加载必要的 R 包
library(ggplot2)
library(pheatmap)

# 生成模拟数据（log2 fold-change）
set.seed(123)
n <- 500  # 模拟500个sgRNA
log2FC <- rnorm(n, mean=0, sd=1.5)  # 正态分布模拟log2FC
sgRNA_labels <- paste0("sg", 1:n)  # 生成sgRNA标签

# 设定显著性阈值
neg_threshold <- -2
pos_threshold <- 2

# 直方图部分（Log2FC 分布）
p1 <- ggplot(data.frame(log2FC), aes(x = log2FC)) +
  geom_histogram(binwidth = 0.3, fill = "gray", color = "black") +
  geom_vline(xintercept = c(neg_threshold, pos_threshold), color = "blue", linetype = "dashed") +
  labs(title = "Log2 Fold-Change Distribution", x = "Log2 Fold-Change", y = "Count") +
  theme_minimal()

# 生成条形图数据
sgRNA_sorted <- sort(log2FC, decreasing = FALSE)  # 按log2FC排序
sgRNA_df <- data.frame(sgRNA = names(sgRNA_sorted), log2FC = sgRNA_sorted)

# 设置颜色：红色表示显著变化的sgRNA
sgRNA_df$color <- ifelse(sgRNA_df$log2FC < neg_threshold | sgRNA_df$log2FC > pos_threshold, "red", "gray")

# 条形图 (Barcode plot)
p2 <- ggplot(sgRNA_df, aes(x = sgRNA, y = log2FC, color = color)) +
  geom_segment(aes(xend = sgRNA, yend = 0), size = 0.5) +
  scale_color_manual(values = c("gray" = "gray", "red" = "red")) +
  labs(title = "sgRNA Selection Barcode Plot", x = "sgRNA", y = "Log2 Fold-Change") +
  theme_minimal() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), legend.position = "none")

# 显示两个图
library(gridExtra)
grid.arrange(p1, p2, nrow = 2)