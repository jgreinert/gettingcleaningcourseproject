++++++++++++++++++++++++++++++++++++++++++++++++++++++++
README for run_analysis.R
Course Project for "Getting & Cleaning Data" course
Jeff Greinert   2015-04-26
++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--------
OVERVIEW
--------
The run_analysis.R function uses data from the Samsung UCI HAR Dataset, which contains data collected from various tests using the Samsung Galaxy S phone.  See the README and other files that are included with that dataset for details on those data.

The run_analysis.R function reads the "subject_", "X_", and "y_" data from both the test and train folders, discards irrelevant columns, calculates the mean values of the remaining data, and outputs the result into a tidy dataset.

--------------------
FUNCTION DESCRIPTION
--------------------
run_analysis.R performs these functions, in this order:
* The "X_" files have 561 columns of real values evenly spaced with a fixed width of 16-characters.  We set up a "widths" vector of the number 16 repeated 561 times, to be used by the read.fwf function.
* Read the "subject_", "X_", and "y_" data from both the test and train folders.
* We will only use the "X_" data columns that are described as being "mean" or "std" values, indicated by the strings "mean()" or "std()" in their name.  Keep these (66 columns), and discard all other columns.
* The "features.txt" file, included with the dataset, contains descriptive names for each column.  Use those names in our dataframes.  Also, apply descriptive names to the "subject_" and "y_" dataframes.
* The data that we read contains test results from 6 different activities.  Replace the data's activity index (1-6) with a more descriptive version taken from the "activity_labels.txt" file, included with the data.  Shorten and format them to make tidier names:
       Original               Tidier
	   ------------------     --------
       WALKING                walking
	   WALKING_UPSTAIRS       walkup
	   WALKING_DOWNSTAIRS     walkdown
	   SITTING                sitting
	   STANDING               standing
	   LAYING                 laying
* Consolidate everything into one dataframe ("alldat"), organized into columns as follows:
		subject   activity   tBodyAcc-mean-X   tBodyAcc-mean-Y   tBodyAcc-mean-Z   tBodyAcc-std-X   (etc...)
		-------   --------   ---------------   ---------------   ---------------   --------------   -----...
	***NOTE that, for tidy data, it is recommended that names be all lower case and contain no dashes or underbars.  My "tidy" names do contain some uppercase characters and some dashes, to make it easier for the reader to differentiate between other similarly-named columns.
* Create a tidy dataset ("tidydat") of the averages (means) of each data variable for each activity and each subject.  Use the same naming convention as we did for the full dataset, "alldat".

