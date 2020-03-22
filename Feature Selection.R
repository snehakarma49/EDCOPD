##libraries
set.seed(123)
library(caret)
library(glmnet)
library(mlbench)
library(psych)

##data ##thesisfinal from desktop
set.seed(123)
data=read.csv(file.choose(), header=T)
str(data)
dim(data)
View(data)

##converting target variable in binomial form
data$cat=cut(data$calfev1, breaks = c(0,70,113), labels = c("1","0"))
names(data)
summary(data$catfev1)
data[1]=NULL
data[10:11]=NULL
data[6]=NULL

##getting rid of na's if any
names(data) <- gsub("_", "", names(data))
data[data == ""] <- NA
summary(data)
data<-na.omit(data)
summary(data)
View(data)
data[1]=NULL
View(data)

##divide the data into train and test
set.seed(123)
ind<-sample(2,nrow(data),replace=T,prob=c(0.7,0.3))
train<-data[ind==1,]
test<-data[ind==2,]

##10-fold cross validation
library(caret)
custom=trainControl(method="repeatedcv", number = 10, repeats = 5, verboseIter = T)

##ridge regression
ridge<-train(cat~. , train, method='glmnet',tuneGrid = expand.grid(alpha=0,lambda=seq(0.0001,0.2,length=5)),trControl=custom)
plot(ridge)
ridge
##explain log lambda
plot(ridge$finalModel,xvar="lambda",label=T)
##explain the deviance of variables
plot(ridge$finalModel,xvar='dev',label=T)
plot(varImp(ridge,scale=T))
##0.85; 0.71; alpha=0, lambda=0.0001

##lasso regression
lasso<-train(cat~. , train, method='glmnet',tuneGrid = expand.grid(alpha=1,lambda=seq(0.0001,1,length=5)),trControl=custom)
plot(lasso)
lasso     #acc-0.76#kappa-0.51#alpha=1;lambda=0.0001
##explain log lambda
plot(lasso$finalModel,xvar="lambda",label=T)
##explain the deviance of variables
plot(lasso$finalModel,xvar='dev',label=F)
plot(varImp(lasso,scale=T))
lasso<-train(catfev1~. , train, method='glmnet',tuneGrid = expand.grid(alpha=1,lambda=seq(0.0001,0.25,length=5)),trControl=custom)

##comparing the models
resamps=resamples(list(Ridge=ridge, Lasso=lasso))
summary(resamps)

bwplot(resamps)
resamps$metrics
xyplot(resamps, metric='Accuracy')

##best model
lasso$bestTune

best<-lasso$finalModel
coef(best,s=lasso$bestTune$lambda)

##save for later use
saveRDS(lasso, "final_model.rds")
