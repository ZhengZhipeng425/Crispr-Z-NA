# 这个script用于处理high 10%除以 low 10%的结果

import pandas as pd
import numpy as np

High = pd.read_csv('High_vs_lnput.positive.csv')
Low = pd.read_csv('Low_vs_lnput.positive.csv')

df_merged = pd.merge(High, Low, on='id', how='inner')

df_merged['LFC'] = df_merged['pos|lfc_x']/df_merged['pos|lfc_y']

df_sorted = df_merged.sort_values(by='LFC', ascending=False)

df_sorted['logFC'] = np.log10(df_sorted['LFC'])

result = df_sorted[['id', 'LFC', 'logFC', 'pos|rank_x', 'pos|rank_y', 'pos|score_x', 'pos|score_y']]

result.to_csv('HP_to_LP.csv', index=False)