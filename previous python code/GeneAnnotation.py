import pandas as pd
from Bio import Entrez
import time

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

def fetch_gene_description(gene_id):
    """通过 NCBI Entrez API 获取基因功能描述"""
    try:
        # 使用 Entrez.efetch 获取基因信息
        handle = Entrez.efetch(db="gene", id=gene_id, rettype="xml", retmode="xml")
        records = Entrez.read(handle)
        handle.close()

        # 检查是否有数据
        if not records:
            return "No description found"

        # 尝试从 GeneRef 或 GeneCommentary 中提取描述
        gene_desc = "No description available"

        for record in records:
            if 'Entrezgene_summary' in record:
                gene_desc = record['Entrezgene_summary']
                break

        return gene_desc

    except Exception as e:
        print(f"Error fetching gene {gene_id}: {e}")
        return 'Error fetching description'


def add_gene_description_to_csv(input_file, output_file):
    """将基因描述添加到 CSV 文件中"""
    # 读取 CSV 文件
    df = pd.read_csv(input_file)

    """先筛选出lfc绝对值大鱼0.7的行"""
    df = df[(df['pos|lfc'] > 0.7) | (df['pos|lfc'] < -0.7)]
    # 假设基因 ID 在 'id' 列
    descriptions = []
    for index, row in df.iterrows():
        gene_name = row['id']
        gene_id = get_gene_id(gene_name)
        print(f"Fetching description for gene name: {gene_name}")

        # 获取基因描述
        description = fetch_gene_description(gene_id)
        print(description)
        descriptions.append(description)

        # 每次请求之间停顿，避免被封禁
        time.sleep(0.7)

    # 将描述添加到新的列
    df['Annotation'] = descriptions

    # 保存更新后的文件
    df.to_csv(output_file, index=False)
    print(f"Updated CSV file saved as {output_file}")


# 使用示例
add_gene_description_to_csv("Low_vs_lnput.positive.csv", "LP_Annotation.csv")
