library(tidyverse)
library(dplyr) 
library(ggplot2)


###cleaning
progress_test<-read.csv("output data/progress_test.csv")
financial_test<-read.csv("output data/financial_test.csv")
static_test<-read.csv("output data/static_test.csv")

progress_test_clean<-progress_test

######从cohort到最后为NA的直接删除（无全是na的）:检查是否有整行空值
for (i in 0:nrow(progress_test)){
  if (sum(is.na(progress_test[i,]))>218){
    print(i)
  }
}

###### 检查是否有cohort空值
sum(is.na(progress_test_clean[,"cohort"]))

###################################################### plot   ###############################################
progress_test_plot<-progress_test_clean

################################        Complete_Dev_Math & Complete_Dev_English  ###############################################

######Complete_Dev_Math & Complete_Dev_English (0是需要上没上，1需要上上完了，-1: Missing （信息确实）, -2: Doesn't Apply)：单独再列两个variables：有1就是上过，没有1就变成0

progress_test_clean$complete_DevMath=0
progress_test_clean$complete_DevEnglish=0
col_DevMath<-grep("CompleteDevMath", colnames(progress_test_clean))
col_DevEnglish<-grep("CompleteDevEnglish", colnames(progress_test_clean))

progress_test_clean[,col_DevMath][is.na(progress_test_clean[,col_DevMath])] <- "-1"
progress_test_clean[,col_DevEnglish][is.na(progress_test_clean[,col_DevEnglish])] <- "-1"

for (i in 1:nrow(progress_test_clean)){
  for (j in col_DevMath){
    if(progress_test_clean[i,j]==1){
      progress_test_clean[i,"complete_DevMath"]=1
    }
  }
  for (k in col_DevEnglish){
    if(progress_test_clean[i,k]==1){
      progress_test_clean[i,"complete_DevEnglish"]=1
    }
  }
}


################################        major       ###############################################

###### Complete1 & complete2 把NA变成0, CompleteCIP1 把NA变成-2
col_complete12<-grep("Complete1|Complete2", colnames(progress_test_clean))
col_completeCIP<-grep("CompleteCIP", colnames(progress_test_clean))
progress_test_clean[,col_complete12][is.na(progress_test_clean[,col_complete12])] <- "0"
progress_test_clean[,col_completeCIP][is.na(progress_test_clean[,col_completeCIP])] <- "-2"

###### final major
progress_test_clean$final_Complete1<-0
col_complete1<-grep("Complete1", colnames(progress_test_clean))

for (i in 1:nrow(progress_test_clean)){
  for (j in col_complete1){
    if(progress_test_clean[i,j]>0){
      progress_test_clean[i,"final_Complete1"]=progress_test_clean[i,j]
    }
  }
}

progress_test_clean$final_Complete2<-0
col_complete2<-grep("Complete2", colnames(progress_test_clean))

for (i in 1:nrow(progress_test_clean)){
  for (j in col_complete2){
    if(progress_test_clean[i,j]>0){
      progress_test_clean[i,"final_Complete2"]=progress_test_clean[i,j]
    }
  }
}

progress_test_clean$final_CompleteCIP1<-0
col_completeCIP1<-grep("CompleteCIP1", colnames(progress_test_clean))

for (i in 1:nrow(progress_test_clean)){
  for (j in col_completeCIP1){
    if(progress_test_clean[i,j]>0){
      progress_test_clean[i,"final_CompleteCIP1"]=progress_test_clean[i,j]
    }
  }
}

progress_test_clean$final_CompleteCIP2<-0
col_completeCIP2<-grep("CompleteCIP2", colnames(progress_test_clean))

for (i in 1:nrow(progress_test_clean)){
  for (j in col_completeCIP2){
    if(progress_test_clean[i,j]>0){
      progress_test_clean[i,"final_CompleteCIP2"]=progress_test_clean[i,j]
    }
  }
}


################################        TransferIntent     ###############################################
######TransferIntent 把NA变成-1
col_TransferIntent<-grep("TransferIntent", colnames(progress_test_clean))
progress_test_clean[,col_TransferIntent][is.na(progress_test_clean[,col_TransferIntent])] <- "-1"


################################        DegreeTypeSought      ###############################################
######DegreeTypeSought: 把NA变成-1
col_DegreeTypeSought<-grep("DegreeTypeSought", colnames(progress_test_clean))
progress_test_clean[,col_DegreeTypeSought][is.na(progress_test_clean[,col_DegreeTypeSought])] <- "-1"


################################        GPA     ###############################################

######TermGPA: 找cip不为零的学期创一个final_gpa的variable，如果cip不为零的学期cum_gpa=0则直接删除此人数据
#所有GPA的缺失值替换为-999
col_GPA<-grep(pattern="GPA", colnames(progress_test_clean))
progress_test_clean[,col_GPA][is.na(progress_test_clean[,col_GPA])] <- "-999"

col_CumGPA_all<-grep(pattern="CumGPA", colnames(progress_test_clean))

#add a column of final GPA
progress_test_clean$final_GPA<-0
for (i in 1:nrow(progress_test_clean)){
  for (j in col_CumGPA_all){
    if(progress_test_clean[i,j]>0){
      progress_test_clean[i,"final_GPA"]<-progress_test_clean[i,j]
    }
  }
}


###### output files
write.csv(progress_test_clean,file="output data/progress_test_clean.csv",row.names = FALSE)




# ######change cohort to cohort year
# for (i in 1:nrow(progress_test_clean)){
#   progress_test_clean[i,"cohort"]<-substring((progress_test_clean[i,"cohort"]),1,4)
# }
# 
# ###### first term GPA
# progress_test_clean$first_term_GPA<-0
# for (i in 1:nrow(progress_test_clean)){
#   if (progress_test_clean[i,"cohort.term"]==1){
#     progress_test_clean[i,"first_term_GPA"]<-progress_test_clean[i,paste("TermGPA","Fall",progress_test_clean[i,"cohort"],sep="_")]
#   }
#   else if(progress_test_clean[i,"cohort.term"]==3){
#     if(progress_test_clean[i,paste("TermGPA","Fall",progress_test_clean[i,"cohort"],sep="_")]>0){
#       progress_test_clean[i,"first_term_GPA"]<-progress_test_clean[i,paste("TermGPA","Fall",progress_test_clean[i,"cohort"],sep="_")]
#     }
#     else
#       progress_test_clean[i,"first_term_GPA"]<-progress_test_clean[i,paste("TermGPA","Spring",as.numeric(progress_test_clean[i,"cohort"])+1,sep="_")]
#   }
# }
# 
