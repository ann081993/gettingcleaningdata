library(tidyr)
library(reshape2)

## read data
if(getwd() != "C:/Users/Administrator/Documents") {
        setwd("C:/Users/Administrator/Documents")
}
X_train <- read.table("./cleaningWeek5/UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./cleaningWeek5/UCI HAR Dataset/test/X_test.txt")

y_train <- read.table("./cleaningWeek5/UCI HAR Dataset/train/y_train.txt",
                      stringsAsFactors = FALSE)
y_test <- read.table("./cleaningWeek5/UCI HAR Dataset/test/y_test.txt",
                     stringsAsFactors = FALSE)

subject_train <- read.table("./cleaningWeek5/UCI HAR Dataset/train/subject_train.txt",
                            stringsAsFactors = FALSE)
subject_test <- read.table("./cleaningWeek5/UCI HAR Dataset/test/subject_test.txt",
                           stringsAsFactors = FALSE)

activity_labels <- read.table("./cleaningWeek5/UCI HAR Dataset/activity_labels.txt",
                              stringsAsFactors = FALSE)
features <- read.table("./cleaningWeek5/UCI HAR Dataset/features.txt",
                              stringsAsFactors = FALSE)

## 1. Merges the training and the test sets to create one data set.

# add column names for measurement files
colnames(X_train) <- features$V2
colnames(X_test) <- features$V2

# add column name for subject files
colnames(subject_train) <- "subjectID"
colnames(subject_test) <- "subjectID"

# add column name for label files
colnames(y_train) <- "activityID"
colnames(y_test) <- "activityID"

# merge into one data set
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
X_all <- rbind(train, test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features.to.extract <- c(TRUE, TRUE, grepl("mean|std", colnames(X_all))) ## TRUEs for IDs
X_extracted <- X_all[, features.to.extract]

## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
X_extracted$activityID <- factor(X_extracted$activityID,
                                 labels = activity_labels$V2)

## 5. From the data set in step 4, creates a second, independent tidy data set
##      with the average of each variable for each activity and each subject.
X_melted <- melt(X_extracted, id = c("subjectID", "activityID"))
X_tidy <- dcast(X_melted, subjectID + activityID ~ variable, mean)

# write data
write.csv(X_tidy, "X_tidy.csv", row.names = FALSE)
write.table(X_tidy, "X_tidy.txt", row.names = FALSE)