# This script is just used to add gene ID to csv file

import pandas as pd
from Bio import Entrez
from pathlib import Path

# 设置 Entrez 的电子邮件（NCBI API 要求提供）
Entrez.email = "zhengzhipeng25@163.com"


# 根据基因名称获取Gene ID
def get_gene_id(gene_name):
    # 这里必须添加后面的gene以及物种标识，才能查找到正确的gene_id
    gene_name = gene_name + "[Gene] AND Homo sapiens[Organism]"
    handle = Entrez.esearch(db="gene", term=gene_name, retmax=1)
    record = Entrez.read(handle)
    gene_id = record["IdList"]
    if gene_id:
        return gene_id[0]
    else:
        return None


file_path = Path("/Users/zhengzhipeng/Documents/GitHub/Z-NA-Crispr-Screening/Crispr Sequencing "
                 "data/AnalysisScripts/GO_enrich/LP_lfc_p_flitered.csv")
file_name = file_path.name
file_stem = file_path.stem  # Use stem to exclude extension
file_extension = file_path.suffix  # To get extension
output_file_name = file_stem + "_id_annotation" + file_extension

df = pd.read_csv(file_name)
df['id'] = None

# Use iteration to obtain genes' id
for index, row in df.iterrows():
    name = row['gene']
    gene_id = get_gene_id(name)
    print(gene_id)
    df.at[index, 'id'] = gene_id

df.to_csv(output_file_name, index=False)
