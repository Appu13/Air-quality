# Getting the state with most average so2
state <- avg_so %>% top_n(1)

state_data <- data[data$State == state$State,]
state_data <- state_data[state_data$type == 'Industrial Area',]
state_data <- subset(state_data, select = c(year,so2))
model = lm(state_data$so2 ~ state_data$year)
s = list(2018,2020,2021)

t = predict(model,s)
