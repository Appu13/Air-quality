
Data <- read.csv('E:\\Projects\\Air Quality\\Data\\cleaned-data.csv',header = T)
dat<-Data




# Combining rspm and spm to a single quantity quantity
dat$totalspm <- round(rowMeans(subset(dat,select = c('spm','rspm'))),3)
dat<- dat[,!(names(dat)%in% c('spm','rspm'))]
dat<-dat %>% relocate(so2,.after = type)

# Getting the total weighted score
weight =c(16.13,22.11,1)
Score <-sweep(subset(dat,select = c('totalspm','no2','so2')),2,weight,"*")
Score$totalScore <- rowSums(Score)

# Normalization
normalize <- function(x) {
  return (round((x - min(x)) / (max(x) - min(x)),3))
}

Score$normalScore <- normalize(Score$totalScore)
# Filled Density Plot
d <- density(Score$totalScore)
plot(d, main="Density of Normalized Score")
polygon(d, col="blue", border="red")


Data$Score <- Score$normalScore
Data<- Data[,!(names(dat)%in% c('X'))]
write.csv(Data,file = 'E:\\Projects\\Air Quality\\Data\\score-data(time-series).csv')