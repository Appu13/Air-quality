# Do some basic visualization 

# Top data
slice_max(data, n = 5, so2) %>%
  ggplot(., aes(x= State, y = so2, fill = State)) +
  geom_bar(stat = 'identity') 

top_n(data, n=5, no2) %>%
  ggplot(., aes(x= State, y = no2, fill = State)) +
  geom_bar(stat = 'identity') 

top_n(data, n=5, spm) %>%
  ggplot(., aes(x= State, y = spm, fill = State)) +
  geom_bar(stat = 'identity') 

top_n(data, n=5, rspm) %>%
  ggplot(., aes(x= State, y = rspm, fill = State)) +
  geom_bar(stat = 'identity') 


# Bottom data
slice_min(data, n = 5, so2) %>%
  ggplot(., aes(x = State, y = so2, fill = State)) +
  geom_bar(stat = 'identity')

slice_min(data, n = 5, no2) %>%
  ggplot(., aes(x = State, y = no2, fill = State)) +
  geom_bar(stat = 'identity')

slice_min(data, n = 5, spm) %>%
  ggplot(., aes(x = State, y = spm, fill = State)) +
  geom_bar(stat = 'identity')

slice_min(data, n = 5, rspm) %>%
  ggplot(., aes(x = State, y = rspm, fill = State)) +
  geom_bar(stat = 'identity')