import gprofiler

# 目标基因列表
gene_list = ["TP53", "EGFR", "BRCA1", "MTOR"]

# 运行 GO 富集分析
gp = gprofiler.GProfiler(return_dataframe=True)
result = gp.profile(organism="hsapiens", query=gene_list)

# 仅提取 GO 注释相关信息
go_terms = result[result["source"] == "GO:BP"]  # 仅提取 Biological Process
print(go_terms[["name", "p_value", "query"]])  # 显示 GO 术语、p 值、涉及的基因
