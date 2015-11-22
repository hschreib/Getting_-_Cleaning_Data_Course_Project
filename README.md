# Getting_-_Cleaning_Data_Course_Project
The project is part of the Coursera Getting & Cleaning Data Course. It constists of a R source file processing the different steps in cleaning up the UCI_HAR_Dataset (see http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) available from . 

# The R script
The script run_analysis.R should be located in the same folder as the unzipped data set, together with the features.txt file. The evaluated data comes from the https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip . Note that not all data is processed by the analyis. The respective intertial signals are ignored.

It processed the data in the following way:

-Merges the training and the test sets to create one data set.
-Extracts only the measurements on the mean and standard deviation for each measurement. 
-Uses descriptive activity names to name the activities in the data set
-Appropriately labels the data set with descriptive variable names. 
-From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# The Code Book
The code book describes the features of the tidy data set as it appears from the resulting file UCI_HAR_DatasetTidy.txt that is the outcome of run_analysis.R.

 

