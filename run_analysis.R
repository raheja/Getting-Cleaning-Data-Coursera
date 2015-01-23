## This script is written for the Course Project of Data Science Course (JHU, Coursera- Getting and Cleaning Data). The functions of the 
## script are to do the following:

## 1. Merge the training and the test sets to create one data set.
## 2. Extract only the measurements on the mean and standard deviation for each measurement. 
## 3. Use descriptive activity names to name the activities in the data set
## 4. Appropriate labels for the data set with descriptive variable names. 
## 5. From the data set in step 4, to create a second, independent tidy data set with the average of each variable for each activity and each subject.

##  -------------------------------------------------##
## Though not needed for the current assignment, the following 5 commented lines will download and unzip the data into the dataset folder.

## library(downloader)
## url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## download(url,dest="dataset.zip" mode = "wb") 
## unzip ("dataset.zip",exdir = "./dataset")
## setwd("./dataset/UCI HAR Dataset/")

## 1.------------------------------------------------------------------------------------------------## 
# merge data from the 2 folders 

path_test <- ("./test")
path_train <- ("./train")

test_files <- list.files(path = path_test, pattern = '.txt') 
test_data <- do.call("cbind", lapply(paste(path_test, test_files, sep = "/"), read.table))

train_files <- list.files(path = path_train, pattern = '.txt')
train_data <- do.call("cbind", lapply(paste(path_train, train_files, sep = "/"), read.table))

merged_dataset <- data.frame(rbind(test_data, train_data))   # step 1 complete

feature_names <- read.table("features.txt", colClasses = c("NULL" ,"character"))   # reading in the feature names
Variable_names <- c("Subject_Id", feature_names$V2, "Activity_Id")
colnames(merged_dataset) <- make.names(Variable_names, unique = TRUE)   # assigning variable names to the dataset

## 2.------------------------------------------------------------------------------------------------## 
# extracts mean and std values for each observation

library(dplyr)
subset_data <- select(merged_dataset, contains(".mean"), contains(".std"), contains("Id"), -contains("meanFreq"))

## 3.------------------------------------------------------------------------------------------------## 

Activity_names <- read.table("activity_labels.txt", colClasses = c("integer", "character"))
subset_data$Activity_Id <- Activity_names$V2[match(subset_data$Activity_Id, Activity_names$V1)]

## 4.------------------------------------------------------------------------------------------------## 
# Descriptive variable names for each observation

colnames(subset_data) <- gsub(".mean...|.mean..", "_mean_", colnames(subset_data))
colnames(subset_data) <- gsub(".std...|.std..", "_std_", colnames(subset_data))
colnames(subset_data) <- gsub("tBodyAcc|tBodyBodyAcc", "Time_Domain_of_Body_Acceleration", colnames(subset_data))
colnames(subset_data) <- gsub("fBodyAcc|fBodyBodyAcc", "Freq_Domain_of_Body_Acceleration", colnames(subset_data))
colnames(subset_data) <- gsub("tGravityAcc", "Time_Domain_of_Gravitational_Acceleration", colnames(subset_data))
colnames(subset_data) <- gsub("tBodyGyro", "Time_Domain_of_Body_AngularVelocity", colnames(subset_data))
colnames(subset_data) <- gsub("fBodyGyro|fBodyBodyGyro", "Freq_Domain_of_Body_AngularVelocity", colnames(subset_data))


## 5.------------------------------------------------------------------------------------------------## 
# Calculate aggregate for each variable by Subject Id and Activity Id

group_mean_data<-summarise_each(group_by(subset_data, Activity_Id, Subject_Id),funs(mean))   # calculate average by groups

write.table(group_mean_data, file = "Samsung_tidy_dataset.txt", row.names = FALSE)  # write the dataset into a file in the current folder.

