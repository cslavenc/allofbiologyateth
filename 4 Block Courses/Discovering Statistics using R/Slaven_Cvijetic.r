# Exam: Script for DSuR exam - VERSION A

getwd()
wdpath = "C:/Users/made_/Desktop/ETH/4 Block Courses/Discovering Statistics using R/DSuR/Data"
setwd(wdpath)  # LOCATION OF DATASETS

library(ggplot2)
library(multcomp)  # for glht()
library(lme)
library(nlme)
library(car)
library(pastecs)
library(compute.es)
library(reshape)
library(clinfun)
library(MASS)
library(QuantPsyc)
library(boot)
library(polycor)
library(ggm)
library(psych)
library(misc)
library(outliers)

# user-defined functions
effectSize <- function(t, df) {
  r <- sqrt(t^2/(t^2 + df))
  return(r)
}


# Exercise 1 ----
guanData <- read.delim("Guanaco.txt", header = T)

describe(guanData$NonMatingSeason)
describe(guanData$MatingSeason)

plot(guanData)  # scatterplot
hist(guanData$NonMatingSeason)  # histograms
hist(guanData$MatingSeason)
par(mfrow = c(1,1))
boxplot(guanData$NonMatingSeason, guanData$MatingSeason)

# leveneTest
leveneTest(guanData$MatingSeason, guanData$NonMatingSeason, center = "mean")  # significant, variances not the same in the two groups

# test correlation
cor.test(guanData$NonMatingSeason, guanData$MatingSeason, method = "pearson") # spearman is also n.s.

# perform dependent t.test
fm1 <- t.test(guanData$MatingSeason, guanData$NonMatingSeason, paired = T,
              data = guanData, alternative = "two.sided")  # signficant: p = 0.042
summary(fm1)
fm1

fm1estimate <- fm1$estimate   # means
fm1params   <- fm1$parameter  # df
tstat       <- fm1$statistic  # t
pval        <- fm1$p.value    # p value
confints    <- fm1$conf.int   # 0 not included! => this is good!

r <- effectSize(tstat, fm1params)
MatingSE<- sd(guanData$MatingSeason)/sqrt(sum(!is.na(guanData$MatingSeason)))
NonmatingSE <- sd(guanData$NonMatingSeason)/sqrt(sum(!is.na(guanData$NonMatingSeason)))

# report results:
# On average, there is an increase in testosterone during mating seasons, leading to an
# increased distance (M = 3.254, SE = 0.1918692), than during non-mating season
# (M = 2.718, SE = 0.1905128). This difference was
# significant t(9) = 2.365873, 0.063 > .05 and it did represent a medium-sized
# effect r = 0.619.

# Conclusion: The difference was very signficant for a threshold alpha = 5%
# and there is a strong effect size r > 0.5, suggesting that we have found a biologically
# existent and important fact.




# Exercise 2 ----
tickData <- read.delim("Tick.dat", header = T)

describe(tickData$Temp)
describe(tickData$Hours)

plot(tickData)  # scatter plot
par(mfrow = c(1,2))
hist(tickData$Temp, main = "Histogram of Temperature")
hist(tickData$Hours, main = "Histogram of Hours")
boxplot(tickData$Temp, tickData$Hours)

# make graph
line   <- ggplot(tickData, aes(Bites, Temp))
errbar <- stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2)
point  <- stat_summary(fun.y = mean, geom = "point", size = 3)
line2  <- stat_summary(fun.y = mean, geom = "line", size = 1, aes(group=1))
line + errbar + point + line2


# ancova with Hours being the covariate (confounding effect)
leveneTest(tickData$Temp, tickData$Bites, center = "mean")  # n.s.
leveneTest(tickData$Hours, tickData$Bites, center = "mean") # n.s.

tickData$Bites <- factor(tickData$Bites, levels = c(0:2),
                         labels = (c("No Bites", "less than 5 bites", "more than 5 bites")))
contrasts(tickData$Bites) <- contr.helmert(3)

fit.cov <- aov(Hours ~ Bites, data = tickData)
summary(fit.cov)  # n.s.
Anova(fit.cov, type = "III")

tickcov <- ggplot(tickData, aes(Bites, Hours)) + geom_point(size = 3)
tickstat <- geom_smooth(method = "lm", alpha = 0.4)
tickcov + tickstat

# continue with interaction between covariate and predictor


fit.1 <- aov(Temp ~ Hours*Bites, data = tickData)  # bites and hours significant, not their interaction

# alternative approach with update
fit.up1 <- aov(Temp ~ 1, data = tickData)  # basically the single-means model - only icpt
fit.up2 <- update(fit.up1, .~. + Hours)
fit.up3 <- update(fit.up2, .~. + Bites)
fit.up4 <- update(fit.up3, .~. + Hours:Bites)

# alernative approach with step
fit.step <- step(fit.1, direction = "backward", trace = F)

# model comparison with anova
anova(fit.up1, fit.up2, fit.up3, fit.up4)  # clearly, fit.up3 is best
#anova(fit.step)

# final formula
form1 <- formula(Temp ~ Hours + Bites)

fit.final <- aov(form1, data = tickData)

# check model assumptions and diagnostics
resids <- resid(fit.final)
fitvals<- fitted(fit.final)
hist(resids)  # I would say that this looks good! center around 0 with const variance

plot(fit.final)  # errors approx. normally distributed, variance constant and homogeneous
# more explanation
# plot 1: residuals vs fitted: looks OK => no systematic effect, variance constant+homogeneous
# plot 2: normal QQ plot:      looks OK => errors normally distributed
# data follows approximately a normal distribution

vif(fit.final)  # no multicollinearity
outlierTest(fit.final)  # nothing significant to be found with bonferroni correction
cookdist <- cooks.distance(fit.final)
betas    <- dfbeta(fit.final)
covrat   <- covratio(fit.final)

# report results:
# There was a significant effect observed in the increase of body temperature regarding
# the number of bites noticed (F(2,47) = 218.906, p < 0.001) as well as for the time spent outside
# (F(1,47) = 8.463, p < 0.01).

# Conclusion: The awareness of being bitten correlates with an increase in body temperature,
# which is further influenced by the time spent outside (increasing the possibility of
# being bitten). Apparently, these researchers did not use any anti-mosquitoe spray(?)

# predicted body temperature when time spent outside = 2 hours
fit.reg <- lm(Temp ~ Hours + Bites, data = tickData)
summary(fit.reg)
# or
summary.lm(fit.final)
# based on these summaries, we have for Hours=2:
# body_temp = intercept_0_bites + betaHours*Hours
# => body_temp = 36.5081 + 0.2633*2 = 37.0347
body_temp = 36.5081 + 0.2633*2


# THANKS FOR THE GOOD TIME, ERIK!! :)
