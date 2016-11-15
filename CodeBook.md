#CodeBook for Getting & Cleaning Data project

##Codebook Requirements
* describes the variables, the data, and any transformations or work that you performed to clean up the data
* indicate all the variables and summaries calculated, along with units

##Data Description
The data is a set of 3-axial linear acceleration and 3-axial angular velocity measurements gathered by 30 subjects for six activities using a smartphone accelerometer. The Readme.txt file contained in the source zip file contains complete information. Measurements are in standard gravity units.

##Transformations Performed
1. Zip file is downloaded and unzipped
2. List of features is imported and cleaned for use as column headers, and subsetted to incude only Mean and Standard deviation values.
3. Subject and Activity data are imported as vectors. Activity data is changed to a descriptive factor.
4. Measurement data is imported as a character symbol and cleaned for transformation by removing leading whitespace, trailing whitespace and double-spaces between numers.
5. A new dataframe is created using the features vector to decide which columns to include.
6. Subject and Activity data are added to the dataframe.
7. Test & Training datasets are merged together.
8. After melting the dataset, dcast creates a crosstab (results in: meansbydcast.csv)

##Summaries Calculated
###Complete Variable List (in order of appearance in script)
* zipurl: character constant indicating the URL for the original zip data file
* ziplocal: character constant designating the local name of the zip file
* subDir: character constant designating the subdirectory created when unzipping the zip file
* topDir: character variable capturing the current working directory
* features: character vector of the column names in the original dataset
* cleanfeatures: character vector of cleaned column names
* xtest/xtrain: character symbols storing contents of measurements file for test data
* xtestdf/xtraindf: data frames of measurement data
* testobs/trainobs: data frames of only the measurements needed for this project
* testsubject/trainsubject: character vectors of subject data
* ytest/ytrain: character vectors of activity data
* ytest2/ytrain2: character vectors of descriptive activity data
* allobs: merged test & training data
* meltedobs: melted version of allobs
* grouped: grouped version of meltedobs
* avgobs: summarized grouped dataset
* measures: number of measurement columns in allobs
* measurevars: character vector of the names of the measurement columns
* meanobs: crosstab of subject, activity with mean of measurements as values