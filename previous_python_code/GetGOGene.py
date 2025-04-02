import pandas as pd
import os

# 读取 GO 分析结果文件
go_df = pd.read_csv('/Users/zhengzhipeng/Downloads/Crispr Sequencing '
                    'data/06.enrich/Low_vs_lnput/GO/Low_vs_lnput.GO_categories.csv')

# 指定处理的行数，假设我们要处理前 5 行
n_rows = 10
go_df = go_df.head(n_rows)  # 只保留前 n 行数据

# 创建一个空的 DataFrame 用来存放结果
result_df = pd.DataFrame(columns=['Pathway', 'Type', 'Gene Name', 'Gene ID', 'Annotation'])

# 生成一个对应的file查找map
file_map = {
    'biological_process': '/Users/zhengzhipeng/Downloads/Crispr Sequencing '
                          'data/06.enrich/Low_vs_lnput/GO/Low_vs_lnput.GO_bp.csv',
    'cellular_component': '/Users/zhengzhipeng/Downloads/Crispr Sequencing '
                          'data/06.enrich/Low_vs_lnput/GO/Low_vs_lnput.GO_cc.csv',
    'molecular_function': '/Users/zhengzhipeng/Downloads/Crispr Sequencing '
                          'data/06.enrich/Low_vs_lnput/GO/Low_vs_lnput.GO_mf.csv',
    # 根据需要继续添加其他 type 对应的文件
}


# 遍历前 n 行，按 type 和 pathway 进行处理
for index, row in go_df.iterrows():
    pathway = row['Pathway_categories']
    go_type = row['Type']

    # 根据 'type' 信息，定位对应的 CSV 文件（假设文件名是 type.csv）

    # 根据 go_type 来查找文件名
    file_name = file_map.get(go_type, None)

    # 检查文件是否存在
    if os.path.exists(file_name):
        # 读取对应的 CSV 文件
        type_df = pd.read_csv(file_name)

        # 在该文件中找到匹配的 pathway 信息
        matched_rows = type_df[type_df['Description'] == pathway]

        # 如果匹配到路径，则提取基因信息
        if not matched_rows.empty:
            for _, matched_row in matched_rows.iterrows():
                gene_names = matched_row['geneName'].split('/')  # 假设基因列是逗号分隔的基因名
                gene_ids = matched_row['geneID'].split('/')
                # 将每个基因名都加入到结果 DataFrame 中
                for gene_name, gene_id in zip(gene_names, gene_ids):
                    new_row = {
                        'Pathway': pathway,
                        'Type': go_type,
                        'Gene Name': gene_name,
                        'Gene ID': gene_id,
                        'Annotation': ''  # 留出注释栏位
                    }
                    new_row_df = pd.DataFrame([new_row])
                    result_df = pd.concat([result_df, new_row_df], ignore_index=True)
    else:
        print(f"警告: 找不到文件 {file_name}，跳过该行。")

# 最终结果 DataFrame
# print(result_df)

# 保存为新的 CSV 文件
result_df.to_csv('LowGO.csv', index=False)
