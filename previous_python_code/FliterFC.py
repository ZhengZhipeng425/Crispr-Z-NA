import numpy as np
import pandas as pd

# 这个脚本用于处理归一化处理后的reads数，并且排序生成新的logFC文件
df = pd.read_csv('FC.csv')

df['FC_H1'] = df['High-1'] / df['lnput-1']
df['FC_H2'] = df['High-2'] / df['lnput-2']
df['FC_L1'] = df['Low-1'] / df['lnput-1']
df['FC_L2'] = df['Low-2'] / df['lnput-2']

df['logFCH1'] = np.log2(df['FC_H1'])
df['logFCH2'] = np.log2(df['FC_H2'])
df['logFCL1'] = np.log2(df['FC_L1'])
df['logFCL2'] = np.log2(df['FC_L2'])


def sort_and_export(logFC_column, inputfile, outputfile):
    columns_to_keep = ['gRNA', 'Gene', logFC_column]
    inputfile[logFC_column] = inputfile[logFC_column].apply(lambda x: np.nan if np.isinf(x) else x)
    df_sorted = inputfile.dropna(subset=logFC_column)
    df_sorted = df_sorted.sort_values(by=logFC_column, ascending=False)
    final = df_sorted[columns_to_keep]
    final.to_csv(outputfile, index=False)
    return outputfile


sort_and_export('logFCH1', df, outputfile='logFCH1.csv')
