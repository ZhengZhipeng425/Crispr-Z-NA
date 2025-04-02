# Select two dataframes you want to merge

df1 <- Low_positive_mirfree
df2 <- Low_negative_mirfree

# Combine operation, define the variable name such as`pos|p-value`
combined <- df1 %>%
  rename(pvalue1 = `pos|p-value`) %>%
  left_join(df2 %>% rename(pvalue2 = `neg|p-value`), by = c("id")) %>%
  mutate(pvalue = pmin(pvalue1, pvalue2)) %>%
  select(id, `neg|lfc`, pvalue)

# -------------------------------------------------------------------------

combined <- combined %>%
  rename(lfc = `neg|lfc`)

write.csv(combined, "Low_p_merged.csv", row.names = FALSE)
