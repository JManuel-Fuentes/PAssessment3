
## Here are the data for the project: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## You should create one R script called run_analysis.R that does the following. Here are the data for the project: 

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("features.txt")
stdFeatures <- grep("std|mean", features$V2)

# 1. Merges the training and the test sets to create one data set.
xTrain <- read.table("./train/X_train.txt")
trainFeatures <- xTrain[,stdFeatures]
xTest <- read.table("./test/X_test.txt")
testFeatures <- xTest[,stdFeatures]

mergeFeatures <- merge(trainFeatures, testFeatures)

# 3. Uses descriptive activity names to name the activities in the data set
colnames(mergeFeatures) <- features[stdFeatures, 2]

# 4.1 Read and merge train and test activity before assign the labels
yTrain <- read.table("./train/y_train.txt")
yTest <- read.table("./test/y_test.txt")
testActivities <- merge(yTrain, yTest)

# 4.2 Appropriately labels the data set with descriptive variable names. 
activityLabels <- read.table("activity_labels.txt")
testActivities$activity <- factor(testActivities$V1, levels = activityLabels$V1, labels = activityLabels$V2)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
trainSubjects <- read.table("./train/subject_train.txt")
testSubjects <- read.table("./test/subject_test.txt")
totalSubjects <- merge(trainSubjects, testSubjects)

subjectsActivities <- merge(totalSubjects, totalActivities$activity)
colnames(subjectsActivities) <- c("subject.id", "activity")

activityData <- cbind(subjectsActivities, totalFeatures)

# New Result
results <- aggregate(activityData[,3:81], by = list(activityData$subject.id, activity.frame$activity), FUN = mean)
colnames(results)[1:2] <- c("subject.id", "activity")
write.table(results, file="measures.txt", row.names = FALSE)
