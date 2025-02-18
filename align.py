import pandas as pd

highPos = pd.read_csv('/Users/zhengzhipeng/Downloads/Crispr Sequencing data/AnalysisScripts/High_vs_lnput.positive.csv', nrows=200)
lowNeg = pd.read_csv('/Users/zhengzhipeng/Downloads/Crispr Sequencing data/AnalysisScripts/Low_vs_lnput.negative.csv', nrows=200)
highNeg = pd.read_csv('High_vs_lnput.negative.csv', nrows=200)
lowPos = pd.read_csv('Low_vs_lnput.positive.csv', nrows=200)
# common_rows = pd.merge(highPos, lowNeg, how='inner', on='id')
# common_rows.to_csv('resultOfHPLN.csv', index=False)
common_rows = pd.merge(highPos, lowPos, how='inner', on='id')
common_rows.to_csv('resultOfHPLP.csv', index=False)