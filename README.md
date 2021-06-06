This is an about the project

The data set is available in kaggle and  all the codes in the src folder
Here we will give a detailed expiation about each of the codes and try to make it as informative as possible

## Library loader
here we will find all the libraries to load



## Cleaning-data
Our main objective in this process is to get a complete dataset with anual dataset

This file is going to be used to clean the data ie extract only the columns we are going to need
So initially we extract the following columns only viz "Date","State","so2","no2","spm","rspm","type"

### Deal with missing values
There are two ways that we can deal with the missing values 
one is to omit  all the missing values as whole 
```{r}
library(dplyr)
data_drop <- new_data %>% 
  na.omit()
dim(data_drop)

```

The problem with this is that it we will get only 500 or so observation
as a result we have to find another way

#### for numeric values
numeric values we can replace with the mean of the values for each state

We use the aggregate function to calculate the mean for each state
```{r}
avg_so = aggregate(so2 ~ State, data = new_data, 
                   FUN = function(x) c (mean = mean(x))) # mean of so2
```

we repeat this for no2, spm and rspm

next we need to incorporate these into our final data set

```{r}
final <- merge(new_data, avg_spm, by = "State", all = T)
```
The wrapr library provides the merge method that will generate two columns: spm.x(which is the current value of the row) and spm.y(which is the value(mean))

```{r}
final$spm <- final$spm.x %?% final$spm.y
```
the %?% operator will compare both the columns and if the value is missing it will replace it with the mean

```{r}
final = subset(final, select = -c(spm.x, spm.y))
```
finally we can subset the spm.x and y 


#### Cleaning the date

```{r}
final$Date <- dmy(final$Date)
```

The lubridate provides an useful function dmy() which will change valid dates to the y-m-d format
and the ones that cannot be converted will be replaced with NA


#### Further NA values
Now all the NA values that will be remaing will be ones where the places, type, incorrect dates and those places that do not have any data for whic we can obtain a replaceble value
we have no other option than to remove all these values and store the dataset in Final variable
```{r}
Final <- final %>%
  na.omit()
```

### Converting to yearly data

The last step in our process is to convert the data into an annual data so we are going to just that
```{r}
final$year <- floor_date(final$Date, "year")     # convert dates to yearly 
final <- final %>%
  group_by(year,State,type) %>%                   # Reformat the table
  summarize_all(mean)

```
we introduce a new column year where we say the annual dates for each field
we use the group_by() function to group the data by our three main columns ie year, state and type and we summarize the rest of the data with mean

```{r}
final$year <- year(final$year)
final <- subset(final, select = -c(Date))
```
Finally we extract only the year path and reformat the table


#### Extra decimal places
```{r}
final <- final %>%
  mutate(across(where(is.numeric), round, 3))
```
Using the mutate function we can just search the dataframe for values which are numeric and round them down to 3 decimal places


We save the data into a new csv file called cleaned-data.csv
