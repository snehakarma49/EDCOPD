##data
set.seed(123)
data=read.csv(file.choose(), header=T)
str(data)
dim(data)
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

##gbm model
library(gbm)
library(distr)
gbmautotree=train(cat~., data = train, method="gbm", distribution="bernoulli", trControl=custom, verbose=FALSE)
gbmautotree

getModelInfo()$gbm$parameters


##setting the grid/matrix for hyperparameter tuning
myGrid=expand.grid(n.trees=c(150,175,200,225),
                   interaction.depth = c(5,6,7,8,9),
                   shrinkage=c(0.075,0.1,0.125,0.15,0.2),
                   n.minobsinnode=c(7,10,12,15))
set.seed(123)
gbmtreetune=train(cat~., data=train, method="gbm",
                  trControl=custom, verbose=FALSE,
                  tuneGrid=myGrid)

library(ROCR)

myGrid=gbmtreetune$bestTune
gbmtree=train(cat~., data=train, method="gbm",
              trControl=custom,
              tuneGrid=myGrid,
              verbose=FALSE)
gbmtree

##see whether tuned gbm performs better than initially built gbm model
resams=resamples(list(gbmautotree, gbmtreetune))
summary(resams)

##prediction--train set
p1=predict(gbmtreetune,train)
head(p1)
head(train$cat)
confusionMatrix(p1, train$cat)

##predict--test set
p2=predict(gbmtreetune,test)
head(p2)
head(test$cat)
confusionMatrix(p2, test$cat)

##plotting the AUC curve
library(AUC)
library(ROCR)
library(ROSE)
logp=predict(gbmtreetune, newdata = test)
roc.curve(test$cat, logp)
varImp(gbmtreetune)
varImpPlot(gbmtreetune)
rocimp=varImp(gbmtreetune, scale = FALSE)
rocimp
##plot the top 15 variables
plot(rocimp, top = 15)
