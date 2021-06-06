# this is used to clean the imported data

# Extracting only the needed data
new_data <- data.frame(data$date,data$state,data$so2,data$no2,data$spm,
                       data$rspm,data$type)

colnames(new_data) <- c("Date","State","so2","no2","spm","rspm","type")

# getting the list of column names with missing observations
list_na <- colnames(new_data)[ apply(new_data,2,anyNA)]
list_na <- list_na[!list_na %in% c("Date","type")] # Removing the date cause we will deal with it later



# Dropping all the NA values and getting "pure" data
# loading the library and excluding the missing observation

data_drop <- new_data %>% 
  na.omit()
dim(data_drop)


# Replacing the with mean

# Getting the mean of each data state-wise
avg_so = aggregate(so2 ~ State, data = new_data, 
                   FUN = function(x) c (mean = mean(x))) # mean of so2
avg_no = aggregate(no2 ~ State, data = new_data, 
                   FUN = function(x) c (mean = mean(x))) # mean of no2
avg_spm = aggregate(spm ~ State, data = new_data, 
                    FUN = function(x) c (mean = mean(x))) # mean of spm
avg_rspm = aggregate(rspm ~ State, data = new_data, 
                     FUN = function(x) c (mean = mean(x))) # mean of rspm

# Merging the tables

# Filling the missing values for spm
final <- merge(new_data, avg_spm, by = "State", all = T)
final$spm <- final$spm.x %?% final$spm.y # merging the x and y values
final = subset(final, select = -c(spm.x, spm.y)) # Removing the uneeded columns

# Filling the missing values for rspm
final <- merge(final, avg_rspm, by = "State", all = T)
final$rspm <- final$rspm.x %?% final$rspm.y
final <- subset(final, select = -c(rspm.x, rspm.y))

# Filling the values for no2
final <- merge(final, avg_no, by = "State", all = T)
final$no2 = final$no2.x %?% final$no2.y
final <- subset(final, select = -c(no2.x, no2.y))

# Filling the values for so2
final <- merge(final, avg_so, by = "State", all = T)
final$so2 <- final$so2.x %?% final$so2.y
final <- subset(final, select = -c(so2.x, so2.y))



# Dealing with dates
final$Date <- dmy(final$Date)


# Removing the remaining NA values cause we cannot do anything about them

final <- final %>%
  na.omit()



# Converting data to anual data

final$year <- floor_date(final$Date,"year")    # convert dates to yearly 
final <- final %>%
  group_by(year,State,type) %>%                   # Reformat the table
  summarize_all(mean)

final$year <- year(final$year)


final <- subset(final, select = -c(Date))


# Rounding off all the extra decimal places in all numeric columns
final <- final %>%
  mutate(across(where(is.numeric), round, 3))


# Saving the cleaned file 
path = 'E:\\Projects\\Air Quality\\Data'
fileName = paste(path,'cleaned-data.csv',sep ='')
write.csv(final,fileName)


# Getting the averages and merging them into one table based on state

avg_tab <- aggregate(so2~State,data = data, FUN = mean)

avg_tab <- aggregate(no2~State, data = data, FUN = mean) %>%
  merge(avg_tab, by ="State", all = T)

avg_tab <- aggregate(spm~State, data = data, FUN = mean) %>%
  merge(avg_tab, by = "State",all = T)

avg_tab <- aggregate(rspm~State, data = data, FUN = mean) %>%
  merge(avg_tab, by = "State", all = T)

# Saving the data
filename = paste(path,'Table-of-Averages.csv',sep='')
write.csv(avg_tab,filename)