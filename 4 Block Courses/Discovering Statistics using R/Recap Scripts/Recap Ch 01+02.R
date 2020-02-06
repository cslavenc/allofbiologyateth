################################################## Recap Ch 1 & 2, 05-04-2019 ##
## The main point I want you to take from Chapters 1 & 2 is the concept of    ##
## 'error' and how it is calculated in most of the statistical models we will ##
## encounter during the course. We came across the terms 'deviation', 'sums of##
## squares', 'variance' and 'standard deviation' and saw that they all express##
## the inaccuracy of a statistical model (in this case the mean).             ##
##                                                                            ##
## This script uses R to explain these concepts one more time, and also       ##
## creates a figure like Fig. 2.4 in the book, based on the height data you   ##
## provided.                                                                  ##
##                                                                            ##
## NOTE:                                                                      ##
## The code to create the figure at the end is quite advanced, so only try to ##
## understand it if everything else so far has been relatively easy for you   ##
## and you want an extra challenge! Next week we'll look at how to make graphs##
## in R in much more detail, and we will encounter the package ggplot2 used to##
## make this figure.                                                          ##
################################################################################

#### -----
## Housekeeping
#### -----

## Remove any objects from workspace
  rm(list= ls())

## Set the working directory (using the "Files" pane in bottom-right window)
  setwd("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/Varia")

## Load library to make plots
  # install.packages("ggplot2", dep= T)
  library(ggplot2)

## Import data
  students<- read.csv("BIO 209 Students 2019.csv")

#### -----
## Explore and correct the data
#### -----
  
## Look at the data, and correct import errors
  students
  head(students, 7)
  tail(students, 10)
  summary(students)
  str(students)
  # Correct format for DoB
    students$DoB<- as.Date(students$DoB, "%d/%m/%Y")
  
  # Re-order the levels of Stats & R-experience (R's Souls' Tip 3.13)
    levels(students$StatsExperience)
    students$StatsExperience<- factor(students$StatsExperience,
                                      levels= levels(students$StatsExperience)[c(2, 3, 1)])
    levels(students$RExperience)
    students$RExperience<- factor(students$RExperience,
                                  levels= levels(students$RExperience)[c(3, 1, 2)])

#### -----
## Add mean height and the deviations of all students to dataframe
#### -----
    
## Add a new column in which we store the mean height
  students$Mean<- mean(students$Height)

## Add another column in which we store the deviations (i.e difference from the
## mean for each student)
  students$Deviation<- students$Height - students$Mean

## Look at the dataframe to see whether it worked
  View(students)

#### -----
## Calculate SS, var and sd from the dataframe
#### -----
  
## Square the deviations and store in a new column
  students$SquaredDeviation<- students$Deviation^2
  
## Sum these up to get the Sum of Squares
  Height.SS<- sum(students$SquaredDeviation)
  Height.SS   # i.e. the total variability in the data
  
## From this we can calculate the variance, as well as the standard deviation
  # Divide SS by the degrees of freedom
  Height.var<- Height.SS/(nrow(students[!is.na(students$Height), ]) - 1)
  Height.var  # i.e. the typical variability of each datapoint in units squared
  
  # Take square root of the variance
  Height.sd<- sqrt(Height.var)
  Height.sd   # i.e. the typical variability of each datapoint
  
## Check whether these values are correct using R base functions
  # Variance
    var(students$Height)
  # Standard deviation
    sd(students$Height)

#### -----
## Graphically display deviations and annotate graph.
## (don't worry about the code just yet)
#### -----

  ggplot(students, aes(Nr, Height, col= Gender)) +
    geom_segment(aes(x= Nr, y= Height, xend= Nr, yend= Mean), lty= 3,
                 show.legend= F) +
    geom_hline(yintercept= mean(students$Height)) +
    geom_point(size= 3) +
    annotate("text",
             x= students$Nr + 0.5,
             y= students$Mean + 0.5 * students$Deviation,
             label= round(students$Deviation, 2), size= 3) +
    labs(x= "Student", y= "Height (in m)") +
    theme_classic()
    