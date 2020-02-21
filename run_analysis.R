library(dplyr) 

x_train   <- read.table("./train/X_train.txt")
y_train   <- read.table("./train/y_train.txt")
subject_train   <- read.table("./train/subject_train.txt")

x_test   <- read.table("./test/X_test.txt")
y_test   <- read.table("./test/y_test.txt")
subject_test   <- read.table("./test/subject_test.txt")

features <- read.table("./features.txt") 
activity_labels <- read.table("./activity_labels.txt") 

#1. Merges the training and the test sets to create one data set.

x_total   <- rbind(x_train, x_test)
y_total   <- rbind(y_train, y_test) 
sub_total <- rbind(subject_train, subject_test) 

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
sel_features <- grep(".*mean\\(\\)|std\\(\\)", features[,2])
x_total      <- x_total[,sel_features]


#3. Uses descriptive activity names to name the activities in the data set
colnames(x_total)   <- grep(".*mean\\(\\)|std\\(\\)", features[,2], value=TRUE)
colnames(y_total)   <- "activity"
colnames(sub_total) <- "subject"

total <- cbind(sub_total, y_total, x_total)

#4.Appropriately labels the data set with descriptive variable names.

total$activity <- factor(total$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
total$subject  <- as.factor(total$subject) 

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
total_mean <- total %>% group_by(activity, subject) %>% summarize_all(mean) 


write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE) 