

# 1) Merge the training and the test sets to create one data set.
# 2) Extract only the measurements on the mean and standard deviation for each measurement.
# 3) Use descriptive activity names to name the activities in the data set
# 4) Appropriately label the data set with descriptive variable names.
# 5) From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)
library(dplyr)
library(reshape2)
library(utils)

#set constants 
zipurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
ziplocal <- "dataset.zip"
subDir <- "UCI HAR Dataset"
topDir <- getwd()

#download and unzip the file to the working directory
download.file(zipurl,ziplocal) 
unzip(ziplocal) #automatically tests for existence of directory, creates if missing

#set the working directory to the unzipped file directory
setwd(paste0(topDir,"/",subDir))

#Read features.txt into an array
features <- readLines(con="features.txt")

#remove numbers from features list
features <- gsub("[0-9]+ ","",features)

#Remove parentheses, replace hyphens with underscores
cleanfeatures<-gsub("\\(","",features)
cleanfeatures<-gsub("\\)","",cleanfeatures)
cleanfeatures<-gsub("-","_",cleanfeatures)

rm(features)

#Read in the X data as text
xtest <- readLines(con="test/X_test.txt")
xtrain <- readLines(con="train/X_train.txt")

#clean repeating spaces, leading and trailing spaces
xtest <- trimws(xtest,"l")
xtrain <- trimws(xtrain,"l")
xtest <- gsub("  "," ",xtest)
xtrain <- gsub("  "," ",xtrain)

#read x data into data frames
xtestdf <- read.delim(text = xtest, sep = " ", colClasses = "numeric", header=FALSE, col.names = cleanfeatures)
xtraindf <- read.delim(text = xtrain, sep = " ", colClasses = "numeric", header=FALSE, col.names = cleanfeatures)

rm(xtest,xtrain)

#Strip out the unneeded columns from X
#the regular expression "mean[^\(]" will find instances of mean followed by something other than an open parentheses
testobs <- xtestdf[,grep("std()|mean()",cleanfeatures)]
trainobs <- xtraindf[,grep("std()|mean()",cleanfeatures)]

rm(xtestdf,xtraindf)

#Read in the subject data
testsubject <- read.delim("test/subject_test.txt", head=FALSE)
trainsubject <- read.delim("train/subject_train.txt",head=FALSE)

#Read in the y (activity) data
ytest<-read.delim("test/y_test.txt",head=FALSE,col.names = "id")
ytrain<-read.delim("train/y_train.txt",head=FALSE,col.names = "id")

#Use descriptive activity names to name the activities in the data set
activity <- read.delim("activity_labels.txt", head=FALSE,col.names=c("id","name"),sep=" ")
ytest2 <- join(ytest, activity, by = "id")
ytrain2 <- join(ytrain, activity, by = "id")

#Add y & subject columns to observation data
testobs["subject"] <- testsubject
testobs["activity"] <- ytest2$name
trainobs["subject"] <- trainsubject
trainobs["activity"] <- ytrain2$name

#merge the test & train datasets
allobs <- merge.data.frame(testobs,trainobs,all=TRUE,sort=FALSE)

rm(testobs,trainobs,ytest,ytrain,testsubject,trainsubject,activity,ytest2,ytrain2)

#create dataset with average of each variable for each activity and each subject

#get the number of measurement columns (total number minus the two factor columns Activity & Subject)
measures <- length(names(allobs))-2
#get a vector of measurement columns
measurevars <- names(allobs[1:measures])

#melt the dataset
meltedobs <-melt(allobs,id=c("subject","activity"),measure.vars=measurevars)

#use dcast to create a crosstab
meanobs<-dcast(meltedobs,subject~activity,mean)

#write the outputs to CSV files
write.csv(meanobs,file="..\\meansbydcast.csv",na="",quote=FALSE,row.names = FALSE)
write.table(meanobs,file="..\\meansbydcast.txt",na="",quote=FALSE, sep=" ",row.names=FALSE)