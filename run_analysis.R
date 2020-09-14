#load packages
packages <- c("data.table")
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


# set columnnames
activity_labels <- setNames(activity_labels, c("activity_id", "activity"))
features <- setNames(features, c("feature_id", "feature"))
training_activities <- setNames(training_activities, c("activity_id"))

# combine datasets
training_raw <- cbind(training_subjects, training_activities, training_data)
test_raw <- cbind(test_subjects, test_activities, test_data)

# tidy datasets
