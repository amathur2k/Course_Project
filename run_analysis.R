library("dplyr")
##Load All the Data
X_train <- read.table("train/X_train.txt")
Y_train <- read.table("train/Y_train.txt")
subject_train <- read.table("train/subject_train.txt")

X_test <- read.table("test/X_test.txt")
Y_test <- read.table("test/Y_test.txt")
subject_test <- read.table("test/subject_test.txt")

test_data <- cbind(subject_test, Y_test, X_test)
train_data <- cbind(subject_train, Y_train, X_train)

##Step 1: Merges the training and the test sets to create one data se
data <- rbind(train_data, test_data)

features <- as.vector(read.table("features.txt")$V2)
features <- append(features, c("Subject", "Activity"), after = 0 )
features <- make.names(features, unique=TRUE, allow_ = TRUE)

##Step 4: Appropriately labels the data set with descriptive variable names.
names(data) <- features

## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
## Get the columns with mean and std
data <- select(data, Subject, Activity, contains("mean"), contains("std"))

activity_labels <- read.table("activity_labels.txt")
names(activity_labels) <- c("Activity.Id", "Activity.Name")

##Step 3: Uses descriptive activity names to name the activities in the data set
data <- merge(data, activity_labels, by.x="Activity", by.y="Activity.Id")
data <- select(data, -Activity)[c(1, 88, 2:87)]

##Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
grouped <- group_by(data, Subject, Activity.Name)
means <- summarise_each(grouped, funs(mean))
vNames <- names(means[3:88])
vNames <- paste("MeanOf_", vNames, sep="")
vNames <- c("Subject", "Activity.Name", vNames)
names(means) <- vNames

##Write out the Tidy (?) Data
write.table(means, file = "tidyData.txt", row.names = FALSE)



