################################################### Example script 05-04-2019 ##
## This script illustrates some basic R-functionality and offers tips to get  ##
## started and stay organised.                                                ##
##                                                                            ##
## There is no 'right or wrong' way to organise a script though, so feel free ##
## to develop your own scripting style. For example, as you will see the      ##
## author of the DSuR book (Andy Field) has a very different way in which he  ##
## organises his scripts than I do.                                           ##
################################################################################

#### -----
## It's good practice to always start with some basic house-keeping
#### -----

## Remove all objects from workspace
  rm(list= ls())

## Set the working directory
  # Windows-based machines
  setwd("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/DSuR/Data")
        # Notice the use of '\\' or '/' instead of a single '\'
  
  # OS-based machines (Mac)
  setwd("/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/DSuR/Data")
  
  # On either system: using the "Files" pane in the bottom-right window, in
  # combination with copy/paste, might be easiest
                                          
## If you have to, install a package (and all packages it depends on) to add new
## functionality (you only have to do this once on your own laptop; on the
## machines in the lecture room all packages used in this course are pre-installed)
  # install.packages("ggplot2", dependencies= T)

## Load required packages (this you will have to do every time you restart R and
## want to use a function from the package)
  library(ggplot2)

## In case we wanted help on how to use e.g. the 'sum()' function, we execute:
  ?sum

#### -----
## Let's do some very basic stuff (this is also on the lecture slides)
#### -----

## An overgrown calculator
  1 + 2

## Assign values 1 and 2 to objects a and b
	a<- 1
	b<- 2

## Create a new object c that is the sum of a and b, and look at it
	c<- a + b
	c

## Let's add all three objects together using a function
	sum(a, b, c)

## Let's combine some functions: take the square root of the sum of objects a,
## b, and c and assign the outcome to a new object D, and look at D
  D<- sqrt(sum(a, b, c))
  D                                 # Note that R is case-sensitive!                                     

## Look at all objects currently in the workspace (also in top-right window)
  ls()

## If we want to save these objects so that the next time we start R we don't
## have to execute all previous commands again, we can at any point execute:
  save.image("First R-session.Rdata")
  
  # To load all objects next time you start R
  load("First R-session.Rdata")

#### -----
## Getting data into R: manual entry
#### -----

## Follow from lecture slides
  Age<- c(22, 27, 24)                         # Numeric variable
  Name<- c("Ben", "Martin", "Carina")         # String variable (character)

  Sex<- c(2, 2, 1)                          
  Sex<- factor(Sex, levels= c(1:2),
               labels= c("Female", "Male"))   # Factor variable (categorical)

  DoB<- as.Date(c("1991-07-03", "1986-05-24",
                  "1989-06-21"))              # Date variable

## Create a dataframe from these variables
  students<- data.frame(Name, Sex, DoB, Age)
  students
  str(students)

#### -----
## Getting data into R: import existing files
#### -----
  
## Import from a .dat file (make sure your working directory is properly set!)
  lecturerData<- read.delim("Lecturer Data.dat", header= T)
  lecturerData
  str(lecturerData)
  head(lecturerData, 7)

## Correct the birth_date column, which is a date
  lecturerData$birth_date<- as.Date(lecturerData$birth_date, "%m/%d/%Y")

## Correct the job column, which is a factor with two levels
  lecturerData$job<- factor(lecturerData$job, levels= c(1:2),
                            labels= c("Lecturer", "Student"))
  
## Look at the structure of the lecturerData object again
  str(lecturerData)

#### -----
## Export data from R: e.g. to a .txt or .csv file in your working directory
#### -----
  write.table(lecturerData, "lecturerData.txt", sep= "\t", row.names= F)
  write.csv(lecturerData, "lecturerData.csv")
    
## Now, open the R script accompanying book Chapter 3, and read your way through
## Chapter 3 from section 3.9 onwards, while following along with the script
## from line 90 (marked as '#--------Selecting Data-----------').