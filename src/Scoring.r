# covert everything to range 1-10
summary(data)

relative.data <- data.frame(data)
cols = c("no2","so2","spm","rspm")

  for (name in cols){
    relative.data[name] <- rescale(data[,name], to = c(1,10))
  }
  


