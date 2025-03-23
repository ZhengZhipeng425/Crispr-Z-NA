# 合并两个 data.frame

df1 <- High_positive_mirfree
df2 <- High_negative_mirfree


combined <- df1 %>%
  rename(pvalue1 = `pos|p-value`) %>%
  left_join(df2 %>% rename(pvalue2 = `neg|p-value`), by = c("id")) %>%
  mutate(pvalue = pmin(pvalue1, pvalue2)) %>%
  select(id, `neg|lfc`, pvalue)

# -------------------------------------------------------------------------



