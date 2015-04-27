###########################################################
### Course Project for "Getting & Cleaning Data" course ###
### Jeff Greinert   2015-04-26                          ###
###########################################################
run_analysis <- function() {

    # Set up the "widths" vector for read.fwf
    w <- vector("numeric", length=561)
    w <- replace(w, w==0, 16)
    
    # get Train data
    strn <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep=" ", header = FALSE)
    ytrn <- read.table("./UCI HAR Dataset/train/y_train.txt", sep=" ", header = FALSE)
    xtrn <- read.fwf("./UCI HAR Dataset/train/X_train.txt", widths=w, header=FALSE, n=7500, buffersize=400)  #Setting buffersize<500 prevents out-of-mem error
    
    # get Test data
    stst <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep=" ", header = FALSE)
    ytst <- read.table("./UCI HAR Dataset/test/y_test.txt", sep=" ", header = FALSE)
    xtst <- read.fwf("./UCI HAR Dataset/test/X_test.txt", widths=w, header=FALSE, n=3000, buffersize=400)   #Setting buffersize<500 prevents out-of-mem error
    
    # keep only the columns with mean() or std() values
    keepers <- grep("(mean\\(\\)|std\\(\\))", clabels[,2])  #list column indices that have "mean()" or "std()" in their name
    xtrn <- xtrn[,keepers]
    xtst <- xtst[,keepers]
    
    # add descriptive names (column labels)
    clabels <- read.table("./UCI HAR Dataset/features.txt", sep=" ", header = FALSE)
    names(strn) <- "subject"
    names(ytrn) <- "activity"
    names(xtrn) <- clabels[keepers,2]
    names(stst) <- "subject"
    names(ytst) <- "activity"
    names(xtst) <- clabels[keepers,2]
    
    # replace activity index with descriptive activity name
    actlabels <- read.table("./UCI HAR Dataset/activity_labels.txt", sep=" ", header = FALSE)
    actlabels[,2] <- tolower(actlabels[,2])
    actlabels[,2] <- sub("ing_","",actlabels[,2]); actlabels[,2] <- sub("stairs","",actlabels[,2])  #shorten "walking_upstairs" to "walkup", etc.
    numacts <- nrow(actlabels)
    for (i in 1:numacts) {
        ytrn <- as.data.frame(sapply(ytrn,function(x) gsub(actlabels[i,1],actlabels[i,2],x)))  #keep format as dataframe, instead of letting it change to matrix
        ytst <- as.data.frame(sapply(ytst,function(x) gsub(actlabels[i,1],actlabels[i,2],x)))  #keep format as dataframe, instead of letting it change to matrix
    }
    
    # consolidate all data
    trn <- cbind(strn,ytrn,xtrn)
    tst <- cbind(stst,ytst,xtst)
    alldat <- rbind(trn,tst)
    names(alldat) <- sub("\\(\\)","",names(alldat),)  #one last bit of cleanup: remove parens from names (column labels)
    
    # create tidy dataset of averages (means)
    smat <- matrix(0,nrow=30*6, ncol=1)
    amat <- matrix(0,nrow=30*6, ncol=1)
    mmat <- matrix(0,nrow=30*6, ncol=66)
    for (subj in 1:30) {
        for (acti in 1:numacts) {
            currow = ((subj-1)*numacts) + acti
            smat[currow,1] = subj
            amat[currow,1] = acti
            for (meas in 1:66) {
                mmat[currow, meas] = mean(alldat[(alldat$subject==subj & alldat$activity==actlabels[acti,2]),meas+2])
            }
        }
    }
    amat <- as.data.frame(amat)
    # replace activity index with descriptive activity name
    for (i in 1:numacts) {
        amat <- as.data.frame(sapply(amat,function(x) gsub(actlabels[i,1],actlabels[i,2],x)))  #keep format as dataframe, instead of letting it change to matrix
    }
    tidydat <- as.data.frame(cbind(smat,amat,mmat))
    # add descriptive names (column labels)
    names(tinydat) <- names(alldat)
    tidydat
}


