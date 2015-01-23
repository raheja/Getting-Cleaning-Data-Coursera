This script is written for the Course Project of Data Science Course (JHU, Coursera- Getting and Cleaning Data). The functions of the script are to do the following:

1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set
4. Appropriate labels for the data set with descriptive variable names. 
5. From the data set in step 4, to create a second, independent tidy data set with the average of each variable for each activity and each subject.

-------------------------------------------------
Though not needed for the current assignment, the following 5 commented lines will download and unzip the data into the dataset folder.

1. library(downloader)
2. url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
3. download(url,dest="dataset.zip" mode = "wb") 
4. unzip ("dataset.zip",exdir = "./dataset")
5. setwd("./dataset/UCI HAR Dataset/")

-------------------------------------------------
In section 1, we define the paths of the 2 folders from where we are collecting the data (lines 22 and 23). For each folder,
we list the files having a '.txt' extension, read them using read.table and cbind them to get the data of subject, activity and variables together for both test and train datasets. Finally, we merge the datasets using rbind to create one dataset.
Subsequently, we assign the names of the variables using information given in the features.txt file.

-------------------------------------------------
In setion 2, using the library dplyr, we select columns that contain the word "mean", "std", "Id" (i.e. mean signals, std of signals, and subject + activity id). We omit any other variable that may contain the word mean, ("meanFreq") but is not required for the assignment.

-------------------------------------------------
In section 3, we read in the Activity.txt file, and use the descriptive names to match and replace the Activity Ids

-------------------------------------------------
In section 4, we assign descriptive names for each variables using the function gsub. 

-------------------------------------------------
Finally, in section 5, we again use the library dplyr, functions 'summarise_each' and 'group_by', to calculate the average of each variable by grouping the dataset by the activity id and the subject id.
