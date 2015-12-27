### loading/reading files 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "ProjectData.zip")
unzip("ProjectData.zip")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

# merge the "test" and "train" datasets in complete ones ("full")
X_full <- rbind(X_test, X_train)
y_full <- rbind(y_test, y_train)
subject_full <- rbind(subject_test, subject_train)

### extract means and SD of each measurement (specific columns)
mean_columns <- grep("mean()", features[,2], fixed = TRUE)
std_columns <- grep("std()", features[,2], fixed=TRUE)

columns_of_interest <- c()

for (i in 1:33){
  columns_of_interest <- c(columns_of_interest, mean_columns[i], std_columns[i])
} # this loop creates a vector of the columns of the mean of a measurment, followed by the respective SD

othermean_columns <- setdiff(grep("mean", features[,2], ignore.case = TRUE), mean_columns) #measurements of means that do not include an associated STD
columns_of_interest <- c(columns_of_interest, othermean_columns)
features[columns_of_interest, 2] -> features_of_interest #labels of the variables

X_means_std <- X_full[,columns_of_interest] # subsetting only the mean and SD measurements

# descriptive column names, and labels of activity and subject
names(X_means_std) <- features_of_interest # names of columns (variables: measurement type)
X_means_std$Activity <- y_full$V1
X_means_std$Subject <- subject_full[,1]

### creating a tidy data matrix
X_means_std$Zipline <- paste(X_means_std$Activity, X_means_std$Subject, sep=" ") #this creates a sort of unique identifier

X_means_std <- X_means_std[order(X_means_std$Activity, X_means_std$Subject),] #just reordering the rows
unique_ziplines <- unique(X_means_std$Zipline) #ordered from the last command

n <- length(unique_ziplines) #number of unique combination of subject and activity
m <- length(X_means_std) #number of columns
X_means_std <- X_means_std[c(m, (m-2), (m-1), 1:(m-3))] #just reordering the columns

tidy_matrix <- matrix(0, n, (m-1)) #skeleton of the tidy data matrix

for(i in 1:n){ 
  #this first loop creates a temporary dataframe with rows that have the same zipline (subject and activity)
  zip_result <- X_means_std[X_means_std$Zipline == unique_ziplines[i],] # 
  zip_compound <- c(zip_result$Activity[1], zip_result$Subject[1]) #inserting the subject and activity
  
    for(j in 4:m){
      #this loop calculates the mean for all the measurements/columns (with same zipline),
      #except the 1st 3 columns (zipline, activity and subject)
      zip_compound <- c(zip_compound, mean(zip_result[,j])) 
    }  
    tidy_matrix[i,] <- zip_compound 
}

# creating tidy data frame
variable_names <- names(X_means_std)[4:m] #extracting names of parameters from data
tidy_data <- as.data.frame(tidy_matrix)
names(tidy_data) <- c("Activity", "Subject", variable_names)
tidy_data$Activity <- activity_labels[match(tidy_data$Activity, activity_labels[,1]), 2] #replacing activity numeric labels for descriptive labels

# exporting the tidy data frame
write.table(tidy_data, file="tidy_data.txt", row.names = FALSE)
