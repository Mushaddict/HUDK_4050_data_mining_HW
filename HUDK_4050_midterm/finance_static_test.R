########################Data cleaning for finance testing and static testing
library(tidyverse)
finance <- read.csv("output data/financial_test.csv")
static <- read.csv("output data/static_test.csv")

finance[finance==""] <- NA

#2012:2017 Loan:Grant: N/A turn into zero，奖学金为0
finance[, 10:33][is.na(finance[, 10:33])] <- 0
colnames(finance)
#note没有提到的部分：前面几个string column的里面的NA，我clean成了Unknown
#因为parents education level那两列里面确实有Unknown。
finance$Marital.Status<-finance$Marital.Status %>% replace_na("Unknown")
finance$Father.s.Highest.Grade.Level<-finance$Father.s.Highest.Grade.Level %>% replace_na('Unknown')
finance$Mother.s.Highest.Grade.Level<-finance$Mother.s.Highest.Grade.Level %>% replace_na('Unknown')
finance$Housing<-finance$Housing %>% replace_na('Unknown')


#note没有提到的部分：前面几个column的income的NA，我clean成了0，但是不太确定对不对
finance[,c("Adjusted.Gross.Income","Parent.Adjusted.Gross.Income")][is.na(finance[,c("Adjusted.Gross.Income","Parent.Adjusted.Gross.Income")])] <- 0

#Static:
colnames(static)
static<-subset(static,select = -c(Zip,Campus,Address1,Address2,City,HSGPAWtd,FirstGen,DualHSSummerEnroll))

#Delete all the rows with missing State
static$State[is.na(static$State)] <- 0
static <-static[!(static$State=="0"),]
static

write.csv(finance,file="output data/finance_test_clean.csv",row.names = FALSE)
write.csv(static,file="output data/static_test_clean.csv",row.names = FALSE)
# write.csv(finance,"/Users/xinchangliu/Dropbox/Mac/Desktop/financial_c_test.csv", row.names = FALSE)
# write.csv(static,"/Users/xinchangliu/Dropbox/Mac/Desktop/static_c_test.csv", row.names = FALSE)
# nrow(static)
# n_distinct(static)
# nrow(finance)
# n_distinct(finance)