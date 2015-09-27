# Coursera Getting and Cleaning Data
# Marco Xiang
# Sept 2015

# Load libraries
library(reshape2)

# Set working directory
setwd('./UCI HAR Dataset/');

# Read in supporting data sets
features = read.table('./features.txt',header=FALSE); 
activityType = read.table('./activity_labels.txt',header=FALSE); 

# Assign column names to supporting data sets
colnames(activityType) = c('activityId','activityType');

# Read in training data sets
subjectTrain = read.table('./train/subject_train.txt',header=FALSE); 
xTrain = read.table('./train/x_train.txt',header=FALSE); 
yTrain = read.table('./train/y_train.txt',header=FALSE); 

# Assign column names to training data sets
colnames(subjectTrain) = "subjectId";
colnames(xTrain) = features[,2]; 
colnames(yTrain) = "activityId";

# Merge training data
trainingDataSet = cbind(yTrain,subjectTrain,xTrain);

# Read in test data sets
subjectTest = read.table('./test/subject_test.txt',header=FALSE); 
xTest = read.table('./test/x_test.txt',header=FALSE); 
yTest = read.table('./test/y_test.txt',header=FALSE);

# Assign column names to test data sets
colnames(subjectTest) = "subjectId";
colnames(xTest) = features[,2]; 
colnames(yTest) = "activityId";

# Merge test data
testDataSet = cbind(yTest,subjectTest,xTest);

# Merge training and test data sets
combinedDataSet = rbind(trainingDataSet,testDataSet);

# Extract mean and STD values
mean <- grep("mean",names(combinedDataSet),ignore.case=TRUE)
meanData <- names(combinedDataSet)[mean]
std <- grep("std",names(combinedDataSet),ignore.case=TRUE)
stdData <- names(combinedDataSet)[std]
meanStdDataSet <- combinedDataSet[,c("subjectId","activityId",meanData,stdData)]

# Merge descriptive names
descriptiveNames <- merge(activityType,meanStdDataSet,by.x="activityId",by.y="activityId",all=TRUE)
tempData <- melt(descriptiveNames,id=c("activityId","activityType","subjectId"),na.rm=TRUE)

# Tidy data set with mean of each value
tidyDataSet <- dcast(tempData,activityId + activityType + subjectId ~ variable,mean)

# Write out table
write.table(tidyDataSet,"./tidy_data.txt",row.name=FALSE)
