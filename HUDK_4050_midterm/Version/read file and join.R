library(tidyverse)
library(dplyr) 


############read file
## 地址我改了，folder_address我改成了相对路径
folder_address<-"Student Retention Challenge Data/"
df_label<-read.csv("DropoutTrainLabels.csv")
df_test<-read.csv(paste0(folder_address,"Test Data/TestIDs.csv"))

library(readxl)
df_financial <- read_xlsx(paste0(folder_address,"Student Financial Aid Data/2011-2017_Cohorts_Financial_Aid_and_Fafsa_Data.xlsx"))
###### change colname and prepare for joining
names(df_financial)[1]="StudentID"
df_financial$StudentID <- as.numeric(df_financial$StudentID)
# df_financial$`ID with leading` <- substring(df_financial$`ID with leading`,2,7)
# df_financial$`ID with leading` <- strtoi(df_financial$`ID with leading`)
# df_financial
######read financil file
#df_financial<-read.csv(paste0(folder_address,"Student Financial Aid Data/2011-2017_Cohorts_Financial_Aid_and_Fafsa_Data.csv"))

######read static file
static_data <- lapply(Sys.glob(paste0(folder_address,"Student Static Data/*.csv")), read.csv)
#merge static data
df_static<-static_data%>%bind_rows
## 原来是-2:-3
# df_static<-select(df_static,-2:-3)
df_static <- df_static %>% select(-c(Cohort, CohortTerm))

######read progress file
### Delete static variables & Mark semester and year for variables.
read_sp_file<-function(year,term,filename){
  ## 改为相对路径
  address<-paste("Student Retention Challenge Data/Student Progress Data/",filename,sep="")
  term_year_SP<-read.csv(address)
  term_year_SP<-select(term_year_SP,-2:-5)
  for (i in 2:13){
    names(term_year_SP)[i]=paste(colnames(term_year_SP)[i],term,year,sep = "_")
  }
  return(term_year_SP)
}
###  read fall
for (i in 2011:2016){
  assign(paste("Fall_",i,"_SP",sep=""),read_sp_file(year=i,term="Fall",filename=paste0("Fall ",i,"_SP.csv")))
  
}
### read spring & summer
for (i in 2012:2017){
  assign(paste("Spring_",i,"_SP",sep=""),read_sp_file(year=i,term="Spring",filename=paste0("Spring ",i,"_SP.csv")))
  assign(paste("Sum_",i,"_SP",sep=""),read_sp_file(year=i,term="sum",filename=paste0("Sum ",i,".csv")))
}


##############################################################################
##################### merge training set  ####################################
##############################################################################
df_train<-merge(x=df_label,y=df_financial,by="StudentID",all.x=TRUE)
df_train<-merge(x=df_train,y=df_static,by="StudentID",all.x=TRUE)
##以时间顺序merge
## 先merge2011 fall
df_train <- merge(x = df_train, y = Fall_2011_SP, by = "StudentID", all.x = TRUE)
## 接着merge2012的spring summer fall
for(i in 2012:2016) {
  df_train <- merge(x = df_train, y = get(paste0("Spring_", i, "_SP")), by = "StudentID", all.x = TRUE)
  df_train <- merge(x = df_train, y = get(paste0("Sum_", i, "_SP")), by = "StudentID", all.x = TRUE)
  df_train <- merge(x = df_train, y = get(paste0("Fall_", i, "_SP")), by = "StudentID", all.x = TRUE)
}
## 最后merge2017的Spring和Summer
df_train <- merge(x = df_train, y = Spring_2017_SP, by = "StudentID", all.x = TRUE)
df_train <- merge(x = df_train, y = Sum_2017_SP, by = "StudentID", all.x = TRUE)
## 原来的merge部分我给删了

##############################################################################
##################### merge test set #########################################
##############################################################################
df_test<-merge(x=df_test,y=df_financial,by="StudentID",all.x=TRUE)
df_test<-merge(x=df_test,y=df_static,by="StudentID",all.x=TRUE)
## 先merge2011 fall
df_test <- merge(x = df_test, y = Fall_2011_SP, by = "StudentID", all.x = TRUE)
## 接着merge2012的spring summer fall
for(i in 2012:2016) {
  df_test <- merge(x = df_test, y = get(paste0("Spring_", i, "_SP")), by = "StudentID", all.x = TRUE)
  df_test <- merge(x = df_test, y = get(paste0("Sum_", i, "_SP")), by = "StudentID", all.x = TRUE)
  df_test <- merge(x = df_test, y = get(paste0("Fall_", i, "_SP")), by = "StudentID", all.x = TRUE)
}
## 最后merge2017的Spring和Summer
df_test <- merge(x = df_test, y = Spring_2017_SP, by = "StudentID", all.x = TRUE)
df_test <- merge(x = df_test, y = Sum_2017_SP, by = "StudentID", all.x = TRUE)
colnames(df_test)

###### output file
finance_train<-df_train[,1:34]
progress_train<-df_train[,-(5:66)]
static_train<-df_train[,c(1:4,35:66)]
progress_train




finance_test<-df_test[,1:33]
colnames(finance_test)
progress_test<-df_test[,-(4:65)]
colnames(progress_test)
static_test<-df_test[,c(1:3,34:65)]
colnames(static_test)

colnames(df_test)
## 都改成了相对路径
write.csv(progress_test,file="progress_test.csv")
write.csv(finance_test,file="financial_test.csv")
write.csv(static_test,file="static_test.csv")

write.csv(progress_train,file="progress_train.csv")
write.csv(finance_train,file="financial_train.csv")
write.csv(static_train,file="static_train.csv")
