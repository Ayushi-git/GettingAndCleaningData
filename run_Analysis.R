##Reading all the data

dataTest_X <- read.table("X_test.txt", header = FALSE)

dataTest_Y <- read.table("Y_test.txt", header= FALSE)

dataTrain_X <- read.table("X_train.txt", header = FALSE)

dataTrain_Y <- read.table("Y_train.txt", header = FALSE)

dataSubjectTrain <- read.table("subject_train.txt", header = FALSE)

dataSubjectTest <- read.table("subject_test.txt", header = FALSE)

features <- read.table("features.txt", header = FALSE)
features <- as.character(features[,2])

activityLabels <- read.table("activity_labels.txt", header = FALSE)
activityLabels<-as.character(activityLabels[,2])

##check structures

str(activityLabels)
str(features)
str(dataSubjectTest)
str(dataTest_X)
str(dataTest_Y)
##combining train and test dataset
datatrain <- data.frame(dataSubjectTrain, dataTrain_Y, dataTrain_X)

datatest <- data.frame(dataSubjectTest, dataTest_Y, dataTest_X)

str(datatest)

names(datatest) <- c("Subject", "activity", features)
names(datatrain) <- c("Subject", "activity", features)

##merge training and test dataset to create one

Dataset <- rbind(datatest, datatrain)

grep(pattern = "mean()|std()", names(Dataset), value = TRUE)

subset(Dataset, grep(pattern = "mean()|std()", names(Dataset), value = TRUE, select = c("Subject", "activity")) )

DataMeanStd <- Dataset[, which(colnames(Dataset) %in%  (grep(pattern = "mean()|std()", names(Dataset), value = TRUE)))]

DataExt <- data.frame(Dataset[,1:2], DataMeanStd)

##renaming activity with activity labels

DataExt$activity <- activityLabels[DataExt$activity]

##Appropriately labels the data set with descriptive variable names.

names(DataExt) <- gsub("^t", "time", names(DataExt))
names(DataExt) <- gsub("^f", "frequency", names(DataExt))
names(DataExt) <- gsub("Acc", "Acceleration", names(DataExt))
names(DataExt) <- gsub("Gyro", "Gyrometer", names(DataExt))
names(DataExt) <- gsub("BodyBody", "Body", names(DataExt))
names(DataExt)

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidyData <- aggregate(.~Subject+activity, DataExt, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$activity),]

##writing data to a txt file

write.table(tidyData, file = "tidyData.txt",row.names = FALSE)
