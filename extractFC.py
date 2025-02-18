# 提取GO结果和正负向筛选结果中的重合gene

import pandas as pd

HighPos = pd.read_csv('Low_vs_lnput.negative.csv')
HighGO = pd.read_csv('LowGO_Annotation.csv')

df_merged = pd.merge(HighPos, HighGO, left_on = 'id', right_on = 'Gene Name', how = 'inner')

df_selected = df_merged[['Gene Name', 'Gene ID', 'Pathway', 'Type', 'neg|score', 'neg|rank', 'neg|lfc', 'Annotation']]

df_selected.to_csv('GO_LowNeg.csv', index=False)