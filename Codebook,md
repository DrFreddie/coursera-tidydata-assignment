# Code Book

This document describes the code inside `run_analysis.R`.

## Downloading and loading data

* Downloads the UCI HAR zip file if it doesn't exist
* Reads the activity labels to `activityLabels`
* Reads the column names of data (a.k.a. features) to `features`

### featuresWanted

* Specifically contains those values that are either mean or std
* Using featuresWanted allows for subsectioning during importing of the main datasets for train and tests

##combined <- rbind(train, test)

* Merged the two datasets together

##Turned the activities and subjects into vectors

combined$activity <- factor(combined$activity, levels = activityLabels[,1], labels = activityLabels[,2])
combined$subject <- as.factor(combined$subject)

##Expanded the abbreviated features

names(combined)<-gsub("^t", "time", names(combined))
and the others

##Time for some tidy data sorted by activity and subject

tidyData <- aggregate(. ~subject + activity, combined, mean)

ie, Subject = 1 WALKING
    Subject = 2 WALKING
etc.     

##This groups all thhe activities together

tidyData <- tidyData[order(tidyData$subject, tidyData$activity),]

subject   activity
1         WALKING
1         WALKING_UPSTAIRS

## Wrote to Tidy.txt. Eliminated the row names for better input. 
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
