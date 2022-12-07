# HUDK_4050_midterm

## initial

需要预先装的包：

```R
library(tidyverse)
library(caret)
library(ggplot2)
library(GGally)
library(ISLR2)
library(pROC)
```

需要读的文件：

```R
train <- read.csv("output data/df_train_clean.csv")
```

根据密度图查看数据和dropout的关联

```R
train %>% ggplot(aes(x = {variable}, fill = factor(Dropout))) +
  geom_density(alpha = .4)
```

把数据分成train和test，以0.75的比例分。并设置crossValidation为10次。

```R
trctrl <- trainControl(method = "cv", number = 10, classProbs = T)
intrain <- createDataPartition(subtrain$Dropout, p = 0.75, list = FALSE)
trainModel <- subtrain[intrain, ]
testModel <- subtrain[-intrain, ]
```

拿到confusion matrix里的值

```R
call <- function(cm) {
  print(cm$byClass["Sensitivity"])
  print(cm$byClass["Specificity"])
  print(cm$byClass["Precision"])
  print(cm$byClass["Recall"])
  print(cm$byClass["F1"])
  print(cm$overall["Accuracy"])
}
```



## attempt 1

选取了所有的带有Work.Study, Loan, Scholarship, 和Grant的列。

用`cor()`跑了一下关联度，发现关联度最大的是2017.Grant，cor达到了0.35。

### logistic regression-max F1

接着把训练出来的logistic regression模型放到testModel里跑了一遍，得到了`X2014.Loan`, `X2015.Loan`, `X2016.Loan`, `X2017.Loan`, `CumLoanAtEntry`, `X2017.Scholarship`, `X2016.Grant`和`X2017.Grant`最有显著性。

- [ ] ~~明天试试只选取这几个跑一遍。~~

跑出confusion matrix后，得到了这个模型的一些值。

| Sensitivity | Specificity | Precision | Recall    | F1        | Accurarcy |
| ----------- | ----------- | --------- | --------- | --------- | --------- |
| 0.7814992   | 0.7337278   | 0.8235294 | 0.7814992 | 0.8019640 | 0.7630548 |

#### logistic regression selected

| Sensitivity | Specificity | Precision | Recall    | F1        | Accurarcy |
| ----------- | ----------- | --------- | --------- | --------- | --------- |
| 0.7575758   | 0.7295013   | 0.8166189 | 0.7575758 | 0.7859901 | 0.7467363 |

### Naive Bayes

| Sensitivity | Specificity | Precision | Recall    | F1        | Accurarcy |
| ----------- | ----------- | --------- | --------- | --------- | --------- |
| 0.4896332   | 0.9019442   | 0.8881389 | 0.4896332 | 0.6312543 | 0.6488251 |

### Knn

| Sensitivity | Specificity | Precision | Recall | F1   | Accurarcy |
| ----------- | ----------- | --------- | ------ | ---- | --------- |
|             |             |           |        |      |           |

### LDA model

| Sensitivity | Specificity | Precision | Recall    | F1        | Accurarcy |
| ----------- | ----------- | --------- | --------- | --------- | --------- |
| 0.7894737   | 0.6694844   | 0.7915778 | 0.7894737 | 0.7905244 | 0.7431462 |

## attempt2

Data clean的时候一起做了一些信息的汇总，包括对Final GPA，Major，英语或数学的汇总，利用这些汇总信息跑模型。

拿了`Dropout`, `Complete_DevMath`, `Complete_DevEnglish`, `final_Complete1`, `final_Complete2`, `final_CompleteCIP1`, `final_CompleteCIP2`, `final_GPA`作为新的subtrain。

事实证明只能把dropout factor化，别的就保持原样比较好，final_CompleteCIP1 用`floor()`往下取整数值，可以拿到具体是哪个学科种类的信息。

`final_Complete2` 和 `final_CompleteCIP2`都是一样的值，就删了，但是F1都有或多或少的减小。

#### logistic regression

| Sensitivity | Specificity | Precision | Recall    | F1        | Accurarcy |
| ----------- | ----------- | --------- | --------- | --------- | --------- |
| 0.7655502   | 0.6060862   | 0.7555089 | 0.7655502 | 0.7604964 | 0.7039817 |

#### Naive Bayes

| Sensitivity | Specificity | Precision | Recall   | F1        | Accurarcy |
| ----------- | ----------- | --------- | -------- | --------- | --------- |
| 0.440723    | 0.9805579   | 0.9730047 | 0.440723 | 0.6066593 | 0.6491514 |

### Knn

| Sensitivity | Specificity | Precision | Recall    | F1        | Accurarcy |
| ----------- | ----------- | --------- | --------- | --------- | --------- |
| 0.7878788   | 0.6187658   | 0.7666839 | 0.7878788 | 0.7771369 | 0.7225849 |

### LDA model

| Sensitivity | Specificity | Precision | Recall    | F1        | Accurarcy |
| ----------- | ----------- | --------- | --------- | --------- | --------- |
| 0.7565125   | 0.5765004   | 0.739605  | 0.7565125 | 0.7479632 | 0.6870104 |

## attempt3 全数据

把所有数据先用logistic regression跑了一遍，减掉了State，因为这个被factorize过，没法通过logistic。

先上数据：

| Sensitivity | Specificity | Precision | Recall    | F1        | Accurarcy |
| ----------- | ----------- | --------- | --------- | --------- | --------- |
| 0.9984051   | 0.9991547   | 0.9994678 | 0.9984051 | 0.9989362 | 0.9986945 |

```bash
summary(logicModel)
Call:
NULL

Deviance Residuals: 
       Min          1Q      Median          3Q         Max  
-1.032e-04  -1.605e-06  -2.100e-08   2.100e-08   1.255e-04  

Coefficients: (60 not defined because of singularities)
                                              Estimate Std. Error z value Pr(>|z|)
(Intercept)                                  2.772e+01  5.314e+03   0.005    0.996
StudentID                                   -6.018e-03  1.651e+03   0.000    1.000
`cohort2012-13`                             -2.503e+01  1.064e+04  -0.002    0.998
`cohort2013-14`                             -5.277e+01  1.244e+04  -0.004    0.997
`cohort2014-15`                             -8.546e+01  1.306e+04  -0.007    0.995
`cohort2015-16`                             -1.204e+02  1.440e+04  -0.008    0.993
`cohort2016-17`                             -1.439e+02  1.523e+04  -0.009    0.992
cohort.term                                 -1.673e+01  2.672e+03  -0.006    0.995
Marital.StatusMarried                       -4.277e-01  3.576e+03   0.000    1.000
Marital.StatusSeparated                     -3.934e-01  2.623e+03   0.000    1.000
Marital.StatusSingle                        -7.496e-01  5.498e+03   0.000    1.000
Marital.StatusUnknown                       -8.786e-01  8.526e+03   0.000    1.000
Adjusted.Gross.Income                        1.428e-01  1.741e+03   0.000    1.000
Parent.Adjusted.Gross.Income                -2.044e-01  2.224e+03   0.000    1.000
`Father.s.Highest.Grade.LevelHigh School`    3.004e-01  2.025e+03   0.000    1.000
`Father.s.Highest.Grade.LevelMiddle School`  9.029e-02  1.869e+03   0.000    1.000
Father.s.Highest.Grade.LevelUnknown          2.748e-01  2.452e+03   0.000    1.000
`Mother.s.Highest.Grade.LevelHigh School`    2.202e-01  1.907e+03   0.000    1.000
`Mother.s.Highest.Grade.LevelMiddle School`  2.383e-01  1.887e+03   0.000    1.000
Mother.s.Highest.Grade.LevelUnknown          3.449e-01  2.233e+03   0.000    1.000
`HousingOn Campus Housing`                  -4.033e-01  2.220e+03   0.000    1.000
HousingUnknown                               1.395e-01  6.838e+03   0.000    1.000
`HousingWith Parent`                        -1.867e-02  1.723e+03   0.000    1.000
X2012.Loan                                   5.908e-01  3.035e+03   0.000    1.000
X2012.Scholarship                            1.163e+00  4.670e+03   0.000    1.000
X2012.Work.Study                            -6.925e-01  1.512e+03   0.000    1.000
X2012.Grant                                  1.115e+00  3.058e+03   0.000    1.000
X2013.Loan                                  -1.012e+00  3.431e+03   0.000    1.000
X2013.Scholarship                           -8.015e-01  5.119e+03   0.000    1.000
X2013.Work.Study                            -3.850e-01  2.051e+03   0.000    1.000
X2013.Grant                                 -9.161e-01  2.982e+03   0.000    1.000
X2014.Loan                                   1.154e+00  2.743e+03   0.000    1.000
X2014.Scholarship                           -3.554e-01  4.132e+03   0.000    1.000
X2014.Work.Study                             2.204e-02  1.251e+03   0.000    1.000
X2014.Grant                                 -1.935e-01  2.248e+03   0.000    1.000
X2015.Loan                                  -3.142e-01  2.543e+03   0.000    1.000
X2015.Scholarship                            3.792e-02  3.756e+03   0.000    1.000
X2015.Work.Study                             1.418e-01  1.155e+03   0.000    1.000
X2015.Grant                                 -5.029e-02  2.366e+03   0.000    1.000
X2016.Loan                                  -1.265e-01  1.916e+03   0.000    1.000
X2016.Scholarship                            1.258e-01  4.252e+03   0.000    1.000
X2016.Work.Study                            -9.226e-02  1.232e+03   0.000    1.000
X2016.Grant                                  1.978e-01  2.259e+03   0.000    1.000
X2017.Loan                                   1.595e-01  1.702e+03   0.000    1.000
X2017.Scholarship                           -8.245e-01  5.708e+03   0.000    1.000
X2017.Work.Study                             1.568e-01  1.148e+03   0.000    1.000
X2017.Grant                                 -2.776e-01  2.039e+03   0.000    1.000
RegistrationDate                             1.294e+00  1.081e+04   0.000    1.000
Gender                                      -1.493e-01  1.418e+03   0.000    1.000
BirthYear                                    5.169e-01  2.340e+03   0.000    1.000
BirthMonth                                  -2.933e-01  1.450e+03   0.000    1.000
Hispanic                                    -1.411e-01  2.655e+03   0.000    1.000
AmericanIndian                              -2.073e-01  5.847e+03   0.000    1.000
Asian                                       -1.983e-01  2.638e+03   0.000    1.000
Black                                        1.037e-01  2.669e+03   0.000    1.000
NativeHawaiian                               3.333e-01  4.778e+03   0.000    1.000
White                                        1.781e-01  2.621e+03   0.000    1.000
TwoOrMoreRace                               -3.638e-01  2.906e+03   0.000    1.000
HSDip                                       -9.746e-02  1.881e+03   0.000    1.000
HSDipYr                                     -2.486e-01  2.000e+03   0.000    1.000
HSGPAUnwtd                                  -2.340e-01  2.372e+03   0.000    1.000
EnrollmentStatus                            -7.370e-01  4.237e+03   0.000    1.000
NumColCredAttemptTransfer                    1.222e-01  3.542e+03   0.000    1.000
NumColCredAcceptTransfer                     2.788e-01  4.431e+03   0.000    1.000
CumLoanAtEntry                                      NA         NA      NA       NA
HighDeg                                     -1.509e-04  2.004e+03   0.000    1.000
MathPlacement                                3.217e-01  9.723e+03   0.000    1.000
EngPlacement                                 5.062e-01  9.117e+03   0.000    1.000
GatewayMathStatus                           -5.769e-01  2.111e+03   0.000    1.000
GatewayEnglishStatus                         2.433e-02  1.827e+03   0.000    1.000
CompleteDevMath_Fall_2011                   -1.156e-01  2.626e+03   0.000    1.000
CompleteDevEnglish_Fall_2011                 2.134e+00  3.565e+03   0.001    1.000
Major1_Fall_2011                             6.974e-01  5.601e+03   0.000    1.000
Major2_Fall_2011                             6.580e-01  6.688e+03   0.000    1.000
Complete1_Fall_2011                                 NA         NA      NA       NA
Complete2_Fall_2011                                 NA         NA      NA       NA
CompleteCIP1_Fall_2011                              NA         NA      NA       NA
CompleteCIP2_Fall_2011                              NA         NA      NA       NA
TransferIntent_Fall_2011                            NA         NA      NA       NA
DegreeTypeSought_Fall_2011                   2.533e+01  3.644e+06   0.000    1.000
TermGPA_Fall_2011                           -4.142e+01  3.646e+06   0.000    1.000
CumGPA_Fall_2011                                    NA         NA      NA       NA
CompleteDevMath_Spring_2012                  5.008e-01  2.860e+03   0.000    1.000
CompleteDevEnglish_Spring_2012              -8.671e-01  3.025e+03   0.000    1.000
Major1_Spring_2012                          -1.124e-01  6.164e+03   0.000    1.000
Major2_Spring_2012                           1.653e-01  1.353e+04   0.000    1.000
Complete1_Spring_2012                       -3.148e+00  1.147e+05   0.000    1.000
Complete2_Spring_2012                               NA         NA      NA       NA
CompleteCIP1_Spring_2012                    -1.024e+01  1.202e+05   0.000    1.000
CompleteCIP2_Spring_2012                            NA         NA      NA       NA
TransferIntent_Spring_2012                          NA         NA      NA       NA
DegreeTypeSought_Spring_2012                 6.794e+02  3.795e+06   0.000    1.000
TermGPA_Spring_2012                          2.171e+02  4.527e+06   0.000    1.000
CumGPA_Spring_2012                          -9.059e+02  6.804e+06   0.000    1.000
CompleteDevMath_sum_2012                    -3.879e+00  1.137e+04   0.000    1.000
CompleteDevEnglish_sum_2012                  5.062e+00  1.181e+04   0.000    1.000
Major1_sum_2012                             -5.875e-01  6.966e+03   0.000    1.000
Major2_sum_2012                             -1.198e-01  1.043e+04   0.000    1.000
Complete1_sum_2012                          -1.255e+01  1.882e+05   0.000    1.000
Complete2_sum_2012                                  NA         NA      NA       NA
CompleteCIP1_sum_2012                       -8.931e+00  1.973e+05   0.000    1.000
CompleteCIP2_sum_2012                               NA         NA      NA       NA
TransferIntent_sum_2012                             NA         NA      NA       NA
DegreeTypeSought_sum_2012                   -1.868e+02  5.831e+06   0.000    1.000
TermGPA_sum_2012                            -1.169e+03  2.504e+06   0.000    1.000
CumGPA_sum_2012                              1.358e+03  5.505e+06   0.000    1.000
CompleteDevMath_Fall_2012                    6.528e-02  2.860e+03   0.000    1.000
CompleteDevEnglish_Fall_2012                 4.263e-01  3.325e+03   0.000    1.000
Major1_Fall_2012                            -9.814e-01  4.722e+03   0.000    1.000
Major2_Fall_2012                            -7.552e-01  1.509e+04   0.000    1.000
Complete1_Fall_2012                         -1.108e+00  1.026e+05   0.000    1.000
Complete2_Fall_2012                                 NA         NA      NA       NA
CompleteCIP1_Fall_2012                      -1.133e+01  1.063e+05   0.000    1.000
CompleteCIP2_Fall_2012                              NA         NA      NA       NA
TransferIntent_Fall_2012                            NA         NA      NA       NA
DegreeTypeSought_Fall_2012                   4.202e+02  3.576e+06   0.000    1.000
TermGPA_Fall_2012                           -1.040e+03  5.019e+06   0.000    1.000
CumGPA_Fall_2012                             6.035e+02  6.010e+06   0.000    1.000
CompleteDevMath_Spring_2013                 -6.633e-03  2.471e+03   0.000    1.000
CompleteDevEnglish_Spring_2013              -9.023e-01  3.507e+03   0.000    1.000
Major1_Spring_2013                           6.378e-01  5.145e+03   0.000    1.000
Major2_Spring_2013                          -5.554e-01  1.599e+04   0.000    1.000
Complete1_Spring_2013                       -9.306e+00  1.582e+05   0.000    1.000
Complete2_Spring_2013                               NA         NA      NA       NA
CompleteCIP1_Spring_2013                    -2.036e+01  1.748e+05   0.000    1.000
CompleteCIP2_Spring_2013                            NA         NA      NA       NA
TransferIntent_Spring_2013                          NA         NA      NA       NA
DegreeTypeSought_Spring_2013                -3.011e+02  4.986e+06   0.000    1.000
TermGPA_Spring_2013                         -8.774e+02  2.916e+06   0.000    1.000
CumGPA_Spring_2013                           1.163e+03  7.059e+06   0.000    1.000
CompleteDevMath_sum_2013                    -6.756e-01  4.973e+03   0.000    1.000
CompleteDevEnglish_sum_2013                  5.433e-01  4.719e+03   0.000    1.000
Major1_sum_2013                             -1.763e+00  5.741e+03   0.000    1.000
Major2_sum_2013                             -2.138e+00  6.381e+03   0.000    1.000
Complete1_sum_2013                          -6.497e+00  1.305e+05   0.000    1.000
Complete2_sum_2013                                  NA         NA      NA       NA
CompleteCIP1_sum_2013                       -1.860e+01  1.487e+05   0.000    1.000
CompleteCIP2_sum_2013                               NA         NA      NA       NA
TransferIntent_sum_2013                             NA         NA      NA       NA
DegreeTypeSought_sum_2013                    9.107e+02  3.425e+06   0.000    1.000
TermGPA_sum_2013                            -5.644e+02  1.679e+06   0.000    1.000
CumGPA_sum_2013                             -3.463e+02  3.471e+06   0.000    1.000
CompleteDevMath_Fall_2013                   -6.891e-01  2.731e+03   0.000    1.000
CompleteDevEnglish_Fall_2013                 1.724e-01  2.958e+03   0.000    1.000
Major1_Fall_2013                             5.297e-02  4.424e+03   0.000    1.000
Major2_Fall_2013                             7.103e-01  4.475e+03   0.000    1.000
Complete1_Fall_2013                         -3.239e+00  1.230e+05   0.000    1.000
Complete2_Fall_2013                                 NA         NA      NA       NA
CompleteCIP1_Fall_2013                      -1.622e+01  1.310e+05   0.000    1.000
CompleteCIP2_Fall_2013                              NA         NA      NA       NA
TransferIntent_Fall_2013                            NA         NA      NA       NA
DegreeTypeSought_Fall_2013                  -1.691e+02  2.127e+06   0.000    1.000
TermGPA_Fall_2013                           -6.345e+02  2.273e+06   0.000    1.000
CumGPA_Fall_2013                             7.846e+02  3.222e+06   0.000    1.000
CompleteDevMath_Spring_2014                  7.944e-01  2.589e+03   0.000    1.000
CompleteDevEnglish_Spring_2014              -9.949e-02  2.916e+03   0.000    1.000
Major1_Spring_2014                          -7.349e-01  4.417e+03   0.000    1.000
Major2_Spring_2014                          -3.549e-01  4.690e+03   0.000    1.000
Complete1_Spring_2014                        5.811e-02  2.015e+05   0.000    1.000
Complete2_Spring_2014                               NA         NA      NA       NA
CompleteCIP1_Spring_2014                    -2.565e+01  2.106e+05   0.000    1.000
CompleteCIP2_Spring_2014                            NA         NA      NA       NA
TransferIntent_Spring_2014                          NA         NA      NA       NA
DegreeTypeSought_Spring_2014                -4.292e+01  3.119e+06   0.000    1.000
TermGPA_Spring_2014                          3.934e+02  2.171e+06   0.000    1.000
CumGPA_Spring_2014                          -3.689e+02  4.250e+06   0.000    1.000
CompleteDevMath_sum_2014                     5.021e-01  2.172e+03   0.000    1.000
CompleteDevEnglish_sum_2014                 -1.634e-01  2.053e+03   0.000    1.000
Major1_sum_2014                              4.631e-01  3.269e+03   0.000    1.000
Major2_sum_2014                              2.508e-01  2.058e+03   0.000    1.000
Complete1_sum_2014                          -6.579e+00  1.646e+05   0.000    1.000
Complete2_sum_2014                                  NA         NA      NA       NA
CompleteCIP1_sum_2014                       -1.920e+01  1.854e+05   0.000    1.000
CompleteCIP2_sum_2014                               NA         NA      NA       NA
TransferIntent_sum_2014                             NA         NA      NA       NA
DegreeTypeSought_sum_2014                   -7.183e+02  2.643e+06   0.000    1.000
TermGPA_sum_2014                             1.031e+01  9.991e+05   0.000    1.000
CumGPA_sum_2014                              7.083e+02  2.901e+06   0.000    1.000
CompleteDevMath_Fall_2014                   -1.249e+00  3.372e+03   0.000    1.000
CompleteDevEnglish_Fall_2014                 7.398e-01  3.174e+03   0.000    1.000
Major1_Fall_2014                             1.070e+00  3.574e+03   0.000    1.000
Major2_Fall_2014                            -3.783e-01  2.215e+03   0.000    1.000
Complete1_Fall_2014                          3.806e+00  1.677e+05   0.000    1.000
Complete2_Fall_2014                                 NA         NA      NA       NA
CompleteCIP1_Fall_2014                      -2.459e+01  1.746e+05   0.000    1.000
CompleteCIP2_Fall_2014                              NA         NA      NA       NA
TransferIntent_Fall_2014                            NA         NA      NA       NA
DegreeTypeSought_Fall_2014                  -2.610e+01  1.870e+06   0.000    1.000
TermGPA_Fall_2014                           -2.872e+01  1.704e+06   0.000    1.000
CumGPA_Fall_2014                             3.385e+01  2.546e+06   0.000    1.000
CompleteDevMath_Spring_2015                  5.789e-01  3.011e+03   0.000    1.000
CompleteDevEnglish_Spring_2015              -2.199e-01  3.645e+03   0.000    1.000
Major1_Spring_2015                          -1.455e+00  3.277e+03   0.000    1.000
Major2_Spring_2015                           4.100e-01  2.370e+03   0.000    1.000
Complete1_Spring_2015                        2.153e+01  2.581e+05   0.000    1.000
Complete2_Spring_2015                               NA         NA      NA       NA
CompleteCIP1_Spring_2015                    -5.456e+01  2.800e+05   0.000    1.000
CompleteCIP2_Spring_2015                            NA         NA      NA       NA
TransferIntent_Spring_2015                          NA         NA      NA       NA
DegreeTypeSought_Spring_2015                 2.425e+02  1.724e+06   0.000    1.000
TermGPA_Spring_2015                         -6.553e+01  1.269e+06   0.000    1.000
CumGPA_Spring_2015                          -1.963e+02  2.204e+06   0.000    1.000
CompleteDevMath_sum_2015                    -1.391e-01  1.962e+03   0.000    1.000
CompleteDevEnglish_sum_2015                 -1.011e-01  1.907e+03   0.000    1.000
Major1_sum_2015                              6.889e-01  3.183e+03   0.000    1.000
Major2_sum_2015                             -2.488e-02  1.874e+03   0.000    1.000
Complete1_sum_2015                           1.582e+00  1.868e+05   0.000    1.000
Complete2_sum_2015                                  NA         NA      NA       NA
CompleteCIP1_sum_2015                       -2.538e+01  2.112e+05   0.000    1.000
CompleteCIP2_sum_2015                               NA         NA      NA       NA
TransferIntent_sum_2015                             NA         NA      NA       NA
DegreeTypeSought_sum_2015                   -5.076e+02  2.150e+06   0.000    1.000
TermGPA_sum_2015                             2.661e+01  9.943e+05   0.000    1.000
CumGPA_sum_2015                              4.807e+02  2.468e+06   0.000    1.000
CompleteDevMath_Fall_2015                   -3.095e-01  3.047e+03   0.000    1.000
CompleteDevEnglish_Fall_2015                -1.379e-01  3.404e+03   0.000    1.000
Major1_Fall_2015                             4.418e-01  3.460e+03   0.000    1.000
Major2_Fall_2015                            -3.613e-01  2.261e+03   0.000    1.000
Complete1_Fall_2015                          2.293e+01  1.779e+05   0.000    1.000
Complete2_Fall_2015                                 NA         NA      NA       NA
CompleteCIP1_Fall_2015                      -4.675e+01  1.920e+05   0.000    1.000
CompleteCIP2_Fall_2015                              NA         NA      NA       NA
TransferIntent_Fall_2015                            NA         NA      NA       NA
DegreeTypeSought_Fall_2015                   2.036e+02  1.703e+06   0.000    1.000
TermGPA_Fall_2015                            1.843e+02  1.306e+06   0.000    1.000
CumGPA_Fall_2015                            -4.104e+02  2.170e+06   0.000    1.000
CompleteDevMath_Spring_2016                  2.380e-01  3.557e+03   0.000    1.000
CompleteDevEnglish_Spring_2016              -2.260e-01  4.083e+03   0.000    1.000
Major1_Spring_2016                          -6.379e-02  3.978e+03   0.000    1.000
Major2_Spring_2016                           2.191e-01  1.913e+03   0.000    1.000
Complete1_Spring_2016                       -9.258e-01  2.786e+05   0.000    1.000
Complete2_Spring_2016                               NA         NA      NA       NA
CompleteCIP1_Spring_2016                    -2.285e+01  2.964e+05   0.000    1.000
CompleteCIP2_Spring_2016                            NA         NA      NA       NA
TransferIntent_Spring_2016                          NA         NA      NA       NA
DegreeTypeSought_Spring_2016                -5.359e+01  1.955e+06   0.000    1.000
TermGPA_Spring_2016                          1.815e+02  1.223e+06   0.000    1.000
CumGPA_Spring_2016                          -1.513e+02  2.470e+06   0.000    1.000
CompleteDevMath_sum_2016                    -2.959e-01  1.944e+03   0.000    1.000
CompleteDevEnglish_sum_2016                  2.952e-01  1.922e+03   0.000    1.000
Major1_sum_2016                             -1.201e+00  4.089e+03   0.000    1.000
Major2_sum_2016                             -8.083e-02  1.315e+03   0.000    1.000
Complete1_sum_2016                           9.381e-01  1.842e+05   0.000    1.000
Complete2_sum_2016                                  NA         NA      NA       NA
CompleteCIP1_sum_2016                       -1.848e+01  2.038e+05   0.000    1.000
CompleteCIP2_sum_2016                               NA         NA      NA       NA
TransferIntent_sum_2016                             NA         NA      NA       NA
DegreeTypeSought_sum_2016                    2.782e+02  1.681e+06   0.000    1.000
TermGPA_sum_2016                            -5.057e+01  9.675e+05   0.000    1.000
CumGPA_sum_2016                             -2.268e+02  1.731e+06   0.000    1.000
 [ reached getOption("max.print") -- omitted 43 rows ]

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 1.2268e+04  on 9196  degrees of freedom
Residual deviance: 8.9203e-07  on 8964  degrees of freedom
AIC: 466

Number of Fisher Scoring iterations: 25

```

