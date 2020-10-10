# Data science Course 3 - Getting and Cleaning data
# Final assignment
# Script run_analysis.R


#load packages
packages <- c("data.table","dplyr")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

# download file and unzip datafiles
path_files<-getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "dataFiles.zip")
unzip(zipfile = "dataFiles.zip")

# read datafiles
activity_labels <- fread("UCI HAR Dataset/activity_labels.txt")
features <- fread("UCI HAR Dataset/features.txt")

training_data <- fread("UCI HAR Dataset/train/X_train.txt")
training_activities <- fread("UCI HAR Dataset/train/Y_train.txt")
training_subjects <- fread("UCI HAR Dataset/train/subject_train.txt")

test_data <- fread("UCI HAR Dataset/test/X_test.txt")
test_activities <- fread("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- fread("UCI HAR Dataset/test/subject_test.txt")

# extract labels
activity_labels <- setNames(activity_labels, c("activity_id", "activity"))
feature_labels <- unlist(features[,2])

# set columnnames
training_data <- setnames(training_data,c(feature_labels))
training_activities <- setNames(training_activities, c("activity_id"))
training_activities <- left_join(training_activities, activity_labels)
training_subjects <- setNames(training_subjects, c("subject_id"))

test_data <- setnames(test_data,c(feature_labels))
test_activities <- setNames(test_activities, c("activity_id"))
test_activities <- left_join(test_activities, activity_labels)
test_subjects <- setNames(test_subjects, c("subject_id"))

# combine datasets
training_raw <- cbind(training_subjects, training_activities, training_data)
test_raw <- cbind(test_subjects, test_activities, test_data)

#merge training- and test-dataset
complete_raw <- rbind(training_raw,test_raw)


#tidy dataset
complete_tidy <- complete_raw  %>% select(subject_id, activity, contains("mean") | contains("std"))

colnames(complete_tidy) <- gsub("\\(", "", colnames(complete_tidy))
colnames(complete_tidy) <- gsub("\\)", "", colnames(complete_tidy))
colnames(complete_tidy) <- gsub("-", "_", colnames(complete_tidy))
colnames(complete_tidy) <- gsub(",", "_", colnames(complete_tidy))

#compute mean of every column
complete_mean <- complete_tidy %>%
  group_by(subject_id,activity) %>%
  summarise(across(tBodyAcc_mean_X:fBodyBodyGyroJerkMag_std, mean, na.rm= TRUE))

#write final dataset
write.csv(complete_mean,"complete_mean.csv", quote=FALSE, row.names=FALSE)
