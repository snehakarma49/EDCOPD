##data
set.seed(123)
data=read.csv(file.choose(), header=T)
str(data)
dim(data)
names(data)
##categorizing the target variable into healthy(0) and unhealthy(1)
data$cat=cut(data$calfev1, breaks=c(0,70,113), labels=c("1","0"))

##getting rid of na's if any
names(data) <- gsub("_", "", names(data))
data[data == ""] <- NA
summary(data)
data<-na.omit(data)
summary(data)

##getting rid of variables not required after feature selection
View(data)
data[1]=NULL #data[2:4]=NULL data[5:14]=NULL data[6]=NULL data[9:13]=NULL data[11:29]=NULL data[17]=NULL data[18:23]=NULL

##train and test
set.seed(123)
ind<-sample(2,nrow(data),replace=T,prob=c(0.7,0.3))
train<-data[ind==1,]
test<-data[ind==2,]

##10-fold cross validation
library(caret)
custom=trainControl(method="repeatedcv", number = 10, repeats = 5, verboseIter = T)

##decision tree
library(party)
tree=ctree(cat~., data = train)
##tree=ctree(cat~., data=train, controls=ctree_control(mincriterion = 0.9, minsplit = 250))
tree
plot(tree)
##predict
predict(tree, test) 
predict(tree, test, type="prob")

##decision tree with rpart
library(rpart)
tree1=rpart(cat~., train)
tree1
plot(tree1)
text(tree1, pretty = 0)
library(rpart)
rpart.plot(tree1, extra=4)

##prediction
predict(tree1, test)

##misclassification error
tab=table(predict(tree), train$cat)
print(tab)
print(tab)
#   1  2
#1 98 40
#2  4 69
1-sum(diag(tab))/sum(tab)

##misclass test set
testpred= predict(tree, newdata=test)
tab=table(testpred, test$cat)
print(tab)
1-sum(diag(tab))/sum(tab)

##confusion matrix
##prediction--train 
p1=predict(tree,train)
head(p1)
head(train$cat)
confusionMatrix(p1, train$cat)

##predict test data
p2=predict(tree,test)
head(p2)
head(test$cat)
confusionMatrix(p2, test$cat)

##plotting AUC for decision tree
library(ROCR)
library(ROSE)
library(AUC)
logp=predict(tree, newdata = test)
roc.curve(test$cat, logp)

