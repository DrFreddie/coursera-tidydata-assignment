# Download the data set and 
# creating a data subdirectory within the working directory if it doesn't 
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="Dataset.zip")

#After the download, we need the activities and featuress with and the descriptive column
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

#We only wanted a subset of the features mainly those with mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

#With our subsets, we can now load the datasets selectively for the mean and stdev
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

#Now, repeat for the test datasets
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

#We have our two datasets. Let's put them together and let's name them too.
#VI, V2, V3, etc is not helpful
combined <- rbind(train, test)
colnames(combined) <- c("subject", "activity", featuresWanted.names)

#Great, now let's turn those activities and subjects to vectors
combined$activity <- factor(combined$activity, levels = activityLabels[,1], labels = activityLabels[,2])
combined$subject <- as.factor(combined$subject)

#Okay, the features are abbreviated or duplicated in the case of BodyBody, so let's expand them by renaming the features
names(combined)<-gsub("^t", "time", names(combined))
names(combined)<-gsub("^f", "frequency", names(combined))
names(combined)<-gsub("Acc", "Accelerometer", names(combined))
names(combined)<-gsub("Gyro", "Gyroscope", names(combined))
names(combined)<-gsub("Mag", "Magnitude", names(combined))
names(combined)<-gsub("BodyBody", "Body", names(combined))

#Time for some tidy data sorted by activity and subject
combined$subject <- as.factor(combined$subject)
combined <- data.table(combined)

tidyData <- aggregate(. ~subject + activity, combined, mean)
tidyData <- tidyData[order(tidyData$subject, tidyData$activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
                  


