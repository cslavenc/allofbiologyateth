###################################################### Recap Ch 7, 17-04-2019 ##
## Not only the longest, but arguably also the most important chapter in the  ##
## book (for this course). During the lectures I elaborated on different types##
## of Sums of Squares, Mean Squares, F-values and R2, and how each of these   ##
## concepts are calculated, and relate to eachother.                          ##
##                                                                            ##
## We saw how simple linear regression (1 predictor and 1 outcome) can be     ##
## extended to multiple linear regression, and that there are different ways  ##
## in which we can include predictor variables into a model: hierarchical     ##
## (i.e. one-by-one, or sequential), or forced entry (all at the same time).  ##
## A third family of methods (step-wise procedures), is not recommended.      ##
##                                                                            ##
## After fitting any linear model it is important to assess:                  ##
##           1. How well the model fits the data in your sample               ##
##              - Check for potential outliers (a.o. standardized residuals)  ##
##              - Check for influential cases (a.o. Cook's distances)         ##
##                                                                            ##
##           2. How well the model generalizes beyond your sample             ##
##              - independence of errors (Durban Watson test)                 ##
##              - no multicollinearity among predictors (VIF values)          ##
##              - normally distributed errors & homoscedasticity (plot())     ##
##                                                                            ##
## At the very end, we briefly came across dummy coding that allows us to     ##
## extend the linear model to also be able to include categorical predictors. ##
## This, as we will see, lies at the foundation of all general linear models  ##
## (GLM; Ch 10 - 12) that we will look at in the remaining chapters.          ##
################################################################################

#### -----
## Clean up workspace, set working directory, load required packages
#### -----

  rm(list= ls())
  setwd("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/DSuR/Data")
  library(QuantPsyc)
  library(car)
  library(boot)
  library(ggplot2)
  library(pastecs)

## Source script with useful functions
  source("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/Own Scripts/Custom functions.R")
  
## Import & explore the main data used in Chapter 7
  album2<- read.delim("Album Sales 2.dat", header= T)

    head(album2)
    str(album2)
    summary(album2)
    
    # Explore with graphs (lazy option)
    scatterplotMatrix(~sales + adverts + airplay + attract,
                      col= "black", smooth= F,
                      regLine= list(method= lm, col= "red"), diagonal=T,
                      data= album2)
    # Explore with numbers
    round(stat.desc(album2, basic= F, norm= T), 3)


  gfr<- read.delim("GlastonburyFestivalRegression.dat", header= T)

    head(gfr)
    str(gfr)
      levels(gfr$music)
      gfr$music<- factor(gfr$music, levels= levels(gfr$music)[c(4, 1, 2, 3)])
    summary(gfr)
    
    # Explore with graphs (lazy option)
    scatterplotMatrix(~change + music,
                      col= "black", smooth= F,
                      regLine= list(method= lm, col= "red"), diagonal=T,
                      data= gfr)
    
    # Explore with numbers
    by(gfr$change, gfr$music, stat.desc, basic= F, norm= T)
    
    leveneTest(gfr$change, gfr$music)

#### -----
## Fitting a linear model
#### -----

## We fit a linear model using the lm() function
  albumSales.mod1<- lm(sales~ adverts + airplay + attract, data= album2)

## Let's look at the SS, MS and F values 
  anova(albumSales.mod1)
  
## Lets manually calculate R^2 (SS model/SS total)
  (433688 + 381836 + 45853) /(433688 + 381836 + 45853 + 434575)
  
## We can also e.g. calculate F for each predictor (MS model/MS residual)
  433688/2217     # F adverts
  381836/2217     # F airplay
   45853/2217     # F attract

## Look at the parameter estimates (b's) of the linear model
  summary(albumSales.mod1)

  # We can calculate t for each predictor (estimate/standard error)
  -26.612958/17.350001  # t intercept
    0.084885/0.006923   # t adverts
    3.367425/0.277771   # t airplay
   11.086335/2.437849   # t attract
   
  # We can also ask for confidence intervals around model parameters
    confint(albumSales.mod1)

## To get an idea of how strong the relative influence of the different
## predictors in the model is, we can calculate standardized parameters
## (we can also have a look at the t-values in the "summary()" output)
    lm.beta(albumSales.mod1)

#### -----
## Assessing model accuracy and generalizability
#### -----

## How well does the model fit the data in our sample (Cramming Sam's Tips 7.9.2)?
  # Outliers
    album2$res<- resid(albumSales.mod1)
    album2$stz.r<- rstandard(albumSales.mod1)

    # Potential outliers can be investigated using subsetting commands we
    # learned in Chapter 3, e.g.
      album2[abs(album2$stz.r)> 1.96, ] # 95%
      album2[abs(album2$stz.r)> 2.58, ] # 99%
      album2[abs(album2$stz.r)> 3, ]    # Outlier
    
  # Influential cases
    album2$stu.r<- rstudent(albumSales.mod1)      
    album2$cook<- cooks.distance(albumSales.mod1) # If greater than 1; inspect!
    album2$dfbeta<- as.data.frame.matrix(dfbeta(albumSales.mod1)) # Slightly
                                                                  # different
                                                                  # from book

    album2$dffit<- dffits(albumSales.mod1)
    album2$leverage<- hatvalues(albumSales.mod1)  # Compare to 2 or 3 * (k + 1)/n
    album2$stz.cvr<- covratio(albumSales.mod1)    # Look for 1 +/- 3 * average leverage
  # Again, you can use subsetting to e.g. identify potential influential cases
    album2[album2$cook> 1,]

## How well does the model generalize beyond the data in our sample?
  # Testing the assumption of indepent errors (Durban-Watson test)
    dwt(albumSales.mod1)        # Look for DW-values close to 2
  
  # Testing the assumption of no multicollinearity (VIF and tolerance)
    vif(albumSales.mod1)        # Values should be (well) below 10
    mean(vif(albumSales.mod1))  # Value should not be much greater than 1
  
  # Visual inspection of residuals
    # Quick view
      hist(album2$stz.r, main= "Standardized residuals")
      par(mfrow= c(2, 2)); plot(albumSales.mod1); par(mfrow= c(1, 1))
    
    # ggplot()
      multiplot(ggplot(album2, aes(stz.r)) + 
                  geom_histogram(aes(y= ..density..), fill= "white", col= "black") +
                  stat_function(fun= dnorm, args= list(mean(album2$stz.r, na.rm= T),
                                                       sd(album2$stz.r, na.rm= T)),
                                col= "blue", size= 1) +
                labs(x = "Standardized Residuals", y = "Density"),
                
                qplot(sample= album2$stz.r) +
                  geom_abline(intercept= 0, slope= 1, col= "red") +
                  labs(x= "Theoretical Values", y= "Observed Values"),
                
                ggplot(album2, aes(fitted(albumSales.mod1), stz.r)) +
                  geom_point() +
                  geom_hline(yintercept= 0, col= "black") +
                  geom_smooth(method= "lm", col= "blue",  fill= "blue") +
                  labs(x= "Fitted Values", y= "Standardized Residuals"),
                cols= 3)

#### -----
## Robust regression
#### -----

## If the assumption of normality is violated, we can use bootstrapping to perform
## a robust analysis
  # Three steps
    # Write the function to include in the bootstrap
      boot_lm<- function(formula, data, i){
                         d<- data[i,]
                         fit<- lm(formula, data= d)
                         return(coef(fit))
                         }

    # Plug into boot() function
      bootResults<- boot(statistic= boot_lm,
                         formula= sales ~ adverts + airplay + attract,
                         data= album2,
                         R= 5000)
    
    # Look at output and confidence intervals
      bootResults
      boot.ci(bootResults, type= "bca", index= 1, 0.95)
      boot.ci(bootResults, type= "bca", index= 2, 0.95)
      boot.ci(bootResults, type= "bca", index= 3, 0.95)
      boot.ci(bootResults, type= "bca", index= 4, 0.95)

#### -----
## Dummy coding categorical predictors (7.12)
#### -----

## Dummy coding allows us to construct a linear model that includes categorical
## predictor variables with more than 2 levels

## Let's look at the dataframe columns we're interested in, and explore data
  head(gfr[, c("music", "change")], 10)
  levels(gfr$music)
  
  # Visual representation of the question
  ggplot(gfr, aes(music, change)) +
         stat_summary(fun.y= mean, geom= "bar",
                      fill= c("red", rep("orange", 3)), alpha= 0.5) +
         stat_summary(fun.data= mean_cl_normal, geom= "errorbar", width= 0.2) +
         labs(x= "Music Affiliation", y= "Change in hygiene score")

## Explore the data with graphs
  # To do this "properly", we need a lot of code... 
  multiplot(ggplot(gfr[gfr$music== "No Musical Affiliation", ], aes(change)) +
              geom_histogram(aes(y= ..density..), col= "white") +
              stat_function(fun= dnorm,
                            args= list(mean(gfr[gfr$music== "No Musical Affiliation", "change"], na.rm= T),
                                       sd(gfr[gfr$music== "No Musical Affiliation", "change"], na.rm= T)),
                            col= "blue", size= 1),
            
            ggplot(gfr[gfr$music== "Crusty", ], aes(change)) +
              geom_histogram(aes(y= ..density..), col= "white") +
              stat_function(fun= dnorm,
                            args= list(mean(gfr[gfr$music== "Crusty", "change"], na.rm= T),
                                       sd(gfr[gfr$music== "Crusty", "change"], na.rm= T)),
                            col= "blue", size= 1),
            
            ggplot(gfr[gfr$music== "Indie Kid", ], aes(change)) +
              geom_histogram(aes(y= ..density..), col= "white") +
              stat_function(fun= dnorm,
                            args= list(mean(gfr[gfr$music== "Indie Kid", "change"], na.rm= T),
                                       sd(gfr[gfr$music== "Indie Kid", "change"], na.rm= T)),
                            col= "blue", size= 1),
            
            ggplot(gfr[gfr$music== "Metaller", ], aes(change)) +
              geom_histogram(aes(y= ..density..), col= "white") +
              stat_function(fun= dnorm,
                            args= list(mean(gfr[gfr$music== "Metaller", "change"], na.rm= T),
                                       sd(gfr[gfr$music== "Metaller", "change"], na.rm= T)),
                            col= "blue", size= 1, col= "red"),
            
            qplot(sample= scale(gfr[gfr$music== "No Musical Affiliation", "change"])) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            
            qplot(sample= scale(gfr[gfr$music== "Crusty", "change"])) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            
            qplot(sample= scale(gfr[gfr$music== "Indie Kid", "change"])) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            
            qplot(sample= scale(gfr[gfr$music== "Metaller", "change"])) +
              geom_abline(intercept= 0, slope= 1, col= "red"),
            cols= 2)
  
  # Numeric exploration
  by(gfr$change, gfr$music, stat.desc, basic= F, norm= T)
  
  leveneTest(gfr$change, gfr$music)

## Now, let's have a look at what R will do by default
  # We know our music factor has four different levels
  levels(gfr$music)
  # To see how R treats these different levels in a linear model, we use the
  # "contrasts()" function
  contrasts(gfr$music)

## Fit the model exactly the same as we would do for a continuous predictor
  gfr.mod1<- lm(change~ music, data= gfr)

## Look at SS, MS, F
  anova(gfr.mod1)

## Look at the parameter estimates
  summary(gfr.mod1)
  # The intercept is the mean of the reference group (No Music Affiliation),
  # while parameters represent differences in category means from this reference
  # group
  round(by(gfr$change, gfr$music, mean, na.rm= T), 3)

## We'll see plenty more of dummy coding in chapters to come, starting tomorrow