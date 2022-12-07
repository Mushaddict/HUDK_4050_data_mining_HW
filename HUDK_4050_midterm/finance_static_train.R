########################Data cleaning for finance_train testing and static_train testing
library(tidyverse)
finance_train <- read.csv("output data/financial_train.csv")
static_train <- read.csv("output data/static_train.csv")

finance_train[finance_train==""] <- NA

#2012:2017 Loan:Grant: N/A turn into zero，奖学金为0
finance_train[, 11:34][is.na(finance_train[, 11:34])] <- 0
colnames(finance_train)
#note没有提到的部分：前面几个string column的里面的NA，我clean成了Unknown
#因为parents education level那两列里面确实有Unknown。
finance_train$Marital.Status<-finance_train$Marital.Status %>% replace_na("Unknown")
finance_train$Father.s.Highest.Grade.Level<-finance_train$Father.s.Highest.Grade.Level %>% replace_na('Unknown')
finance_train$Mother.s.Highest.Grade.Level<-finance_train$Mother.s.Highest.Grade.Level %>% replace_na('Unknown')
finance_train$Housing<-finance_train$Housing %>% replace_na('Unknown')


#note没有提到的部分：前面几个column的income的NA，我clean成了0，但是不太确定对不对
finance_train[,c("Adjusted.Gross.Income","Parent.Adjusted.Gross.Income")][is.na(finance_train[,c("Adjusted.Gross.Income","Parent.Adjusted.Gross.Income")])] <- 0

#static_train:
colnames(static_train)
static_train<-subset(static_train,select = -c(Zip,Campus,Address1,Address2,City,HSGPAWtd,FirstGen,DualHSSummerEnroll))

#Delete all the rows with missing State
static_train$State[is.na(static_train$State)] <- 0
static_train <-static_train[!(static_train$State=="0"),]
static_train

write.csv(finance_train,file="output data/finance_train_clean.csv",row.names = FALSE)
write.csv(static_train,file="output data/static_train_clean.csv",row.names = FALSE)

# write.csv(finance_train,"/Users/xinchangliu/Dropbox/Mac/Desktop/financial_c_test.csv", row.names = FALSE)
# write.csv(static_train,"/Users/xinchangliu/Dropbox/Mac/Desktop/static_train_c_test.csv", row.names = FALSE)
# nrow(static_train)
# n_distinct(static_train)
# nrow(finance_train)
# n_distinct(finance_train)