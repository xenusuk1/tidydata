# set home to the UCI HAR Dataset directory
#
library("dplyr")

# read test data sets
testdata <- read.table("test/X_test.txt", header=FALSE)
testposition <- read.table("test/y_test.txt", header=FALSE)
testsubject <- read.table("test/subject_test.txt",header=FALSE)

# add dataset column
testdata$dataset <- "test"

# add subject column
colnames(testsubject) <- "subject"
testdata <- cbind(testdata,testsubject)

# add position column
colnames(testposition) <- "position"
testdata <- cbind(testdata,testposition)

# read train data sets
traindata <- read.table("train/X_train.txt", header=FALSE)
trainposition <- read.table("train/y_train.txt", header=FALSE)
trainsubject <- read.table("train/subject_train.txt",header=FALSE)

# add dataset column
traindata$dataset <- "train"

# add subject column
colnames(trainsubject) <- "subject"
traindata <- cbind(traindata,trainsubject)

# add position column
colnames(trainposition) <- "position"
traindata <- cbind(traindata,trainposition)

# merge test and train data
alldata <- rbind(testdata,traindata)

# read column names into table
features <- read.table("features.txt",header=FALSE)

# name the alldata columns
colnames(alldata) <- features$V2


#  select only those items that have mean() or std() in name & 3 extras
good <- grep("mean\\(\\)|std\\(\\)", features$V2, value = FALSE)
good[67] <- 562
good[68] <- 563
good[69] <- 564
alldata2 <- alldata[,good]

# clean up names list
betternames <- gsub("\\(\\)","",names(alldata2))
betternames <- gsub("-","",betternames)
betternames <- tolower(betternames)
betternames[67]= "dataset"
betternames[68]= "subject"
betternames[69]= "position"

# apply to dataset
colnames(alldata2) <- betternames

# replace activity code with name from activity labels
actlabel <- read.table("activity_labels.txt", header=FALSE)

alldata2$activity <- actlabel$V2[alldata2$position]

# create summary table
tidydata <- summarise_each(group_by(alldata3,activity,subject),funs(mean), -position, -dataset)

# save table
write.csv(tidydata, file="tidydata.csv", row.names = FALSE)
