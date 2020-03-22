#DATA
set.seed(123)
data=read.csv(file.choose(),header=TRUE)
dim(data)
names(data)
View(data)

##converting target variable into binomial
data$cat=cut(data$calfev1, breaks = c(0,70,113), labels = c("1","0"))

##summary for all variables in the dataset
str(data)
summary(data)

##dealing with na's if any
names(data) <- gsub("_", "", names(data))
data[data == ""] <- NA
data<-na.omit(data)
summary(data)
##no missing values or na's found

##summary for selected variables
summary(data[c("Height", "FEV1")])
cor(data[c("Height","Weight", "FEV1","FVC")])
          ## "Waist.cir", "calfev1","SunlightExpHours","WorkVigActDays",
           ##"WorkModerateDays","TranspWalkingDays","TranspCyclingDays","DistanceFromIndustry",
          ## "DistanceofHouseFromMainRoad","Complex.Carbohydrates","High.Carbohydrate",
           ##"High.quality.Protein.Score","anxscore","iron.score")])
cor(data[c("FEV1", "FVC","Waist.cir", "calfev1","SunlightExpHours","WorkVigActDays")])

##more summary stats--categorical variables
install.packages("mosaic")
library(mosaic)
tally(~catfev1, data = data, margins = TRUE)
tally(~catfev1, data = data, margins = TRUE, format="perc")
tally(~catfev1, data = data, margins = TRUE, format="prop")

##plot of target
plot(data$cat, main="progressive patients", col="grey")

##histogram of calculated fev1 values
##to see the where most of the patients belong
hist(data$calfev1, main="Maximum population", col = "grey")
hist(data$FEV1, main="FEV1 results",col = "grey")
hist(data$FVC, main="FVC results", col="grey")


