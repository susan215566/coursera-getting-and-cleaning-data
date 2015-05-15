## step 1
# read relative data 
test.labels<-read.table("test/y_test.txt", col.names="labels")
test.subjects<-read.table("test/subject_test.txt",col.names="subject")
test.data<-read.table("test/X_test.txt")
train.labels<-read.table("train/y_train.txt", col.names="labels")
train.subjects<-read.table("train/subject_train.txt", col.names="subject")
train.data<-read.table("train/X_train.txt")
# merge the trian and test data into one dataset
data <- rbind(cbind(test.subjects, test.labels, test.data),
              cbind(train.subjects, train.labels, train.data))
# take a look at the data
head(data,n=2)
str(data)
'data.frame':        10299 obs. of  563 variables:
        $ subject: int  2 2 2 2 2 2 2 2 2 2 ...
$ labels : int  5 5 5 5 5 5 5 5 5 5 ...

# read the features
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
# look at the structure of features
str(features)
head(features)
tail(features)
# extract mean and sd measurement
features.mean.sd <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]
str(features.mean.sd)
# merge the data and the features
data.mean.sd <- data[, c(1, 2, features.mean.sd$V1+2)]
head(data.mean.sd,n=2)
str(data.mean.sd)
##step 3
# read the activity labels
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
# replace labels in data with label names
data.mean.sd$label <- labels[data.mean.sd$label, 2]
str(data.mean.sd)
## step 4
# first make a list of the current column names and feature names
good.colnames <- c("subject", "label", features.mean.sd$V2)
# then tidy that list
# by removing every non-alphabetic character and converting to lowercase
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))
# then use the list as column names for data
colnames(data.mean.sd) <- good.colnames

## step 5
# find the mean for each combination of subject and label
aggr.data <- aggregate(data.mean.sd[, 3:ncol(data.mean.sd)],
                      by=list(subject = data.mean.sd$subject,
                              label = data.mean.sd$label),
                       mean)

## final step 
# write a new tidy set into a text file called tidy2.txt
write.table(format(aggr.data, scientific=T), "tidy2.txt",
            row.names=F, col.names=F, quote=2)