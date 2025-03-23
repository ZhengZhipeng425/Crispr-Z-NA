data <- combined

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
  theme_minimal()