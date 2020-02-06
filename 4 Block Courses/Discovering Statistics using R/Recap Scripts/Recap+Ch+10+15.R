################################################ Recap Ch 10 + 15, 18-04-2019 ##
## In this chapter we saw how the linear model (regression) can be extended to##
## also allow for categorical predictor variables with more than two levels.  ##
## In this respect it is the first of three chapters (10 - 12) that cover the ##
## topic of General Linear Models (GLM). Chapter 10 contains quite a bit of   ##
## theory, a lot of which will hopefully be familiar by now.                  ##
##                                                                            ##
## The main novelty is that GLMs allow us to explicitly specify which         ##
## comparisons we want to make when interested in differences between the     ##
## levels of a predictor variable that consists of more than two groups. To do##
## so, we learned how to define contrasts driven by biological hypotheses. If ##
## a priori we don't have any explicit predictions that we want to test, we   ##
## saw that we can follow up the initial linear model with post-hoc pairwise  ##
## comparisons that control for the increased risk of Type I errors due to    ##
## multiple comparisons (i.e. reduce the family-wise error rate).             ##
##                                                                            ##
## Chapter 10 treats the simplest possible scenario of a GLM (analogous to    ##
## multiple regression with two dummy variables), in which we include one     ##
## predictor variable in the linear model and data come from an independent   ##
## study design (i.e. different entities in each group). This type of GLM is  ##
## often referred to as a one-way independent ANOVA.                          ##
################################################################################

#### -----
## Preparations
#### -----

## As always: clean up workspace, set working directory, load required packages
  rm(list= ls())
  setwd("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/DSuR/Data")
  library(ggplot2)
  library(car)
  library(pastecs)
  library(multcomp)
  library(compute.es)

  # For non-parametric follow-up analyses after a Kruskal-Wallis test
  library(pgirmess)
  library(clinfun)

## Let's manually create the dataframe (been a while since we last did this)
## We could do this as follows:
  viagraData<- data.frame(id= c(1:15),
                          libido= c(3, 2, 1, 1, 4, 5, 2, 4, 2, 3, 7, 4, 5, 3, 6),
                          dose= gl(3, 5,labels= c("Placebo", "Low Dose", "High Dose")))

## Source script with custom functions
  source("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/Own Scripts/Custom functions.R")
  
#### -----
## Explore the data
#### -----

## Data structure & simple descriptives
  head(viagraData)
  str(viagraData)
  summary(viagraData)

## Visualise data in a way that always us to assess hypothesis
  ggplot(viagraData, aes(dose, libido)) +
    stat_summary(fun.y= mean, geom= "line", col= "red", aes(group= 1)) +
    stat_summary(fun.data= mean_cl_boot, geom= "errorbar", width= 0.15) +
    stat_summary(fun.y= mean, geom= "point", size= 4) +
    labs(x= "Dose of Viagra", y= "Mean Libido")

## Explore data with graphs
  multiplot(ggplot(viagraData[viagraData$dose== "Placebo", ], aes(libido)) +
              geom_histogram(aes(y= ..density..), col= "white") +
              stat_function(fun= dnorm,
                            args= list(mean(viagraData[viagraData$dose== "Placebo", "libido"], na.rm= T),
                                       sd(viagraData[viagraData$dose== "Placebo", "libido"], na.rm= T)),
                            col= "blue", size= 1),
            
            ggplot(viagraData[viagraData$dose== "Low Dose", ], aes(libido)) +
              geom_histogram(aes(y= ..density..), col= "white") +
              stat_function(fun= dnorm,
                            args= list(mean(viagraData[viagraData$dose== "Low Dose", "libido"], na.rm= T),
                                       sd(viagraData[viagraData$dose== "Low Dose", "libido"], na.rm= T)),
                            col= "blue", size= 1),
            ggplot(viagraData[viagraData$dose== "High Dose", ], aes(libido)) +
              geom_histogram(aes(y= ..density..), col= "white") +
              stat_function(fun= dnorm,
                            args= list(mean(viagraData[viagraData$dose== "High Dose", "libido"], na.rm= T),
                                       sd(viagraData[viagraData$dose== "High Dose", "libido"], na.rm= T)),
                            col= "blue", size= 1),
            
            qplot(sample= scale(viagraData[viagraData$dose== "Placebo", "libido"])) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            
            qplot(sample= scale(viagraData[viagraData$dose== "Low Dose", "libido"])) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            
            qplot(sample= scale(viagraData[viagraData$dose== "High Dose", "libido"])) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            cols= 2)

## Explore data with numbers
  # Normality
  by(viagraData$libido, viagraData$dose, stat.desc, basic= F, norm= T)
  # Homogeneity
  leveneTest(viagraData$libido, viagraData$dose)

## Also, let's explore our categorical predictor variable in a bit more detail
## (since that is the main novelty of this chapter!)
  # To look at the different groups, and the order in which they are sorted
  levels(viagraData$dose)
  # To look at the comparisons R will make by default if we plug our categorical
  # variable as a predictor into a linear model
  contrasts(viagraData$dose)

#### -----
## Construct model and illustrate different contrasts and post hoc procedures
## (you would normally only construct one of these models, but for the sake of
## the example, I here elaborate on 4 possible scenarios)
#### -----

## Scenario 1
## Construct linear model as we are used to and look at outcome of default dummy
## coding
  viagraDefault<- lm(libido~ dose, data= viagraData)
  anova(viagraDefault)
  summary(viagraDefault) # By default the b's for an (unordered) factor represent:
                         # b0= mean of the baseline group
                         # b1= difference between baseline group and group 1
                         # b2= difference between baseline group and group 2
  
## Check assumptions (these statistics don't change, regardless of contrasts):
  # How well does our model fit the data?
    # Outliers
      viagraData$res<- resid(viagraDefault)
      viagraData$stz.r<- rstandard(viagraDefault)
    # Influential cases
      viagraData$cook<- cooks.distance(viagraDefault)
      viagraData$dfbeta<- as.data.frame.matrix(dfbeta(viagraDefault))
      viagraData$dffit<- dffits(viagraDefault)
      viagraData$leverage<- hatvalues(viagraDefault)
      viagraData$stz.cvr<- covratio(viagraDefault)
  
  # To get a quick first impression, at least check the following
  viagraData[abs(viagraData$stz.r)> 1.96 ,]        # No outliers at 95% level
  viagraData[viagraData$cook> 1, ]                 # No influential cases
  
  # How well does our model generalize beyond our sample?
  hist(viagraData$stz.r)                           # Normality of residuals
  par(mfrow= c(2, 2)); plot(viagraDefault)         # Normality/linearity/homoscedasticity
  dwt(viagraDefault)                               # Independence of residuals
  # We don't have to check for multicollinearity: 1 predictor!!

## Scenario 2  
## Now, if we had two specific hypothesis, we could have manually defined a
## priori contrasts in R (using weights) that allow us to test these hypotheses

  # Look at the contrasts of the predictor variable again
  contrasts(viagraData$dose)

  # Overwrite default contrasts with manually defined contrasts
  contrasts(viagraData$dose)<- cbind(Placebo.vs.Viagra= c(-2,  1, 1),
                                     Low.vs.HighViagra= c( 0, -1, 1))

  # Look at new contrasts of the predictor variable
  contrasts(viagraData$dose)
  str(viagraData)                   # Contrasts appear as attributes to a column

## Construct a new linear model
  viagraPlanned<- lm(libido~ dose, data= viagraData)
  anova(viagraPlanned)
  summary(viagraPlanned)
  
  # Now, the b's represent our hypotheses as follows:
    # b0= grand mean:
    mean(viagraData$libido)
    # b1= difference between Viagra and Placebo, divided by the number of groups
    #     in contrast 1:
    (mean(viagraData$libido[viagraData$dose!= "Placebo"]) -
     mean(viagraData$libido[viagraData$dose== "Placebo"])) /3
    # b2= difference between High and Low Viagra, divided by the number of groups
    #     in contrast 2:
    (mean(viagraData$libido[viagraData$dose== "High Dose"]) -
     mean(viagraData$libido[viagraData$dose== "Low Dose"])) /2
  
## Scenario 3
## Alternatively, we might have predicted a linear trend in the group means in
## which case we could have defined our contrasts as a (linear) trend
## (it is very important to have the levels ordered in a meaningful way!!)

  # Assign polynomial contrast to predictor variable
  contrasts(viagraData$dose)<- contr.poly(3)

  # These contrasts look weird, but weights are set to test for a linear and
  # quadratic trend in this case
  contrasts(viagraData$dose)

## Construct a new linear model
  viagraTrend<- lm(libido~ dose, data= viagraData)
  anova(viagraTrend)
  summary(viagraTrend)  # Now, the beta's test different order polynomial lines
                        # for their fit through the group means
                        # b0= grand mean
                        # b1= linear trend (L)
                        # b2= quadratic trend (Q)

## To reset contrasts to the default (dummy coding)
  contrasts(viagraData$dose)<- NULL
  contrasts(viagraData$dose)
  str(viagraData)

## Scenario 4
## If we did not have any explicit predictions prior to data-collection, instead
## of setting contrasts we could have resorted to post-hoc comparisons, after
## fitting the linear model

  # We would then report overall significance of the model
  anova(viagraDefault)

  # Perform pairwise comparisons, controlling the familywise error using e.g.
  # Bonferroni... 
  pairwise.t.test(viagraData$libido, viagraData$dose, p.adjust.method= "bonferroni")
  # ... or general false discovery rate
  pairwise.t.test(viagraData$libido, viagraData$dose, p.adjust.method= "fdr")

  # Or, we can choose an other procedure such as Tukey or Dunnett, executing:
  postHoc.Tukey<- glht(viagraDefault, linfct= mcp(dose= "Tukey"))
  summary(postHoc.Tukey)
  confint(postHoc.Tukey)

  postHoc.Dunnett<- glht(viagraDefault, linfct= mcp(dose= "Dunnett"), base= 1)
  summary(postHoc.Dunnett)
  confint(postHoc.Dunnett)

#### -----
## Non-parametric alternatives
#### -----
  
## If Levene's test is significant we can calculate an alternative version of
## the F-statistic (Welch's F, see also Ch 9 for independent t-test). This is
## still a parametric test!
  viagraWelch<- oneway.test(libido~ dose, data= viagraData)
  viagraWelch

## We could also use bootstrapping (same R-code as in Ch 7)
 
## Non-parametric one-way independent ANOVA; Kruskal-Wallis test (Ch 15)
  # Perform the omnibus test
  kruskal.test(libido~ dose, data= viagraData)
  by(rank(viagraData$libido), viagraData$dose, mean) # Report the mean ranks for
                                                     # each group
  
  # Follow-up with a non-parametric linear trend analysis...
  jonckheere.test(viagraData$libido,
                  as.numeric(viagraData$dose),
                  nperm= 5000)      # Expects grouping variable to be numeric,
                                    # or an ordered factor:
                                    # "factor(vigraData$dose, ordered= T)"
  
  # ... or perform post-hoc multiple comparisons
  kruskalmc(libido~ dose, data= viagraData)       # All pairwise comparisons
  kruskalmc(libido~ dose, data= viagraData,       # Only comparisons to baseline
            cont= "two-tailed")                   # (less strict critical value)
  