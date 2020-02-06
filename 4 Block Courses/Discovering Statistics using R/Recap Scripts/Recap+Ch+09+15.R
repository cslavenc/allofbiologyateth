################################################# Recap Ch 09 & 15 16-04-2019 ##
## Apart from looking for relationships between variables, we might also be   ##
## interested in differences between groups. Chapter 9 introduces the simplest##
## possible scenario of this: how to assess whether the mean values of two    ##
## groups are significantly different from each other.                        ##
##                                                                            ##
## In doing so, we saw it is important to distinguish between independent     ##
## (each datapoint represents a unique contribution to the sample) and        ##
## dependent (i.e. "matched", "paired", or "repeated-measures"; in which the  ##
## same individual contributes data to the two groups) study designs. We also ##
## learned how to correct the errorbars in barplots to correctly represent the##
## amount of variation in data stemming from a dependent study design, and how##
## to calculate effect sizes.                                                 ##
##                                                                            ##
## Chapter 15 (Section 15.4 & 15.5) introduced the non-parametric counterparts##
## of the independent t-test (Wilcoxon rank-sum test) and dependent t-test    ##
## (Wilcoxon signed-rank test).                                               ##
################################################################################

#### -----
## Preparations
#### -----

## Clean up workspace, set working directory, load required packages
  rm(list= ls())
  setwd("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/DSuR/Data")
  library(reshape)
  library(ggplot2)
  library(pastecs)
  library(car)

## Import the main dataset from Chapter 09
  spiderWide<- read.delim("SpiderWide.dat", header= T)
  spiderLong<- read.delim("SpiderLong.dat", header= T)

## Explore the data
  head(spiderWide)
  str(spiderWide)
  summary(spiderWide)

  head(spiderLong)
  str(spiderLong)
  summary(spiderLong)

## Source custom functions
  source("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/Own Scripts/Custom functions.R")

#### -----
## Comparing two means, data obtained from an independent study design
#### -----

## Create a plot to visually asses the hypothesis
  # Two (out of many) possibilities
  multiplot(ggplot(spiderLong, aes(Group, Anxiety)) +
              geom_boxplot(fill= "orange", alpha= .5) +
              stat_summary(fun.data= mean_cl_normal, geom= "errorbar",
                           col= "white", width= .1, lwd= 1) +
              stat_summary(fun.y= mean, geom= "point", col= "white", size= 3) +
              geom_jitter(width= .1, height= 0, col= "darkgrey") +
              labs(title= "Exploratory plot") +
              theme_bw() +
              theme(plot.title= element_text(hjust= 0.5)),
            ggplot(spiderLong, aes(Group, Anxiety)) +
              stat_summary(fun.y= mean, geom= "bar", fill= "orange",
                           col= "black", alpha= .5) +
              stat_summary(fun.data= mean_cl_normal, geom= "errorbar",
                           width= .1) +
              labs(title= "Barplot") +
              theme_bw() +
              theme(plot.title= element_text(hjust= 0.5)),
            cols= 2)

## Explore the data graphically
  # Plots to assess normality
  multiplot(ggplot(spiderWide, aes(picture)) +
              geom_histogram(aes(y= ..density..), fill= "black", col= "white")+
              stat_function(fun= dnorm, args= list(mean(spiderWide$picture),
                                                   sd(spiderWide$picture)),
                            col= "red", size= 1),
            ggplot(spiderWide, aes(real)) +
              geom_histogram(aes(y= ..density..), fill= "black", col= "white") +
              stat_function(fun= dnorm, args= list(mean(spiderWide$real),
                                                   sd(spiderWide$real)),
                            col= "red", size= 1),
            qplot(sample= scale(spiderWide$picture)) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            qplot(sample= scale(spiderWide$real)) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            cols= 2)

## Explore the data with numbers
  # Normality
  by(spiderLong$Anxiety, spiderLong$Group, stat.desc, basic= F, norm= T)
  
  # Homogeneity of variance
  leveneTest(spiderLong$Anxiety, spiderLong$Group)
  
## Peform the test
  # Since data meet parametric assumptions, we can use the independent t-test

    # If data are in long format, use:
    ind.t.test<- t.test(Anxiety~ Group, data= spiderLong)
    ind.t.test
  
    # If data are in wide format:
    ind.t.test<- t.test(spiderWide$picture, spiderWide$real)
    ind.t.test
    
    # Calculate the effect size
    rFromTtest(ind.t.test)
  
  # If we instead would have found that data don't meet parametric assumptions,
  # we learned in Ch 15 we could use the Wilcoxon rank-sum test
  
    # Long format
    ind.w.test<- wilcox.test(Anxiety~ Group, data= spiderLong)
    ind.w.test
    
    # Wide format
    ind.w.test<- wilcox.test(spiderWide$picture, spiderWide$real)
    ind.w.test
  
    # Effect size
    rFromWilcox(ind.w.test, 24)

#### -----
## Comparing two means, data stemming from a dependent study design
#### -----
  
## Create a plot to visually asses the hypothesis
  # We either connect individual points across groups, or we need to correct
  # the errorbars

  # For the first plot, we need to add a column with an individual identifier
  spiderLong$ID<- factor(c(rep(1:12, 2)))

  ggplot(spiderLong, aes(Group, Anxiety, col= ID)) +
    geom_jitter(width= .1, height= 0) +
    stat_summary(aes(group= ID), fun.y= identity, geom= "line") +
    labs(title= "Exploratory plot") +
    theme_bw() +
    theme(plot.title= element_text(hjust= 0.5))
  
  # For the second plot, use the function in R's Souls Tip 9.1 to adjust values
  # and combine with "stack()" to create data in long format for use in "ggplot()"
  # Let's visualise this adjusted plot alongside the default plot to compare
  
  spiderLong_Adj<- stack(rmMeanAdjust(spiderWide))
    names(spiderLong_Adj)<- c("Anxiety", "Group")
    
  multiplot(ggplot(spiderLong, aes(Group, Anxiety)) +
              stat_summary(fun.y= mean, geom= "bar", fill= "brown", alpha= .5) +
              stat_summary(fun.data= mean_cl_normal, geom= "errorbar",
                           width= 0.2) +
              labs(title= "Independent design", x= "Type of Stimulus",
                   y = "Anxiety") +
              theme_bw() +
              theme(plot.title= element_text(hjust= 0.5)) +
              coord_cartesian(ylim= c(0, 55)),
            ggplot(spiderLong_Adj, aes(Group, Anxiety)) +
              stat_summary(fun.y= mean, geom= "bar", fill= "brown", alpha= .5) +
              stat_summary(fun.data= mean_cl_normal, geom= "errorbar",
                           width= 0.2) +
              labs(title= "Dependent design", x= "Type of Stimulus",
                   y = "Anxiety") +
              theme_bw() +
              theme(plot.title= element_text(hjust= 0.5))+
              coord_cartesian(ylim= c(0, 55)),
            cols= 2)

## Explore the data graphically
  # For dependent designs, the distribution of the INDIVIDUAL DIFFERENCES
  # between the two treatments has to be normal

  spiderWide$Difference<- spiderWide$real - spiderWide$picture
  
  multiplot(ggplot(spiderWide, aes(Difference)) +
              geom_histogram(aes(y= ..density..), fill= "black", col= "white") +
              stat_function(fun= dnorm, args= list(mean(spiderWide$Difference),
                                                   sd(spiderWide$Difference)),
                            col= "red", size= 1),
            qplot(sample= scale(spiderWide$Difference)) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            cols= 2)
  
# Explore data with numbers
  # Normality
  round(stat.desc(spiderWide$Difference, basic= F, norm= T), 2)
  
  # No need for Levene's test!
  
## Peform the test
  # Since data meet parametric assumptions, we can use the independent t-test
  
  # If data are in long format, use:
  dep.t.test<- t.test(Anxiety~ Group, data= spiderLong, paired= T)
  dep.t.test
  
  # If data are in wide format:
  dep.t.test<- t.test(spiderWide$picture, spiderWide$real, paired= T)
  dep.t.test
  
  # Calculate the effect size
  rFromTtest(dep.t.test)
  
  # If we instead would have found that data don't meet parametric assumptions,
  # we learned in Ch 15 we could use the Wilcoxon signed-rank test
  
  # Long format
  dep.w.test<- wilcox.test(Anxiety~ Group, data= spiderLong, paired= T)
  dep.w.test
  
  # Wide format
  dep.w.test<- wilcox.test(spiderWide$picture, spiderWide$real, paired= T)
  dep.w.test
  
  # Effect size
  rFromWilcox(dep.w.test, 24) # Note that we use the number of observations in
                              # this function, NOT the number of participants!!
  