#Getting the averages and merging them into one table
avg_tab <- aggregate(so2~State,data = data, FUN = mean)

avg_tab <- aggregate(spm~State, data = data, FUN = mean) %>%
  merge(avg_tab, by = "State", all = T)

avg_tab <- aggregate(no2~State, data = data, FUN = mean) %>%
  merge(avg_tab, by ="State", all = T)
avg_tab <- aggregate(so2~State, data = data, FUN = mean) %>%
  merge(avg_tab, by = "State",all = T)