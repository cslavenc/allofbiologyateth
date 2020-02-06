# Summary of DSuR course
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

# data manipulation ----
# stack, unstack, melt, 
?subset
maleExam <- subset(examData, examData$Gender == "Male")

# generate factors:
?factor
?gl  # factor() is the underlying function
teachData$group <- factor(teachData$group, levels = c(1:3), 
                          labels = c("Punish", "Reward", "Indifference") )



# data exploration ----
newdat <- read.delim("name.dat", header = T, delim = " ")
rexam <- read.delim("rexam.dat", header = T)
by(data = rexam$exam, INDICES = rexam$uni, FUN = describe)
plot(rexam)  # gives a scatterplot

# test normal distr. with shapiro.test(dataframe$data)
# shapiro.test(): H_0 : data is normally distributed, H_A : data NOT normally distributed
# => if p is significant, then drop H_0 and H_A holds "true"
shapiro.test(rexam$exam)  # p < 5% => NOT normal
shapiro.test(dunce$exam)  # p > 5% => IS  normal
by(rexam$exam, rexam$uni, shapiro.test)
qplot(sample = rexam$exam, stat="qq")

# test for two different means with leveneTest(), compares median by default, must specify
# mean explicity with center = "mean"
leveneTest(rexam$exam, rexam$uni, center = "mean")  # p > 5%, not significant
# => no difference in variances => homogeneity of variances fulfilled!

# correlation
cor.test(advertData$adverts, advertData$packets, method = "pearson")  # spearman and kendall also available
cor(examData2)^2  # this gives me R^2

# ggplot2 graphs ----
# histogram with curve
ex2 <- ggplot(rexam, aes(lectures)) + geom_histogram(aes(y = ..density..), binwidth = 3)
exn2 <- stat_function(fun = dnorm, args = list(mean = mean(rexam$lectures, na.rm=TRUE), 
                                               sd = sd(rexam$lectures, na.rm=TRUE)), size = 1)
ex2 + exn2

# scatter
adverts<-c(5,4,4,6,8)
packets<-c(8,9,10,13,15)
advertData<-data.frame(adverts, packets)
scatter <- ggplot(advertData, aes(adverts, packets)) + geom_point()
scatter

# error bars and boxplots
spw <- ggplot(adjustedData, aes(group, anxiety_adj))
spw2 <- geom_bar()
spwbar <- stat_summary(fun.y = mean, geom = "bar", fill = "white", colour = "black")
spwerr <- stat_summary(fun.data = mean_cl_normal, geom = "errorbar", colour = "red") 
spw + spwerr + spwbar

?geom_boxplot
bxplot <- geom_boxplot()
splim <- scale_y_continuous(limits = c(0,60))
spw + spwerr + bxplot + splim
by(spider$Anxiety, spider$Group, stat.desc, basic = FALSE, norm = TRUE)

# make graph
line   <- ggplot(viagraData, aes(dose, libido))
errbar <- stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2)
point  <- stat_summary(fun.y = mean, geom = "point", size = 3) 
line + errbar + point + stat_summary(fun.y = mean, geom = "line", size = 1, aes(group=1))

# two boxplots in one panel each
# clock of invisibility data
clock <- read.delim("CloakofInvisibility.dat", header = TRUE)
clock$cloak <- factor(clock$cloak, levels = c(1:2), labels = c("No Clock", "Clock"))

# make a ggplot boxplot
clockStacked <- melt(clock, id = "cloak")
names(clockStacked) <- c("Cloack", "Mischief", "Stealth")
cc1 <- ggplot(clockStacked, aes(Cloack, Stealth)) + geom_boxplot() + facet_wrap(~Mischief)
cc1


# bootstrapping with own function ----
# write own function
bootTau2 <- function(examData2,i){ cor(examData2$Revise[i], examData2$Anxiety[i],
                                       method = "pearson") }
boot_exam <- boot(examData2, bootTau2, 2000)
boot.ci(boot_exam)  # gives 95% confint

# bootstrapping for linear regression ----
bootReg <- function(formula, data, i) {
  d <- data[i,]
  fit <- lm(formula, data = d)
  return(coef(fit))
}

bootResults <- boot(statistic = bootReg, formula = sales ~., data = album2, R = 2000)
boot.ci(bootResults, type = "bca", index = 1)


# statistical tests ----
# effect size r
# dependent t-test
fm3 <- t.test(spiderw$picture, spiderw$real, paired = TRUE)
summary(fm3)

# post-hoc tests using pairwise.t.test()
vig.pw <- pairwise.t.test(viagraData$libido, viagraData$dose, method = "BH", paired = FALSE)
# n.s. for low dose vs. placebo, since we corrected for multiple testing
# or because previously, we performed one-tailed test and here it is two-tailed with smaller alpha

postHocs <- glht(viagraCon, linfct = mcp(dose = "Tukey"))
summary(postHocs)
confint(postHocs)


# effect size r
t2  <- fm3$statistic[[1]]
df2 <- fm3$parameter[[1]]
r2 <- sqrt(t2^2/(t2^2 + df2))

# wilcox test when t.test not possible because variances are NOT homogeneous
drugData <- read.delim("Drug.dat", header = TRUE)
# rank the data
alcData <- subset(drugData, drug=="Alcohol")
xtcData <- subset(drugData, drug=="Ecstasy")
alcDataSorted <- alcData[order(-alcData$sundayBDI),]
alcDataRanked <- rank(alcDataSorted$sundayBDI)
xtcDataSorted <- xtcData[order(-xtcData$sundayBDI),]
xtcDataRanked <- rank(xtcDataSorted$sundayBDI)

shapiro.test(alcDataSorted$sundayBDI)
leveneTest(alcDataSorted$sundayBDI, xtcDataSorted$sundayBDI, center = "mean")

# Wilcox' test
sunModel <- wilcox.test(sundayBDI ~ drug, data = drugData)
wedModel <- wilcox.test(wedsBDI ~ drug, data = drugData)

# lm
album1 <- read.delim("Album Sales 1.dat", header = TRUE)
fm1 <- lm(sales ~ adverts, data = album1)
summary(fm1)
# t <- 1.341e+02/7.537  # t = estimate/std.Error

# check model assumption
plot(fm1)
hist(resids)  # residuals of fm1

sales <- 134.1 + 0.096*666.000  # obtain params from model, then plug in x to get y

# AIC = n*ln(SSE/n) + 2k, k #predictors, n #cases in the model
# stepwise method: use backwards method, where all predictors are used and then
# subsequently dropped and AIC is alwas evaluated until a really small AIC is reached
# while still explaining lots of variance with the remaining predictors

# get standardized beta that are not dependent on units of measurement with "lm.beta(fit)"
# it is then in units std. deviations so to say (we must multiply this beta with the 
# standard deviation to get the actual increase by 1 unit) - elegant way to report results
lm.beta(fit.2)
confint(fit.2)  # intercept contains 0, intercept is n.s. from 0 therefore

# backward lm
childData <- read.delim("ChildAggression.dat.", header = TRUE, sep = " ")
child.1 <- lm(Aggression ~., data = childData)
child.step <- step(child.1, direction = "backward", trace = FALSE)  # backward is the key here


# aov
# SST = SSM + SSR, SSR = SSgroup1 + ... + SSgroupn
# FWER = 1 - (0.95)^n, n = #tests, alpha = 5%
# FDR  = falsely rejected H_0/correctly rejected H_0
?gl  # generate factor levels, could also check ?factor
viagraData <- read.delim("Viagra.dat", header = TRUE)
viagraData$dose <- gl(3,5, labels = c("Placebo", "Low dose", "High dose"))

# set options
options(contrasts = c("contr.treatment", "contr.poly"))  # might not be necessary for the exam...

# planned contrasts
con1 <- c(1, -0.5, -0.5)
con2 <- c(0, -1, 1)
contrasts(viagraData$dose) <- cbind(con1, con2)
viagraCon <- aov(libido ~ dose, data = viagraData)
summary.lm(viagraCon)  # prints icpt, dosecon1 and dosecon2, which are the two contrasts

# trend analysis: is relationship linear, quadratic, etc...
contrasts(viagraData$dose) <- contr.poly(3)  # trends: linear, quadratic
viagraTrend <- aov(libido ~ dose, data = viagraData)
summary.lm(viagraTrend)

# ancova
# make an ANCOVA model
clock.1 <- aov(mischief1 ~ cloak, data = clock)  # covariate is n.s.
clock.2 <- aov(mischief2 ~ mischief1 + cloak, data = clock)

# evaluate ANCOVA: first covariate variable, then the independent variables
contrasts(viagraData$dose) <- contr.helmert(3)
vigcov.1 <- aov(libido ~ partnerLibido + dose, data = viagracovData)
Anova(vigcov.1, type = "III")

vv2 <- ggplot(viagracovData, aes(libido, partnerLibido)) + geom_point(size = 3)
vv2stat <- geom_smooth(method = "lm", alpha = 0.4)
vv2 + vv2stat

# different anovas
anova(fit.1, fit.2)  # tests whether the second model is "better", you can also check AIC
Anova(fit.1, type = "III")  # or I or II, from car-package




