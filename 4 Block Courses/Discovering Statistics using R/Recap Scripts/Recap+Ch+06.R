###################################################### Recap Ch 6, 12-04-2019 ##
## Chapter 6 is all about measuring relationships between variables, i.e.     ##
## correlation analyses. We saw that a standardised version of the covariance ##
## the Pearson correlation coeffcient, can be calculated to express the degree##
## of association in a manner that is unaffected by the unit of measurement.  ##
##                                                                            ##
## If one or more of the parametric assumptions of Ch 5 are not met, we saw we##
## can calculate one of two non-parametric correlation coefficients:          ##
## Spearman's rho or Kendall's tau.                                           ##
##                                                                            ##
## All three of these correlation coefficients, however, can only measure the ##
## relationship between two variables, i.e. they are bivariate statistics.    ##                             ##
##                                                                            ##
## If interested in measuring relationships between more than two variables,  ##
## we learned that partial correlation looks at the association between two   ##
## variables while controlling for the effects of a third variable on both.   ##
## Semi-partial correlation controls for the effect that a third variable has ##
## on only one of the variables in the correlation. This is useful when trying##
## to explain the variance in a particular variable (an outcome) from a set of##
## predictor variables, which is what regression analyses (Ch 7) is all about.##
##                                                                            ##
## Yesterday afternoon, three issues popped up with those of you that already ##
## worked your way through (parts of) Chapter 6:                              ##
## - In using the rcorr() function, we have to specify which library to use   ##
## - Occasionally there's a warning message about exact p-values              ##
## - To be able to calculate correlation coefficients between one or more     ##
##   categorical variables, we have to 'force' R to temporarily treat them as ##
##   numeric variables.                                                       ##
################################################################################

#### -----
## Housekeeping
#### -----

  rm(list= ls())
  setwd("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/DSuR/Data")
  library(pastecs)
  library(Hmisc)
  library(ggplot2)
  library(boot)
  library(polycor)
  library(ggm)                  # Note warning message about "rcorr()"
  library(car)

## Import the main datasets used in Chapter 6
  examData<- read.delim("Exam Anxiety.dat",  header= T)
  liarData<- read.delim("The Biggest Liar.dat", header= T)
  catData<- read.csv("pbcorr.csv")
  
## Explore the data
  head(examData)
  str(examData)
  summary(examData)
  # For the purposes of this chapter we only consider three columns
  examData<- examData[, c("Exam", "Anxiety", "Revise")]
  
  head(liarData)
  str(liarData)
  summary(liarData)
  # In this chapter, we only use the first two columns
  liarData<- liarData[, c(1, 2)]
  # Position is an ordinal variable, so tell R to treat it as a factor
  liarData$Position<- factor(liarData$Position,
                             labels= c("1st", "2nd", "3rd", "4th", "5th", "6th"))

  head(catData)
  str(catData)
  summary(catData)
  # Both gender and recode are factors, so we tell R to treat them as such
    catData$gender<- factor(catData$gender, levels= c(0:1),
                            labels= c("Female", "Male"))
    catData$recode<- factor(catData$recode, levels= c(0:1),
                            labels= c("Male", "Female"))

## As promised yesterday: a "bonus trick" to make any previously made functions
## available for use in the current R-session
  source("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/Own Scripts/Custom functions.R")

#### -----
## Parametric: Pearson's correlation coefficient
#### -----

## Visualise the relationships of interest
  # Scatterplots of two continuous variables
  multiplot(ggplot(examData, aes(Anxiety, Exam)) +
              geom_point() +
              geom_smooth(method= "lm", fill= "blue"),
            ggplot(examData, aes(Revise, Exam)) +
              geom_point() +
              geom_smooth(method= "lm", fill= "blue"),
            ggplot(examData, aes(Anxiety, Revise)) +
              geom_point() +
              geom_smooth(method= "lm", fill= "blue"),
            cols= 3)

## Explore data with plots
  # Check normality of distribution
  multiplot(ggplot(examData, aes(Exam))+
              geom_histogram(aes(y= ..density..), fill= "black", col= "white") +
              stat_function(fun= dnorm, args= list(mean(examData$Exam, na.rm= T),
                                                   sd(examData$Exam, na.rm= T)),
                            col= "red", size= 1) +
              labs(x= "Exam Performance", y= "Density"),
            ggplot(examData, aes(Anxiety))+
              geom_histogram(aes(y= ..density..), fill= "black",col= "white") +
              stat_function(fun= dnorm, args= list(mean(examData$Anxiety, na.rm= T),
                                                   sd(examData$Anxiety, na.rm= T)),
                            col= "red", size= 1) +
              labs(x= "Exam Anxiety", y= "Density"),
            ggplot(examData, aes(Revise))+
              geom_histogram(aes(y= ..density..), fill= "black",col= "white") +
              stat_function(fun= dnorm, args= list(mean(examData$Revise, na.rm= T),
                                                   sd(examData$Revise, na.rm= T)),
                            col= "red", size= 1) +
              labs(x= "Revision Time", y= "Density"),
            qplot(sample= scale(examData$Exam)) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            qplot(sample= scale(examData$Anxiety)) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            qplot(sample= scale(examData$Revise)) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            cols= 2)
  
## Explore data with numbers, e.g.
  round(stat.desc(examData, basic= F, norm= T), 2)
  
## Data in our sample deviate from normality but given large n (and for the sake
## of the example!), we can still assume the sampling distribution is normal
## anyway, according to the central limit theorem (n> 30).
##    => parametric test

## Calculate Pearson's correlation coefficient (3 options)
  # cor() function
    cor(examData)
    # To get the coefficients of determination (in percentages, with 2 digits)
    round(cor(examData)^2 * 100, 2)

  # rcorr() function (requires a matrix as input).
  # Also, we have to specify to use the rcorr() function in the Hmisc package
    ?rcorr
    Hmisc::rcorr(as.matrix(examData))

  # cor.test() function
    cor.test(examData$Anxiety, examData$Exam)
    cor.test(examData$Revise, examData$Exam)
    cor.test(examData$Anxiety, examData$Revise)

#### -----
## Non-parametric: Spearman or Kendall's correlation coefficient
#### -----

## Let's remind ourselves of the liarData
  str(liarData)
  # We are interested in the relationship between a continuous variable and an
  # ordinal variable, and thus violate the assumption that variables should be
  # measured at least at the interval level => non-parametric correlation

## Visualise the relationship of interest
 multiplot(ggplot(liarData, aes(as.numeric(Position), Creativity)) +
             geom_point() +
             geom_smooth(method= "lm", col="brown", fill= "brown") +
             labs(title= "Scatterplot",
                  x= "Position"),
           ggplot(liarData, aes(Position, Creativity)) +
             geom_boxplot(fill= "brown") +
             labs(title= "Boxplot -probably better-"),
           cols= 2)

## Either, calculate Spearman correlation coefficient (3 options)...
  cor(as.numeric(liarData$Position), liarData$Creativity, method= "spearman")

  Hmisc::rcorr(cbind(as.numeric(liarData$Position), liarData$Creativity),
               type= "spearman")

  cor.test(as.numeric(liarData$Position), liarData$Creativity,
           method = "spearman")     # The warning message just lets us know that
                                    # R returns an approximation of the
                                    # significance of rho (we can ignore this)

## ... or Kendall's correlation coefficient (2 options)
  cor(as.numeric(liarData$Position), liarData$Creativity, method= "kendall")

  cor.test(as.numeric(liarData$Position), liarData$Creativity,
           method= "kendall")

#### -----
## Bootstrapping correlations
#### -----

## Three-step process
  # Write a function to calculate, e.g. Kendall's tau
    boot_tau<- function(liarData, i){
                   cor(as.numeric(liarData$Position[i]), liarData$Creativity[i],
                   use= "complete.obs", method= "kendall")
                   }
  
  # Plug function into the boot() function
    b.kendall.t<- boot(liarData, boot_tau, 5000)
  
  # Look at output and confidence intervals calculated by boot.ci().
  # Out of the 4 different bootstrapped confidence intervals we get, the
  # Bias-Corrected accelerated (BCa) intervals are accurate in a wide variety
  # of data scenario's, so we could decide to report these estimates
    b.kendall.t
    b.kendall.ci<- boot.ci(b.kendall.t, .95)
    b.kendall.ci
    
  # We can also visualise our bootstrap sampling distribution, along with the
  # observed value and 95% BCa confidence intervals
    ggplot(data.frame(b.kendall.t$t), aes(b.kendall.t.t)) +
      geom_density(fill= "green", alpha= .2) +
      geom_vline(xintercept= b.kendall.t$t0, col= "red") +
      geom_vline(xintercept= c(b.kendall.ci$bca[4], b.kendall.ci$bca[5]),
                 col= "blue", lty= 3) +
      labs(y= "Density", x= "Kendall's tau")

#### -----
## Biserial and point-biserial correlations
#### -----

## Look at data again
  str(catData)
  
  # A relationship between a continuous variable and a binomial variable.
  # If we consider the binomial variable to be a strict dichotomy, we can use
  # Pearson's correlation coefficient (if other variable meets the assumptions
  # of Ch 5!), and this is sometimes also called the point-biserial correlation
  # coefficient.
    
  # If we consider the binomial cariable to reflect an underlying continuum,
  # we can calculate the biserial correlation coefficient. This is very rarely
  # done though, so don't worry about this.
    
## Visualise the relationship
  # Let's go a little crazy here, and draw a hybrid graph of a boxplot,
  # linegraph, and scatterplot all in one!!
  multiplot(ggplot(catData, aes(gender, time)) +
              geom_boxplot(fill= "orange", alpha= .5) +
              stat_summary(fun.data= mean_cl_normal, geom= "errorbar", width= .2,
                           col= "white") +
              stat_summary(fun.y= mean, geom= "line", aes(group= 1),
                           col= "blue") +
              stat_summary(fun.y= mean, geom= "point", size= 3, col= "white") +
              geom_jitter(width= .2, col= "darkgrey"),
            ggplot(catData, aes(recode, time)) +
              geom_boxplot(fill= "orange", alpha= .5) +
              stat_summary(fun.data= mean_cl_normal, geom= "errorbar", width= .2,
                           col= "white") +
              stat_summary(fun.y= mean, geom= "line", aes(group= 1),
                           col= "blue") +
              stat_summary(fun.y= mean, geom= "point", size= 3, col= "white") +
              geom_jitter(width= .2, col= "darkgrey"),
            cols= 2)

## Point-biserial correlation (treat gender as a distinct dichotomy)
## This is exactly the same as a Pearson correlation anylysis (as well as an 
## independent t-test, Chapter 9!!)
  cor.test(catData$time, as.numeric(catData$gender))
  cor.test(catData$time, as.numeric(catData$recode))  # Note how sign flipped!

## Biserial correlation (treat gender as a dichotomy with an underlying
## continuum; e.g. because there were some neutered male cats in the sample)
  polyserial(catData$time, catData$gender)
  # To calculate a p-value for this is a bit more of an involved process, see
  # section 6.5.8 for details, but don't worry about this!

#### -----
## Part and partial correlation
#### -----

## Partial correlation (correlation between variable 1 and 2, controlling for
## the effect of additional variable(s) on both variable 1 and 2)
  pc<- pcor(c("Exam", "Anxiety", "Revise"), var(examData))
  pc
  # For coefficient of determination
  pc^2
  # For significance test
  pcor.test(pc, 1, 103)

## Semi-partial (or part) correlation underlies regression analyses: Chapter 7!!
