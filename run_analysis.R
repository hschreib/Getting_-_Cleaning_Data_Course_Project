# Load dplyr
library(plyr); library(dplyr); library(reshape2);
# Data
# For each record it is provided:
#     ======================================
#     
# (Intertial signals:)
# - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
# - Triaxial Angular velocity from the gyroscope.
#
# - A 561-feature vector with time and frequency domain variables. 
# - Its activity label. 
# - An identifier of the subject who carried out the experiment.


# Task:
# You should create one R script called run_analysis.R that does the following. 
# 
# Merges the training and the test sets to create one data set.
print ('Loading test data ... takes some time ...')
featuresList <- readLines("features.txt")
testDataSet <- read.table("./test/X_test.txt")
subjects <- scan("./test/subject_test.txt")
activities <- scan("./test/y_test.txt")
colnames(testDataSet) <- featuresList
testDataSet <- cbind(subjects,activities,testDataSet)
testDataSet$group <- "TEST"
testDataSet = testDataSet %>% select(group, everything())

print ('Loading train data.')
trainDataSet <- read.table("./train/X_train.txt")
subjects <- scan("./train/subject_train.txt")
activities <- scan("./train/y_train.txt")
colnames(trainDataSet) <- featuresList
trainDataSet <- cbind(subjects,activities,trainDataSet)
trainDataSet$group <- "TRAIN"
trainDataSet = trainDataSet %>% select(group, everything())

print ('Merging data.')
fullDataSet <- rbind(testDataSet, trainDataSet)

# Not requested but a prerequesite for arranging and sorting, if the original order shall be restored at one time.
# Solution taken from:
# http://stackoverflow.com/questions/16092239/r-how-to-add-row-index-to-a-data-frame-based-on-combination-of-factors

fullDataSet$index <- ave(1:nrow(fullDataSet),fullDataSet$subjects, fullDataSet$activities, FUN=seq_along)
# Bring to front 
fullDataSet = fullDataSet %>% select(index, everything())

# Extracts only the measurements on the mean and standard deviation for each measurement.
# There is also meanFreq etc. THe bracket is needed in the regular expression

print ('Extracts only the measurements.')
fullDataSet = select(fullDataSet, matches("index|group|subjects|activities|mean\\(|std\\("))

# Uses descriptive activity names to name the activities in the data set

fullDataSet$activities <- mapvalues(fullDataSet$activities, from = c(1,2,3,4,5,6), to = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
# Appropriately labels the data set with descriptive variable names. 
# Renaming columnnames by gsub. May not look nice to everybody, but see e.g. data from last R programming assignment.
# The full names of the labels are taken from features_info.txt
# Fast Fourier transformation is still too long
print ('Relabelling.')

names(fullDataSet) <- gsub(" f", ".fft.", names(fullDataSet))
names(fullDataSet) <- gsub(" t", ".time.", names(fullDataSet))
names(fullDataSet) <- gsub("Body", "body.", names(fullDataSet))
names(fullDataSet) <- gsub("Gravity", "gravity.", names(fullDataSet))
names(fullDataSet) <- gsub("Gyro", "gyro.", names(fullDataSet))
names(fullDataSet) <- gsub("Acc", "accelleration.", names(fullDataSet))
names(fullDataSet) <- gsub("Mag", "magnitude.", names(fullDataSet))
names(fullDataSet) <- gsub("Jerk", "jerk.", names(fullDataSet))
names(fullDataSet) <- gsub("-mean\\(\\)", "mean.", names(fullDataSet))
names(fullDataSet) <- gsub("-std\\(\\)", "standard.deviation.", names(fullDataSet))

# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
print ('Tidy dataset.')
fullDataSetTidy <- fullDataSet
# Melting
fullDataSetTidy$index <- NULL
fullDataSetTidy  <- melt (fullDataSetTidy, id=c("group", "subjects","activities"))
# Average
fullDataSetTidy$averages  <- ave(1:nrow(fullDataSetTidy),fullDataSetTidy$subjects, factor(fullDataSetTidy$activities), FUN=ave)
fullDataSetTidy$value <- NULL
#fullDataSetTidy <- select(fullDataSetTidy, matches("group|subjects|activities|averages"))
fullDataSetTidy <- unique(fullDataSetTidy)
rownames(fullDataSetTidy) = seq_along(fullDataSetTidy$averages)

# Not requested but saving the results of analyses makes perhaps some sense ...
print ('Save results.')
write.table(fullDataSet, file ="UCI_HAR_Dataset.txt", row.name=FALSE)
write.table(fullDataSetTidy, file ="UCI_HAR_DatasetTidy.txt", row.name=FALSE)
print ('Sucess.')
