library(e1071)
library(ISLR) 
library(tree)
library(ISLR) 
library(rpart)
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
testFinal = read.csv("test.csv")

search.tree = tree(train$relevance~., data=train)
summary(search.tree)
plot(search.tree)
text(search.tree)
tree.pred = predict(search.tree, test)
tree.pred.value = rep(0, length(test$sig1)) 
tree.pred.value[tree.pred > 0.5] = 1
mismatch = table(tree.pred.value, test$relevance)
pright = (mismatch[1,1] + mismatch[2,2])/length(tree.pred)
error.rate = 1-pright


## cv tree
tree.cv = cv.tree(search.tree, FUN = prune.tree) 
plot(tree.cv$size, tree.cv$dev)

## random forest
library(randomForest)

search.bagging = randomForest(train$relevance~. -train$query_id -train$url_id, data=train, mtry=3, ntree=700, importance = T)
bagging.pred = predict(search.bagging, testFinal) 
bagging.pred.value = rep(0, length(test$sig1)) 
bagging.pred.value[bagging.pred > 0.5] = 1
mismatch = table(bagging.pred.value, test$relevance)
pright = (mismatch[1,1] + mismatch[2,2])/length(bagging.pred)
error.rate = 1-pright

## boosting
library(gbm)

fit.gbm1 <- gbm(train$relevance~ ., data=train, train.fraction = 0.8,
                interaction.depth=4,shrinkage=.05,
                n.trees=1500,bag.fraction=0.5,cv.folds=5,
                distribution="laplace",verbose=T)

numTree = gbm.perf(fit.gbm1,method="cv")
boosting.pred = predict(fit.gbm1, test, n.trees = numTree)
boosting.pred.value = rep(0, length(test$sig1)) 
boosting.pred.value[boosting.pred > 0.5] = 1
mismatch = table(boosting.pred.value, test$relevance)
pright = (mismatch[1,1] + mismatch[2,2])/length(boosting.pred)
error.rate = 1-pright


