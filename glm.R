setwd('/Users/salmonn_talebi/Desktop/Stats 202/Project')

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
train = data2

MissingVal = sum(is.na(train))

par(mfrow=c(2,2))
hist(train[,1])
hist(train[,2])
hist(train[,3])
hist(train[,4])

par(mfrow=c(2,2))
hist(train[,5])
hist(train[,6])
hist(train[,7])
hist(train[,8])

par(mfrow=c(2,2))
hist(train[,9])
hist(train[,10])
hist(train[,11])
hist(train[,12])

par(mfrow=c(2,2))
plot(train[,1], train[,13])
plot(train[,2], train[,13])
plot(train[,3], train[,13])
plot(train[,4], train[,13])

par(mfrow=c(2,2))
plot(train[,5], train[,13])
plot(train[,6], train[,13])
plot(train[,7], train[,13])
plot(train[,8], train[,13])
library(boot)
set.seed(11)
cv.error.5 = rep(0,5)
for (i in 1:5){
  glm.fit = glm(train$relevance ~., data=train, family=binomial())
  cv.error.5[i]=cv.glm(train, glm.fit, K=5)$delta[1]
}
cv.error.5
fit.glm = glm(train$relevance ~., data=train, family=binomial())
summary(fit.glm)
predict.glm = predict(fit.glm, test, type = "response")
glm.pred.value = rep(0, length(predict.glm)) 
glm.pred.value[predict.glm > 0.5] = 1
mismatch = table(glm.pred.value, test$relevance)
pright = (mismatch[1,1] + mismatch[2,2])/length(predict.glm)
error.rate = 1-pright
error.rate
fit.glm2 = glm(train$relevance ~., train, family=binomial())
predict.glm2 = predict(fit.glm2, data = test, type = "response")
glm.pred.value = rep(0, length(predict.glm2)) 
glm.pred.value[predict.glm > 0.5] = 1
mismatch = table(glm.pred.value, test$relevance)
pright = (mismatch[1,1] + mismatch[2,2])/length(predict.glm)
error.rate = 1-pright
error.rate
