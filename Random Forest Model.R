##data
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
View(data)#data[1]=NULL data[2:4]=NULL data[5:14]=NULL data[6]=NULL data[9:13]=NULL data[11:29]=NULL data[17]=NULL data[18:23]=NULL

##train and test data
set.seed(123)
ind<-sample(2,nrow(data),replace=T,prob=c(0.7,0.3))
train<-data[ind==1,]
test<-data[ind==2,]
data$readmitted=as.integer(data$readmitted)


idx1<-seq(1:100)
data_new<-data_new[idx1,]
idx<-sample(nrow(data_new),as.integer(.70*nrow(data_new)))
training<-data_new[idx,]
test<-data_new[-idx,]
##10-fold cross validation
#library(caret)
#custom=trainControl(method="repeatedcv", number = 10, repeats = 5, verboseIter = T)

##Random forest
library(randomForest)
rf=randomForest(readmitted~., data = train)
##after hyperparameter tuning
rf=randomForest(cat~., data = train,ntree=450,mtry=16,importance=TRUE,proximity=TRUE, trControl=custom)
rf
attributes(rf)
rf$confusion

##prediction--train 
p1=predict(rf,train)
head(p1)
head(train$cat)
confusionMatrix(p1, train$cat)

##predict--test
p2=predict(rf,test)
head(p2)
head(test$cat)
confusionMatrix(p2, test$cat)

##hyperparameter tuning
##error rate
plot(rf)
rf$mtry
View(data)

##tune mtry 
t=tuneRF(train[,-18], train[,18], stepFactor = 0.5, plot = TRUE, ntreeTry = 450, trace=TRUE, improve = 0.05)
t
##no of trees
hist(treesize(rf), main ="nodes", col="green")

##variable inportance
varImpPlot(rf)
varUsed(rf)   ##[1] 194 217 299 232  29  12  13   6  46  38  43   5  50  49  47  35  24

##partial dependence plot
partialPlot(rf, train,  FEV1 ,"1")

##extract single tree
getTree(rf,1,labelVar = TRUE)

##multi dimensional scaling plot of proximity matrix
MDSplot(rf,train$cat)


##plot auc for random forest model
library(AUC)
library(ROCR)
library(ROSE)
logp=predict(rf, newdata = test)
roc.curve(test$cat, logp)


