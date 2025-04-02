library(ggplot2)

data <- High_p_merged
data$logP <- -log10(data$pvalue)

# 添加显著性标注列
data$Significant <- "Not Significant"
data$Significant[data$lfc > 0.7 & data$pvalue < 0.05] <- "Up"
data$Significant[data$lfc < -0.7 & data$pvalue < 0.05] <- "Down"

ggplot(data, aes(x = lfc, y = logP, color = Significant)) +
  geom_point(alpha = 0.7, size = 1.2) +
  scale_color_manual(values = c("#6DAEDB", "grey", "#EE7647")) +
  geom_vline(xintercept = c(-0.7, 0.7), linetype = "dashed", color = "black") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black") +
  labs(x = "logFC", y = "-log10(p-value)") +
  theme_minimal() +
  theme(
    legend.position = "bottom",  # 将图例放在最下方
    legend.direction = "horizontal",  # 图例水平排列
    legend.title = element_blank(),  # 可选：移除图例标题
    aspect.ratio = 1
  ) +
  guides(color = guide_legend(override.aes = list(size = 4)))  # 可选：调整图例点的大小