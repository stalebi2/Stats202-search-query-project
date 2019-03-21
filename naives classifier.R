library(e1071)
library(ISLR) 
library(tree)
library(ISLR) 
library(tree)
data2 = read.csv("training.csv")
data2[data2==0]<-0.01
data2$sig5 = log(data2$sig5)
data2$sig6 = log(data2$sig6)
data2$sig3 = log(data2$sig3)
data2$sig4 = log(data2$sig4)
set.seed(123)
sample = sample(nrow(data2), size = floor(0.66*nrow(data2)))
train = data2[sample, ]
test = data2[-sample, ]


fit.naive = naiveBayes(train$relevance~., train, laplace = 1)
predict.naive2 = predict(fit.naive, test, type = "raw")
glm.pred.value = rep(0, length(predict.naive2[,2])) 
glm.pred.value[predict.naive2[,2] > 0.5] = 1
mismatch = table(glm.pred.value, test$relevance)
pright = (mismatch[1,1] + mismatch[2,2])/length(predict.naive2[,2])
error.rate = 1-pright
error.rate