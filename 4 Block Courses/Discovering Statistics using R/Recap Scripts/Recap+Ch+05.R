###################################################### Recap Ch 5, 11-04-2019 ##
## Yesterday we looked at the 4 main assumptions of parametric tests based on ##
## the normal distribution. We primarily focussed on how to assess whether a  ##
## response variable of interest follows the normal distribution, and whether ##
## the variance of this response variable is equal across the range of values ##
## of another (i.e. predictor) variable (homogeneity of variance).            ##
##                                                                            ##
## We saw that data can suffer from several complications: outliers, non-     ##
## normality, and/or heterogeneity of variance, and we explored ways to deal  ##
## with this:                                                                 ##
## - outliers can either be removed (Chapter 4), set to missing values (NA) or##
##   their impact reduced by transforming the data                            ##
## - deviations from normality or unequal variances across levels of a        ##
##   predictor variable can sometimes be overcome by transforming the data    ##
##                                                                            ##
## If this doesn't solve the problem, we learned of alternative ways in which ##
## to analyse the data:                                                       ##
## - non-parametric tests (treated in each subsequent chapter along with their##
##   respective parametric equivalent)                                        ##
## - robust methods (we will only focus on bootstrapping, more in Ch 06 & 7)  ##
##                                                                            ##
## At the very end of the chapter, we are offered some clever tricks to deal  ##
## with missing values.                                                       ##
################################################################################

#### -----
## As always, start by cleaning up the workspace, setting the working directory
## and loading all required packages
#### -----

## Clean working environment, set working directory and load packages
  rm(list= ls())
  setwd("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/DSuR/Data")
  library(car)
  library(ggplot2)
  library(pastecs)
  library(psych)

## Import the two datasets used throughout Chapter 5
  dlf<- read.delim("DownloadFestival.dat", header= T)
  rexam<- read.delim("rexam.dat", header= T)

## Exlore the two datasets to make sure all is as we want it to be
  head(dlf)
  str(dlf)
  summary(dlf)
  # This immediately reveals an outlier on day1
  
  head(rexam)
  str(rexam)
  summary(rexam)
  # The str() function shows us that the uni column is not recognised as a
  # factor, so let's correct this and assign labels
    rexam$uni<- factor(rexam$uni, levels= c(0:1), labels=
                       c("Duncetown University", "Sussex University"))

#### -----
## The assumption of normality
#### -----

## Visual exploration
  # Density histogram of scores + normal probability distribution
    hist.day3<- ggplot(dlf, aes(day3)) +
                geom_histogram(aes(y= ..density..), fill= "orange", col= "black") +
                stat_function(fun= dnorm, args= list(mean(dlf$day3, na.rm= T),
                                                     sd(dlf$day3, na.rm= T)),
                              col= "blue", size= 1) +
                labs(x= "Hygiene score on day 3", y= "Density")
    hist.day3

  # Q-Q plot
    qqplot.day3<- qplot(sample= dlf$day3) # Note that the "stats" argument is no
    qqplot.day3                           # longer supported/required!
    
## A remark to the qqplots we get by default from ggplot2 (actually some of you
## already asked me about this yesterday!). Typically qq-plots visualise the
## observed and theoretical quantiles on the same scale of measurement, i.e.
## z-scores. This really helps to recognise the diagonal line we are looking for,
## as the units on the x and y axes are identical.
## To achieve this in ggplot2, we can use the "scale()" function, which converts
## each observation to a z-score for us.
    qqplot.day3<- qplot(sample= scale(dlf$day3)) +
                    geom_abline(intercept= 0, slope= 1, col= "red")
    qqplot.day3
    
## Or, using multiplot (if we sourced a script containing this function -see line 44-)
    multiplot(hist.day3, qqplot.day3, cols= 2)
  
## Also, somebody asked why, in constructing the histogram,  we now use
## geom_histogram(aes(y= ..density..), while in Ch 4 we used geom_density()
  # Let's compare the two in the same plot to see the difference:
  hist.compare<- ggplot(dlf, aes(day3)) +
            geom_histogram(aes(y= ..density..), fill= "orange", col= "black") +
            geom_density(fill= "blue", alpha= 0.5) +
            labs(x= "Hygiene score on day 3", y= "Density")
  hist.compare
  
## Quantifying normality with numbers
  # One response variable
    describe(dlf$day3)
    stat.desc(dlf$day3, basic= F, norm= T)
  
  # Multiple response variables with rounding to 2 decimals (for stat.desc())
    describe(cbind(dlf$day1, dlf$day2, dlf$day3))
    describe(dlf[ , c("day1", "day2", "day3")])   # Note: column names in output
    describe(dlf[ , c(3:5)])                      # Being lazy pays off!!

    round(stat.desc(cbind(dlf$day1, dlf$day2, dlf$day3), basic= F, norm= T), 2)
    round(stat.desc(dlf[, c("day1", "day2", "day3")], basic= F, norm= T), 2)
    round(stat.desc(dlf[, c(3:5)], basic= F, norm= T), 2)
  
  # Multiple response variables for multiple groups
    by(rexam[, c("exam", "computer", "lectures", "numeracy")], rexam$uni,
       describe)
    by(rexam[, c("exam", "computer", "lectures", "numeracy")], rexam$uni,
       stat.desc, basic= F, norm= T)

## Shapiro-Wilk test of normality
  # Using the dedicated function for one variable
    shapiro.test(rexam$exam)
  # Combining it with by() for multiple groups
    by(rexam$exam, rexam$uni, shapiro.test)
  # As implemented in stat.desc() we can even perform this test for multiple
  # variables and different groups
    by(rexam[, c("exam", "computer", "lectures", "numeracy")], rexam$uni,
       stat.desc, basic= F, norm= T)

#### -----
## The assumption of homogeneity of variance
#### -----

## Levene's test, using the default centring on the median which is preferable
## Note that Levene's test only works for a categorical predictor variable
  leveneTest(rexam$exam, rexam$uni)

## Always interpret Levene's test in combination with the Variance Ratio (VR)   
    by(rexam$exam, rexam$uni, var, na.rm= T)
    max(by(rexam$exam, rexam$uni, var, na.rm= T))/
    min(by(rexam$exam, rexam$uni, var, na.rm= T))
    # Compare to critical value in Figure 5.8 (p. 189 in book)
    #    n groups= 2, n observations per group= 50)~ 2

#### -----
## Correcting problems in the data
#### -----

## Outliers: always try to understand what may have gone wrong, or what may have
## been special about this particular case, look for a biological explanation
    
  # 1) Remove case by deleting the entire row (Ch4)
    dlf.nO<- dlf[dlf$day1<= 4, ]
    dlf.nO<- subset(dlf, day1<= 4)
  
  # 2) Set value(s) to NA (this maintains the row in the dataframe)
    dlf$day1<- ifelse(dlf$day1 > 4, NA, dlf$day1)
    
  # 3) PLEASE, DON'T REPLACE THE VALUE WITH THE MOST EXTREME VALUE + 1, OR THE
  #    MEAN +/- 2SD, OR WHATEVER! 
    
  # 4) Transform the data -see below-

## Non-normality and heterogeneity of variance
  # Log-transformation
    dlf$logday1<- log(dlf$day1 + 1)     # Add the 1 if you have zeros in observations
                                        # as log(0) is not defined
  # Square root transformation
    dlf$sqrtday1<- sqrt(dlf$day1)
    
  # Reciprocal transformation
    dlf$recday1<- 1/(dlf$day1 + 1)      # Add the 1 if you have zeros in observations
                                        # as you can't divide by 0

#### -----
## Handling missing values (R Soul's tip 5.4: mistake in book!!)
#### -----

## Say we want to calculate a mean hygiene score for each person at the festival,
## we could do this in 3 different ways:

  # 1) Only calculate the mean for individuals without missing values (3 scores)
  #    (drawback: very few individuals remain)
    dlf$meanHygiene.noNA<- rowMeans(cbind(dlf$day1, dlf$day2, dlf$day3))

  # 2) Calculate for each person with at least one score
    dlf$meanHygiene.1sc<- rowMeans(cbind(dlf$day1, dlf$day2, dlf$day3), na.rm= T)

  # 3) Calculate for each person with at least two scores
    # a) Create a "counter" for the number of missing values (NA's)
      dlf$daysMissing<- rowSums(cbind(is.na(dlf$day1),
                                      is.na(dlf$day2),
                                      is.na(dlf$day3)))

    # b) Use the "counter" to specify a conditional statement with ifelse()
      dlf$meanHygiene.2sc<- ifelse(dlf$daysMissing > 1, NA,
                                   rowMeans(cbind(dlf$day1,
                                                  dlf$day2,
                                                  dlf$day3),
                                            na.rm= T))
