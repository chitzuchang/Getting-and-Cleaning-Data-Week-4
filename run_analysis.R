## Merge the training and test sets 

library(plyr)
library(data.table)

# Get the training set 
xtrain <- read.table("./UCI HAR Dataset 2/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset 2/train/y_train.txt")
subjecttrain <- read.table("./UCI HAR Dataset 2/train/subject_train.txt")

# Get the test set 
xtest <- read.table("./UCI HAR Dataset 2/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset 2/test/y_test.txt")
subjecttest <- read.table("./UCI HAR Dataset 2/test/subject_test.txt")

#read features and activity 
feature <- read.table("./UCI HAR Dataset 2/features.txt")
activity <- read.table("./UCI HAR Dataset 2/activity_labels.txt")

# combine the variable data set together 
x <- rbind(xtrain, xtest)
y <- rbind(ytrain, ytest)
subject <- rbind(subjecttrain, subjecttest)

# extract measurements on the mean and standard deviation for each measurement 
index <- grep("mean\\(\\)|std\\(\\)", feature[,2]) 
length(index)

x <- x[,index]

# rename the activities 
y[,1] <- activity[y[,1],2]

#getting name for variable 
names <- feature[index,2]

# rename the activities in the dataset 
names(x) <- names 
names(subject) <- "SubjectID"
names(y) <- "Activity"

# new data 
clean_data <- cbind(subject,y,x)

# creating data set with the average of each variable for each activity and each subject 
clean_data <- data.table(clean_data)
tidy <- clean_data[,lapply(.SD,mean),by = 'SubjectID,Activity']

# make and save new data 
write.table(tidy, file = "tidy_data.txt",row.name = FALSE)






