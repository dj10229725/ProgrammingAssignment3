library(reshape2)
#read in test data sets
subjecttest<-read.table("./UCI HAR Dataset/test/subject_test.txt")
xtest<-read.table("./UCI HAR Dataset/test/X_test.txt")
ytest<-read.table("./UCI HAR Dataset/test/Y_test.txt")

#read in train data sets
subjecttrain<-read.table("./UCI HAR Dataset/train/subject_train.txt")
xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("./UCI HAR Dataset/train/Y_train.txt")

#rename labels
names(subjecttest)<- "subjectid"
names(subjecttrain)<- "subjectid"

names(xtest)<-read.table("./UCI HAR Dataset/features.txt")[,2]
names(xtrain)<-read.table("./UCI HAR Dataset/features.txt")[,2]

names(ytest)<-"activity"
names(ytrain)<-"activity"

#combine data sets
train <- cbind(subjecttrain, ytrain, xtrain)
test <- cbind(subjecttest, ytest, xtest)
combined <- rbind(train, test)

#subseting data using column names that has mean and std
ColumnsNeeded<-c(
"subjectid"
,"activity"
,grep("mean\\(\\)",names(combined),value =  TRUE)
,grep("std\\(\\)",names(combined),value =  TRUE)
)

combinedsubset<-combined[,which(names(combined) %in% ColumnsNeeded)]


#change activity column values to factors
ActivityLabels<-read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
combinedsubset$activity <- factor(combinedsubset$activity, labels = ActivityLabels)



Rearange <- melt(combinedsubset, id=c("subjectid","activity"))
AverageByIDActivity <- dcast(Rearange, subjectid+activity ~ variable, mean)

names(AverageByIDActivity) <- gsub("[[:punct:]]","",names(AverageByIDActivity) )

write.table(AverageByIDActivity, "TidyDataOutput.txt", row.names=FALSE)
