library(tidyverse)

############ read file
df_label<-read.csv("Student Retention Challenge Data/DropoutTrainLabels.csv")
df_test<-read.csv("Student Retention Challenge Data/Test Data/TestIDs.csv")

finance_test_clean<-read.csv("output data/finance_test_clean.csv")
finance_test_clean$StudentID <- as.numeric(finance_test_clean$StudentID)

static_test_clean<-read.csv("output data/static_test_clean.csv")
static_test_clean <- static_test_clean %>% select(-c(cohort, cohort.term))
progress_test_clean<-read.csv("output data/progress_test_clean.csv")
progress_test_clean <- progress_test_clean %>% select(-c(cohort, cohort.term))

finance_train_clean<-read.csv("output data/finance_train_clean.csv")
finance_train_clean$StudentID <- as.numeric(finance_train_clean$StudentID)
finance_train_clean <- finance_train_clean %>% select(-c(Dropout))

static_train_clean<-read.csv("output data/static_train_clean.csv")
static_train_clean <- static_train_clean %>% select(-c(Dropout,cohort, cohort.term))
progress_train_clean<-read.csv("output data/progress_train_clean.csv")
progress_train_clean <- progress_train_clean %>% select(-c(Dropout, cohort, cohort.term))


###### merge test set
df_test_clean<-merge(x=df_test,y=finance_test_clean,by="StudentID",all.x=TRUE)
df_test_clean<-merge(x=df_test_clean,y=static_test_clean,by="StudentID",all.x=TRUE)
df_test_clean<-merge(x=df_test_clean,y=progress_test_clean,by="StudentID",all.x=TRUE)

df_train_clean<-merge(x=df_label,y=finance_train_clean,by="StudentID",all.x=TRUE)
df_train_clean<-merge(x=df_train_clean,y=static_train_clean,by="StudentID",all.x=TRUE)
df_train_clean<-merge(x=df_train_clean,y=progress_train_clean,by="StudentID",all.x=TRUE)


write.csv(df_test_clean,file="output data/df_test_clean.csv",row.names = FALSE)
write.csv(df_train_clean,file="output data/df_train_clean.csv",row.names = FALSE)
