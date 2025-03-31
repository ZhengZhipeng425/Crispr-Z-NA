# 使用前指定文件名，结果名，ggplot里用的aes轴名称，还有图注里的title名，主要修改点为High与Low，positive与nagative

data <- High_vs_lnput_negative

reverselog_trans <- function(base = exp(1)) {
  trans <- function(x) -log(x, base)
  inv <- function(x) base^(-x)
  trans_new(paste0("reverselog-", format(base)), trans, inv, 
            log_breaks(base = base), 
            domain = c(1e-100, Inf))
}

rainbow_palette <- rev(c(
  "#EE0000",  # Red
  "#FF7F00",  # Orange
  "#FFEE66",  # Yellow
  "#66DD66",  # Green
  "#77CCFF",  # Cyan
  "#0000FF"  # Blue
))

p <- ggplot(data, aes(x = `neg|lfc`, y = `neg|p-value`) )+
  geom_point(alpha = 1, aes(color = `neg|p-value`), size = 2) +
  scale_y_continuous(trans = reverselog_trans(10), 
                     limits = c(1, 1e-7),
                     breaks = c(1e-1, 1e-2, 1e-3, 1e-4, 1e-5, 1e-6, 1e-7),
                     labels = trans_format("log10", math_format(10^.x))
                     ) +
  labs(x = "log2 fold change", y = "P-value", title = "High_vs_Input_negative") +
  scale_color_gradientn(
    colors = c("#800080", rainbow_palette),  # 紫色 + 彩虹色
    values = scales::rescale(c(0, 0.05, 0.1, 0.3, 0.5, 0.7, 1)),  # 调整颜色分布
    limits = c(0, 1),  # 确保 p < 0.05 映射到紫色
    breaks = c(0, 0.05, 0.1, 0.3, 0.5, 0.7, 1),
    labels = c("0 (p < 0.05)", "0.05", "0.1", "0.3", "0.5", "0.7", "1"),
    guide = guide_colorbar(title = "P-value")
  ) +
  theme(legend.position = "none")

# 保存图片
ggsave(
  filename = "High_vs_Input_negative.png",  # 文件名（支持.png, .pdf, .jpeg等）
  plot = p,                      # 要保存的图形对象
  width = 8,                     # 宽度（英寸）
  height = 6,                    # 高度（英寸）
  dpi = 600                      # 分辨率（默认300，适合出版质量）
)