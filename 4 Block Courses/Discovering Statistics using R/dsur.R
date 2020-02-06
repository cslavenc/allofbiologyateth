# Discovering Statistics using R
getwd()
wdpath = "C:/Users/made_/Desktop/ETH/4 Block Courses/Discovering Statistics using R/DSuR/Data"
setwd(wdpath)  # LOCATION OF DATASETS

library(ggplot2)
library(multcomp)
library(lmerTest)
library(lme)
library(nlme)
# import custom made functions from "Custom functions.R"
source("C:/Users/made_/Documents/1 Main folder/Computer Lab/R/Custom functions.R")
# trick: relationship between F- and t statistic: F = t^2

# section 1 ----
## In case we wanted help on how to use e.g. the 'sum()' function, we execute:
?sum

# Basics -----


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

#### -----
## Export data from R: e.g. to a .txt or .csv file in your working directory
#### -----
write.table(lecturerData, "lecturerData.txt", sep= "\t", row.names= F)
write.csv(lecturerData, "lecturerData.csv")

## Now, open the R script accompanying book Chapter 3, and read your way through
## Chapter 3 from section 3.9 onwards, while following along with the script
## from line 90 (marked as '#--------Selecting Data-----------').
lecturerPersonality <- lecturerData[,c('friends', 'alcohol', 'neurotic')]
lecturerOnly <- lecturerData[lecturerData$job =="Lecturer",]
alcPersonality <- lecturerData[lecturerData$alcohol > 10, c("friends", "alcohol", "neurotic")]

?subset

satisfactionData = read.delim("Honeymoon Period.dat", header = TRUE)
satisfactionStacked<-stack(satisfactionData, select = c("Satisfaction_Base", "Satisfaction_6_Months", "Satisfaction_12_Months", "Satisfaction_18_Months"))
install.packages("reshape")
library(reshape)






# section 2 ----
?qplot
?ggplot
?aes
# ggplot types:
# geom_bar(), geom_boxplot(), geom_point(), geom_line(), geom_histogram(), geom_errorbar()
# in aes():
#   linetype = 1,..,7, size, shape, colour, alpha
?facet_grid
?facet_wrap
# ggsave(filename.extension, width = double, length = double)

facebookData <- read.delim("FacebookNarcissism.dat", header = TRUE)
View(facebookData)

g <- ggplot(facebookData, aes(NPQC_R_Total, Rating))
g + geom_point(shape=facebookData$Rating_Type, aes(col = Rating_Type),
               position = "jitter")

examData <- read.delim("Exam Anxiety.dat", header = TRUE)
View(examData)
g2 <- ggplot(examData, aes(Anxiety, Exam))
g2 + geom_point(aes(col = Gender)) + labs(x = "Exam anxiety", y = "Exam Performance in %") + geom_smooth(
  method = "lm", col = "red", alpha = 0.1, fill = "blue")

# Self-test Narcissism ----
# Narcissism data
fb <- ggplot(facebookData, aes(Rating, NPQC_R_Total))
fb + labs(x = "Rating", y = "NPQC R Total") + geom_point() + geom_smooth()
fb + labs(x = "Rating", y = "NPQC R Total") + geom_point(aes(colour= Rating_Type), position= "jitter") + geom_smooth(aes(colour= Rating_Type), method= lm, se= F)

# histograms ----
festivalData <- read.delim("DownloadFestival.dat", header = TRUE)
View(festivalData)
h <- ggplot(festivalData, aes(day1)) + theme(legend.position = "none")
h + geom_histogram(binwidth = 0.4) + labs(x = "Hygiene Day 1", y = "Frequency")

# boxplots ----
bxp <- ggplot(festivalData, aes(gender, day1))
bxp + geom_boxplot()
festivalData <- festivalData[order(festivalData$day1),]

# remove outlier
out1 <- max(festivalData$day1)
id <- 611
fest2 <- festivalData[-c(810),]
bxp2 <- ggplot(fest2, aes(gender, day1))
bxp2 + geom_boxplot()

temp <- ggplot(festivalData, aes(gender, day3))
temp + geom_boxplot()

?geom_density()
h + geom_density(fill = "pink") + labs(x = "Hygiene (Day 1 of Festival)", y = "Density Estimate")

# chickflick double bar graph colouring ----
install.packages("Hmisc")
chickFlick <- read.delim("ChickFlick.dat", header = TRUE)
bar <- ggplot(chickFlick, aes(film, arousal))
stat1 <- stat_summary(fun.y = mean, geom = "bar", fill = "white", colour = "black")
err <- stat_summary(fun.data = mean_cl_boot, geom = "errorbar", colour = "red")
label <- labs(x = "Film", y = "Mean Arousal")
bar + stat1 + err + label

bar2 <- ggplot(chickFlick, aes(film, arousal, fill = film))
err2 <- stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position = position_dodge(width=0.90), width = 0.2)
stat2 <- stat1 <- stat_summary(fun.y = mean, geom = "bar")
label2 <- labs(x = "Film", y = "Mean Arousal", fill = "Gender")
bar2 + stat2 + err2 + facet_wrap(~ gender) +theme(panel.background = element_blank())
# custom colours: + scale_fill_manual("Gender", c("Female" = "Blue", "Male" = "Green"))

cor.test(chickFlick$gender, chickFlick$film, method = "spearman")

# hiccups ----
hiccupsData <- read.delim("Hiccups.dat", header = TRUE)
hicc <- stack(hiccupsData)
names(hicc)<-c("Hiccups","Intervention")
hicc$Intervention_Factor <- factor(hicc$Intervention, levels = hicc$Intervention)
l <- ggplot(hicc, aes(Intervention_Factor, Hiccups))
line <- geom_line()
lstat <- stat_summary(fun.y = mean, geom = "line", aes(group=1), colour="Blue", 
                      linetype = "dashed")
lstat2 <- stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2)
lstat3 <- stat_summary(fun.y = mean, geom = "point")
llabel <- labs(x = "Intervention", y = "Mean Number of Hiccups")
l  + lstat + lstat2 + lstat3 + llabel

# texting ----
?reshape
textData <- read.delim("TextMessages.dat", header = TRUE)  
View(textData)
textData$id <-  row(textData[1])
textMessages <- reshape(textData, varying = c("Baseline", "Six_months"), v.names = "Grammar_Score",
                       idvar = c("id", "Group"), timevar = "Time", times = c(0:1), direction = "long")
textMessages$Time<-factor(textMessages$Time, labels = c("Baseline", "6 Months"))
mline <- ggplot(textMessages, aes(Time, Grammar_Score, colour = Group))
mstat <- stat_summary(fun.y = mean, geom = "point", shape=2)
mstat2 <- stat_summary(fun.y = mean, geom = "line", aes(group = Group),
                       linetype = "dashed")
mstat3 <- stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2)
mlabel <- labs(x = "Time", y = "idiot score", colour = "Group")
mline + mstat + mstat2 + mstat3 + mlabel


  



# section 3: Assumptions ----

library(car)
library(pastecs)
library(psych)
library(Rcmdr)

# festival ----
?stat_function
festivalData <- read.delim("DownloadFestival.dat", header = TRUE)
f <- ggplot(festivalData, aes(day1))
fhisto <- geom_histogram(aes(y = ..density..))
fnormal <- stat_function(fun = dnorm, mean = mean(festivalData$day1, na.rm = TRUE),
                         sd = sd(festivalData$day1, na.rm = TRUE), size=1)
f + fhisto + fnormal

qqplot.day1 <- qplot(sample = festivalData$day1, stat="qq")
qqplot.day1

describe(festivalData$day1)                               # psych package
stat.desc(festivalData$day1, basic = FALSE, norm = TRUE)  # pastenc package
# scale() within qplot gives z-scores from data as a transformation
# geom_abline() also makes qq-plots but with more annotations

# exam data ----
rexam <- read.delim("rexam.dat", header=TRUE)
View(rexam)
rexam$uni<-factor(rexam$uni, levels = c(0:1), labels = c("Duncetown University", "Sussex University"))
ex <- ggplot(rexam, aes(exam)) + geom_histogram(aes(y = ..density..), binwidth = 3)
exn <- stat_function(fun = dnorm, args = list(mean = mean(rexam$exam, na.rm=TRUE), 
                                              sd = sd(rexam$exam, na.rm=TRUE)), size = 1, colour = "Blue")
ex + exn
stat.desc(rexam)

ex2 <- ggplot(rexam, aes(lectures)) + geom_histogram(aes(y = ..density..), binwidth = 3)
exn2 <- stat_function(fun = dnorm, args = list(mean = mean(rexam$lectures, na.rm=TRUE), 
                                              sd = sd(rexam$lectures, na.rm=TRUE)), size = 1)
ex2 + exn2

ex3 <- ggplot(rexam, aes(computer)) + geom_histogram(aes(y = ..density..), binwidth = 3)
exn3 <- stat_function(fun = dnorm, args = list(mean = mean(rexam$computer, na.rm=TRUE), 
                                               sd = sd(rexam$computer, na.rm=TRUE)), size = 1)
ex3 + exn3

?describe
?by
by(data = rexam$exam, INDICES = rexam$uni, FUN = describe)

dunce <- subset(rexam, rexam$uni == "Duncetown University")
susse <- subset(rexam, rexam$uni == "Sussex University")

du <- ggplot(dunce, aes(computer)) + geom_histogram(aes(y = ..density..), binwidth = 3)
dun <- stat_function(fun = dnorm, args = list((mean = mean(dunce$computer)), sd = sd(dunce$computer)))
du + dun
# lectures: students tend to come, approx. normally distr.
# same for computer literacy

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

# festival - transforming data ----
fd <- read.delim("DownloadFestival.dat", header = TRUE)
fd$logday1 <- log(fd$day1)
temp <- fd$day3[!is.na(fd$day3)]
temp <- log(fd$day3)
fd$logday2 <- temp
fd$logday3 <- temp

# make histograms
lgd1 <- ggplot(fd, aes(logday1)) + geom_histogram(aes(y = ..density..))
lgd1n <- stat_function(fun = rnorm, args = list(mean = mean(fd$logday1), sd = sd(fd$logday1)))
lgd1 + lgd1n
shapiro.test(fd$logday1)

lgd3 <- ggplot(fd, aes(logday3)) + geom_histogram(aes(y = ..density..))
lgd3n <- stat_function(fun = rnorm, args = list(mean = mean(fd$logday3), sd = sd(fd$logday3)))
lgd3 + lgd3n

# ifelse():
tmp <- ifelse(x > value, set_value_if_true, set_value_if_false)



# Section 4: Correlation ----

library(ggplot2)
library(polycor)
library(ggm)

adverts<-c(5,4,4,6,8)
packets<-c(8,9,10,13,15)
advertData<-data.frame(adverts, packets)
cor.test(advertData$adverts, advertData$packets, method = "pearson")
scatter <- ggplot(advertData, aes(adverts, packets)) + geom_point()
scatter

cor.test(rexam$computer, rexam$numeracy, method = "pearson")

# exam anxiety ----
# use pearson if all data are from an intervar (they are "continuous" in theory)
examData <- read.delim("Exam Anxiety.dat")
examData2 <- examData[, c("Exam", "Anxiety", "Revise")]
cor(examData2)
cor.test(examData2$Revise, examData2$Exam, method = "pearson")
cor.test(examData2$Revise, examData2$Anxiety, method = "pearson")
cor(examData2)^2  # this gives me R^2


# partial correlation

library("igraph")
library("ggm")
library("ppcor")
?pcor
pc <- pcor(examData2, method = "pearson")  # pc^2 gives R^2 values

# liar data ----
# use spearman as method if there is binary data too or kendall as method
library(boot)
liarData = read.delim("The Biggest Liar.dat", header = TRUE)
cor(liarData$Creativity, liarData$Position, method = "spearman")
cor.test(liarData$Creativity, liarData$Position, method = "spearman", alternative = "less")

bootTau <- function(liarData,i) cor(liarData$Position[i], liarData$Creativity[i],
                                    use = "complete.obs", method = "kendall")
boot_kendall <- boot(liarData, bootTau, 2000)
boot.ci(boot_kendall)  # 95% confidence intervalls

# write own function
bootTau2 <- function(examData2,i){ cor(examData2$Revise[i], examData2$Anxiety[i],
                                      method = "pearson") }
boot_exam <- boot(examData2, bootTau2, 2000)
boot.ci(boot_exam)

# cat data ----
library(polycor)
catData = read.csv("pbcorr.csv", header = TRUE)
cor.test(catData$time, catData$gender, method = "pearson")
catFrequencies <- table(catData$gender)
prop.table(catFrequencies)
polyserial(catData$time, catData$gender)

# Exercises ----
?subset
maleExam <- subset(examData, examData$Gender == "Male")
femaleExam <- subset(examData, examData$Gender == "Female")
cor(maleExam$Anxiety, maleExam$Exam)
cor.test(femaleExam$Anxiety, femaleExam$Exam)

essaydat <- read.delim("EssayMarks.dat", header = TRUE)
cor.test(essaydat$essay, essaydat$hours, method = "pearson")
ess <- ggplot(essaydat, aes(essay, hours)) + geom_point() + geom_smooth(method = lm)
ess

grades <- read.csv("grades.csv", header = TRUE)
cor.test(grades$stats, grades$gcse)



# Section 5: Comparing two means ----
install.packages("WRS2")  # does not work and neither does WRS
library(pastecs)
library(reshape)
library(WRS2)

# spider data ----
spider <- read.delim("spiderLong.dat", header = TRUE)
sp <- ggplot(spider, aes(Anxiety, Group)) + geom_bar()
sperr <- stat_summary(fun.data = mean_cl_boot, geom = "errorbar", colour = "red")
sp2 <- stat_summary(fun.y = mean, geom = "bar", fill = "white", colour = "black")
sp + sperr + sp2  # does not recognize group

spiderw <- read.delim("spiderWide.dat", header = TRUE)
spiderw$pmean <- (spiderw$picture + spiderw$real)/2   # mean for all participants
grandMean <- mean(c(spiderw$picture, spiderw$pmean))  # mean of all scores
spiderw$adj <- grandMean - spiderw$pmean              # adjusted means
spiderw$picture_adj <- spiderw$picture + spiderw$adj
spiderw$real_adj <- spiderw$real + spiderw$adj
spiderw$pmean2<-(spiderw$picture_adj + spiderw$real_adj)/2
spiderw$id <- gl(12, 1, labels = c(paste("P", 1:12, sep = "_")))

adjustedData <- melt(spiderw, id = c("id", "picture", "real", "pmean", "adj", "pmean2"), measured = c("picture_adj", "real_adj"))
adjustedData <-adjustedData[, -c(2:6)]
names(adjustedData) <- c("id", "group", "anxiety_adj")

spw <- ggplot(adjustedData, aes(group, anxiety_adj))
spw2 <- geom_bar()
spwbar <- stat_summary(fun.y = mean, geom = "bar", fill = "white", colour = "black")
spwerr <- stat_summary(fun.data = mean_cl_normal, geom = "errorbar", colour = "red") 
spw + spwerr + spwbar

fm <- lm(Anxiety ~ Group, data = spider)
summary(fm)

?geom_boxplot
bxplot <- geom_boxplot()
splim <- scale_y_continuous(limits = c(0,60))
spw + spwerr + bxplot + splim
by(spider$Anxiety, spider$Group, stat.desc, basic = FALSE, norm = TRUE)

fm  <- t.test(Anxiety ~ Group, data = spider)
fm2 <- t.test(spiderw$picture, spiderw$real, data = spiderw)
shapiro.test(spiderw$picture)  # p > 5%, we can assume normality

yu  <- yuen(spiderw$picture, spiderw$real)
t  <- fm2$statistic[[1]]
df <- fm2$parameter[[1]]
r <- sqrt(t^2/(t^2 + df))

# dependent t-test
fm3 <- t.test(spiderw$picture, spiderw$real, paired = TRUE)
summary(fm3)

# effect size r
t2  <- fm3$statistic[[1]]
df2 <- fm3$parameter[[1]]
r2 <- sqrt(t2^2/(t2^2 + df2))

# psychopathic manager data ----
pm <- read.delim("Board&Fritzon(2005).dat", header = TRUE)
# explore
str(pm)
head(pm)
View(pm)

ttestfromMeans<-function(x1, x2, sd1, sd2, n1, n2)
{	df<-n1 + n2 - 2
poolvar <- (((n1-1)*sd1^2)+((n2-1)*sd2^2))/df
t <- (x1-x2)/sqrt(poolvar*((1/n1)+(1/n2)))
sig <- 2*(1-(pt(abs(t),df)))
paste("t(df = ", df, ") = ", t, ", p = ", sig, sep = "")

}

# Conclusion: managers have a higher score than psychopaths in all disorders except narcissism
ttestfromMeans(pm$x1, pm$x2, pm$sd1, pm$sd2, pm$n1, pm$n2)
# fm4 <- t.test(pm$x1, pm$x2, data = pm)

# Exercises ----
# gender data
gen <- read.delim("Penis.dat", header = TRUE)
fm5 <- t.test(happy ~ book, data = gen)

gen2 <- read.delim("Field&Hole.dat", header = TRUE)
fm6  <- t.test(gen2$women, gen2$statbook, paired = TRUE)
summary(fm6)
fm6$p.value



# Section 6: Non-parametric tests ----
install.packages("clinfun")
install.packages("pgirmess")
library(clinfun) 
library(ggplot2)
library(pastecs)
library("pgirmess")
library("car")

# drug data ----
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

# function for effect size r: ----
# N is the sample size
rFromWilcox<-function(wilcoxModel, N){
  z<- qnorm(wilcoxModel$p.value/2)
  r<- z/ sqrt(N)
  cat(wilcoxModel$data.name, "Effect Size, r = ", r)
}

# more wilcox tests ----
wm  <- wilcox.test(drugData$sundayBDI, drugData$wedsBDI, paired = TRUE)
wm2 <- wilcox.test(alcDataSorted$sundayBDI, alcDataSorted$wedsBDI, paired = TRUE,
                   correct = FALSE)  # sign.
wm3 <- wilcox.test(xtcDataSorted$sundayBDI, xtcDataSorted$wedsBDI, paired = TRUE,
                   correct = FALSE)  # sign.

rFromWilcox(wm2, 20)
rFromWilcox(wm3, 20)

# mating data ----
mateData <- read.delim("Matthews et al. (2007).dat", header = TRUE)
wm4 <- wilcox.test(mateData$Signaled, mateData$Control, paired = TRUE, correct = FALSE)  # sign.



# Section 7: Regression ----
install.packages("QuantPsyc")

library("QuantPsyc")
library("car")
library("boot")
library("lmerTest")
library("lme4")

# album sales data ----
album1 <- read.delim("Album Sales 1.dat", header = TRUE)
fm1 <- lm(sales ~ adverts, data = album1)
summary(fm1)
# t <- 1.341e+02/7.537  # t = estimate/std.Error

sales <- 134.1 + 0.096*666.000

# AIC = n*ln(SSE/n) + 2k, k #predictors, n #cases in the model
# stepwise method: use backwards method, where all predictors are used and then
# subsequently dropped and AIC is alwas evaluated until a really small AIC is reached
# while still explaining lots of variance with the remaining predictors

betaData <- read.delim("dfbeta.dat", header = TRUE)

# album 2 data ----
album2 <- read.delim("Album Sales 2.dat", header = TRUE)
fit.1  <- lm(sales ~ adverts, data = album2)
fit.2  <- lm(sales ~ adverts + airplay + attract, data = album2)
test.1 <- lm(sales ~ 1, data = album2)

# using update function: albumSales.3 <- update(albumSales.2, .~. + airplay + attract)
summary(fit.1)
summary(fit.2)

# get standardized beta that are not dependent on units of measurement with "lm.beta(fit)"
# it is then in units std. deviations so to say (we must multiply this beta with the 
# standard deviation to get the actual increase by 1 unit) - elegant way to report results
lm.beta(fit.2)
confint(fit.2)  # intercept contains 0, intercept is n.s. from 0 therefore

anova(fit.1, fit.2)

# diagnostics shortcuts
resids   <- resid(fit.2)
cookdist <- cooks.distance(fit.2)
betas    <- dfbeta(fit.2)
covrat   <- covratio(fit.2)

album2$resids <- resids  # likewise, one can add the other casewise data into the df

dwt(fit.2)  # errors independent
vif(fit.2)  # test for multicollinearity => not really multicollinear, since values very close to 1
1/vif(fit.2)# tolerance formula: if 0.1, then problematic (bad)

# plotting to check model assumptions
plot(fit.2)
hist(resids)

# bootstrapping for linear regression ----
bootReg <- function(formula, data, i) {
  d <- data[i,]
  fit <- lm(formula, data = d)
  return(coef(fit))
}

bootResults <- boot(statistic = bootReg, formula = sales ~., data = album2, R = 2000)
boot.ci(bootResults, type = "bca", index = 1)

# exercise on lecturers ----
lecData <- read.delim("Chamorro-Premuzic.dat.", header = TRUE)

lec.1 <- lm(lectureN ~ Age + Gender, data = lecData)
lec.2 <- lm(lecturE ~ Age + Gender, data = lecData)
lec.3 <- lm(lecturO ~ Age + Gender, data = lecData)
lec.4 <- lm(lecturA ~ Age + Gender, data = lecData)
lec.5 <- lm(lecturE ~ Age + Gender, data = lecData)

lec2.1 <- lm(lectureN ~ Age + Gender + studentN + studentE +
               studentO + studentA, data = lecData)
lec2.2 <- lm(lecturE ~ Age + Gender + studentN + studentE +
               studentO + studentA, data = lecData)
lec2.3 <- lm(lecturO ~ Age + Gender + studentN + studentE +
               studentO + studentA, data = lecData)
lec2.4 <- lm(lecturA ~ Age + Gender + studentN + studentE +
               studentO + studentA, data = lecData)
lec2.5 <- lm(lecturE ~ Age + Gender + studentN + studentE +
               studentO + studentA, data = lecData)

# dummy coding ----
gfr <- read.delim(file = "GlastonburyFestivalRegression.dat", header = TRUE)
contrasts(gfr$music) <- contr.treatment(4, base = 4)
glModel <- lm(change ~ music, data = gfr)
dummy.coef(glModel, old.names = FALSE)
plot(glModel)
hist(rstandard(glModel))


# additional tasks ----
pubData <- read.delim("pubs.dat", header = TRUE)
bootResultsPubs <- boot(statistic = bootReg, formula = mortality ~., data = pubData, R = 2000) 
boot.ci(bootResultsPubs, type = "bca", index = 1)

catwalkDat <- read.delim("Supermodel.dat", header = TRUE, sep = " ")
?step
cat.1 <- lm(SALARY ~., data = catwalkDat)
cat.step <- step(cat.1, direction = "backward", trace=FALSE )
# testing if AGE and YEARS are the best according to step()
# this formula is the solution from cat.step
cat.test1 <- lm(SALARY ~ AGE + YEARS, data = catwalkDat)  # AGE and YEARS are sign. preds.

# child aggression data
childData <- read.delim("ChildAggression.dat.", header = TRUE, sep = " ")
child.1 <- lm(Aggression ~., data = childData)
child.step <- step(child.1, direction = "backward", trace=FALSE )



# Section 8: ANOVA ----

library(MASS)
library(reshape)
library(pastecs)
library(multcomp)  # for glht()
# FWER = 1 - (0.95)^n, n = #tests, alpha = 5%
# FDR  = falsely rejected H_0/correctly rejected H_0

# viagra data ----
# set options
options(contrasts = c("contr.treatment", "contr.poly"))
viagraData <- read.delim("Viagra.dat", header = TRUE)
viagraData$dose <- gl(3,5, labels = c("Placebo", "Low dose", "High dose"))

# make graph
line   <- ggplot(viagraData, aes(dose, libido))
errbar <- stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2)
point  <- stat_summary(fun.y = mean, geom = "point", size = 3) 
line + errbar + point + stat_summary(fun.y = mean, geom = "line", size = 1, aes(group=1))

# get descriptive statistics summaries in different ways
summary(viagraData)
by(viagraData$libido, viagraData$dose, stat.desc)
leveneTest(viagraData$libido, viagraData$dose, center = mean)  # n.s.
# if leveneTest() is sign. use oneway.test() instead of aov() to account for unequal var.

# perform anova
vig.1 <- aov(libido ~ dose, data = viagraData)
plot(vig.1)
summary.lm(vig.1)

# transform into wide format
viagraWide <- unstack(viagraData, libido ~ dose)
lincon(viagraWide, tr = .1)

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

# post-hoc tests using pairwise.t.test()
vig.pw <- pairwise.t.test(viagraData$libido, viagraData$dose, method = "BH", paired = FALSE)
# n.s. for low dose vs. placebo, since we corrected for multiple testing
# or because previously, we performed one-tailed test and here it is two-tailed with smaller alpha

postHocs <- glht(viagraCon, linfct = mcp(dose = "Tukey"))
summary(postHocs)
confint(postHocs)

# use modified dummy data for another form of analysis ----
dummyvig <- read.delim("dummy.dat", header = TRUE)
dum.fit  <- lm(libido ~ dummy1 + dummy2, data = dummyvig)

# SST = SSM + SSR, SSR = SSgroup1 + ... + SSgroupn
vig.fit <- aov(libido ~ dose, data = viagraData)

contvig <- read.delim("Contrast.dat", header = TRUE)
dum.fit2 <- lm(libido ~ dummy1 + dummy2, data = contvig)


# phallus semen displacement data ----
phallusData <- read.csv("Gallup et al.csv", header = TRUE)
contrasts(phallusData$Phallus) <- contr.poly(3)

phall.1 <- ggplot(phallusData, aes(Phallus, Displace))
phall.2 <- stat_summary(fun.y = mean, geom = "bar", colour = "Blue", fill = "Blue")
phall.3 <- stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.2)
phall.1 + phall.2 + phall.3

phall <- aov(Displace ~ Phallus, data = phallusData)
summary.lm(phall)
plot(phall)  # check model assumptions
leveneTest(phallusData$Displace, phallusData$Phallus, center = mean)  # check model assump.

# perform contrasts
contrasts(phallusData$Phallus) <- cbind(c(-1, 0.5, 0.5), c(0, -1, 1))
phallCon.1 <- aov(Displace ~ Phallus, data = phallusData)
summary.lm(phallCon.1)


# teaching data ----
teachData <- read.delim("Teach.dat", header = TRUE)
teach.fit <- aov(exam ~ group, data = teachData)
summary.lm(teach.fit)
teachData$group <- factor(teachData$group, levels = c(1:3), 
                          labels = c("Punish", "Reward", "Indifference") )

# perform contrasts
contrasts(teachData$group) <- cbind(c(0.5, -1, 0.5), c(1, 0, -1))
teach.con1 <- aov(exam ~ group, data = teachData)
summary.lm(teach.con1)

# superhero data ----
superData <- read.delim("Superhero.dat", header = TRUE)
superData$hero <- factor(superData$hero, levels = c(1:4), 
                         labels = c("Spoderman", "Supraman", "angry green man", "shell man"))
con1 <- c(1,0,0,-1)
con2 <- c(-1/3,1,-1/3,-1/3)
contrasts(superData$hero) <- cbind(con1, con2)
sup.fit <- aov(injury ~ hero, data = superData)
summary.lm(sup.fit)

pairwise.t.test(superData$injury, superData$hero, method = "BH")

# tumor data ----
tumorData <- read.delim("Tumour.dat", header = TRUE)
tumorData$usage <- factor(tumorData$usage, levels = c(0:5), 
                          labels = c("hour 0", "hour 1", "hour 2", "hour 3", "hour 4", "hour 5"))
tum.fit <- aov(tumour ~ usage, data = tumorData)
summary.lm(tum.fit)
pairwise.t.test(tumorData$tumour, tumorData$usage, method = "BH")


# Section 9: Non-parametric Tests 2 ----

library(pgirmess)
library(clinfun)
# soya data ----
soyaData <- read.delim("Soya.dat", header = TRUE)
by(soyaData$Sperm, soyaData$Soya, stat.desc)
leveneTest(soyaData$Sperm, soyaData$Soya, center = mean)
soya.fit <- aov(Sperm ~ Soya, data = soyaData)
summary.lm(soya.fit)
# pairwise.t.test(soyaData$Sperm, soyaData$Soya, method = "BH")
soya.kruskal <- kruskal.test(Sperm ~ Soya, data = soyaData)
soyaData$Rank <- rank(soyaData$Sperm)

# make a ggplot boxplot
ggsoy <- ggplot(soyaData, aes(Soya, Sperm))
soybxp <- geom_boxplot()
ggsoy + soybxp

# post-hoc analysis
kruskalmc(Sperm ~ Soya, data = soyaData)  # need pgirmess package, but it does not load

jonckheere.test(soyaData$Sperm, as.numeric(soyaData$Soya))

# fetishistic data ----
fetish <- read.delim("Cetinkaya & Domjan (2006).dat", header = TRUE)
fetish$Groups <- factor(fetish$Groups, levels = levels(fetish$Groups)[c(3,1,2)])
fet.kruskal1 <- kruskal.test(Paired ~ Egg_Percent, data = fetish)
fet.kruskal2 <- kruskal.test(Paired ~ Latency, data = fetish)
fet.kruskal3 <- kruskal.test(Paired ~ Duration, data = fetish)

# we can use friendmann.test for "related" anovas, even if its probably rather rare to do

# additional exercises ----
dogmanData <- read.delim("MenLikeDogs.dat", header = TRUE)
dogman.fit <- wilcox.test(dogmanData$behaviou ~ dogmanData$species, data = dogmanData)  #n.s.

darkData <- read.delim("DarkLord.dat", header = TRUE)
dark.fit <- wilcox.test(darkData$message, darkData$nomessag, paired = TRUE, correct = FALSE)

tvData <- read.delim("Eastenders.dat", header = TRUE)
friedman.test(as.matrix(tvData))
friedmanmc(as.matrix(tvData))

clownData <- read.delim("coulrophobia.dat", header = TRUE)
clown.kr  <- kruskal.test(beliefs ~ infotype, data = clownData)




# Section 10: ANCOVA ----

library(compute.es)
library(car)
library(pastecs)
library(multcomp)
library(WRS2)

# viagra data 2 ----
viagracovData <- read.delim("ViagraCovariate.dat", header = TRUE)
viagracovData$dose <- gl(3,10, labels = c("Placebo", "Low dose", "High dose"))
by(viagracovData$libido, viagracovData$dose, stat.desc)
by(viagracovData$partnerLibido, viagracovData$dose, stat.desc)

# make boxplots
vigcovStacked <- melt(viagracovData, id = "dose")
names(vigcovStacked) <- c("dose", "libido_type", "libido")
vv1 <- ggplot(vigcovStacked, aes(dose, libido)) + geom_boxplot() + facet_wrap(~libido_type)
vv1
leveneTest(viagracovData$libido, viagracovData$dose, center = mean)

# test if covariate (partnerLibido) is independent of independent variables
covar.test <- aov(partnerLibido ~ libido, data = viagracovData)  # n.s.

# evaluate ANCOVA: first covariate variable, then the independent variables
contrasts(viagraData$dose) <- contr.helmert(3)
vigcov.1 <- aov(libido ~ partnerLibido + dose, data = viagracovData)
Anova(vigcov.1, type = "III")

vv2 <- ggplot(viagracovData, aes(libido, partnerLibido)) + geom_point(size = 3)
vv2stat <- geom_smooth(method = "lm", alpha = 0.4)
vv2 + vv2stat

ancovpost <- glht(vigcov.1, linfct = mcp(dose = "Tukey"))
summary(ancovpost)
confint(ancovpost)

# plots for ancova model
par(mfrow=c(1,2))
plot(vigcov.1)

aovtest <- aov(libido ~ dose, data = viagracovData)  # which produces a wrong result

# ANCOVA interactions ----
vigcov.2 <- aov(libido ~ partnerLibido*dose, data = viagracovData)
Anova(vigcov.2, type = "III")

# clock of invisibility data ----
clock <- read.delim("CloakofInvisibility.dat", header = TRUE)
clock$cloak <- factor(clock$cloak, levels = c(1:2), labels = c("No Clock", "Clock"))

# make a ggplot boxplot
clockStacked <- melt(clock, id = "cloak")
names(clockStacked) <- c("Cloack", "Mischief", "Stealth")
cc1 <- ggplot(clockStacked, aes(Cloack, Stealth)) + geom_boxplot() + facet_wrap(~Mischief)
cc1

# make an ANCOVA model
clock.1 <- aov(mischief1 ~ cloak, data = clock)  # covariate is n.s.
clock.2 <- aov(mischief2 ~ mischief1 + cloak, data = clock)

# create a new df from clock called clockNew
?ancova
nocloak <- subset(clock, cloak=="No Cloak")
yecloak <- subset(clock, cloak=="Cloak")
covgrp1 <- yecloak$mischief1
dpvgrp1 <- yecloak$mischief2
covgrp2 <- nocloak$mischief1
dpvgrp2 <- nocloak$mischief2
ancova(clock.2) 

# negative children data ----
antikid <- read.delim("Muris et al. (2008).dat", header = TRUE)
antikid$Training <- factor(antikid$Training, levels = c(1:2),
                           labels = c("Negative Training", "Positive Training"))

# perform ancova
ak1 <- aov(Age ~ Training, data = antikid)     # n.s.
ak2 <- aov(Gender ~ Training, data = antikid)  # n.s.
ak3 <- aov(SCARED ~ Training, data = antikid)  # n.s.
antikid.1 <- aov(Interpretational_Bias ~ Age + Gender + SCARED + Training, data = antikid)


# additional exercises
stalkData <- read.delim("Stalker.dat", header = TRUE)
stalkData$group <- factor(stalkData$group, levels = c(1:2),
                          labels = c("punish", "penis"))

# perform ancova
st1 <- aov(stalk1 ~ group, data = stalkData)  # n.s.
stalk.1 <- aov(stalk2 ~ stalk1 + group, data = stalkData)
summary.lm(stalk.1)
plot(stalk.1)

# check for interaction
stalk.2 <- aov(stalk2 ~ stalk1*group, data = stalkData)
Anova(stalk.2, type = "III")

# hangover data ----
options(contrasts = c("contr.treatment", "contr.poly"))
hangover <- read.delim("HangoverCure.dat", header = TRUE)

hangover$drink <- factor(hangover$drink, levels = c(1:3),
                         labels = c("water", "lucozade", "cola"))

# perform ancova
hg <- aov(drunk ~ drink, data = hangover)  # n.s.
hang <- aov(well ~ drunk + drink, data = hangover)

# check for interaction
hang2 <- aov(well ~ drunk*drink, data = hangover)
Anova(hang2, type = "III")

# elephant football data ----
elefoot <- read.delim("Elephant Football.dat", header = TRUE)
elefoot$elephant <- factor(elefoot$elephant, levels = c(1:2), 
                           labels = c("type 1", "type 2"))

# perform an ancova
ef1 <- aov(experience ~ elephant, data = elefoot)  # n.s.
elefoot.1 <- aov(goals ~ experience + elephant, data = elefoot)

# check for interaction
elefoot.2 <- aov(goals ~ experience*elephant, data = elefoot)
Anova(elefoot.2, type = "III")







# Section 11: Factorial ANOVA ----
library(car)
library(compute.es)
library(ggplot2)
library(multcomp)
library(pastecs)
library(reshape)
library(WRS)  # does not exist

# alcohol attractiveness data ----
gogglesData <- read.delim("goggles.csv", header = TRUE, sep = ",")
# gogglesData$alcohol <- factor(gogglesData$alcohol, levels = c("None", "2 Pints", "4 Pints"))
alcplot <- ggplot(gogglesData, aes(gender, attractiveness)) + geom_point() + labs(x = "gender", y = "attractiveness", colour = "gender") + facet_wrap(~gender)
alc1 <- stat_summary(fun.data = mean_cl_normal, geom = "errorbar", aes(group = gender), width = 0.2) 
alcplot + alc1

by(gogglesData$attractiveness, gogglesData$alcohol, stat.desc)
leveneTest(gogglesData$attractiveness, gogglesData$alcohol, center = median)

# contrasts
con.alc <- cbind(c(1, -0.5, -0.5),
              c(0, -1, 1))
con.gen <- c(-1, 1)
contrasts(gogglesData$alcohol) <- con.alc
contrasts(gogglesData$gender)  <- con.gen 

# fit model
gog.fit <- aov(attractiveness ~ alcohol * gender, data = gogglesData)
Anova(gog.fit, type = "III")

plot(gog.fit)  # for checking model assumptions

alcplot2 <- ggplot(gogglesData, aes(alcohol, attractiveness))
alc2 <- stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.2)
alc3 <- stat_summary(fun.y = mean, geom = "bar", fill = "White", colour = "Black")
alcplot2 + alc2 + alc3

summary.lm(gog.fit)

# post-hoc tests
pairwise.t.test(gogglesData$attractiveness, gogglesData$alcohol, p.adjust.method = "bonferroni")
posthocalc <- glht(gog.fit, linfct = mcp(alcohol = "Tukey"))
summary(posthocalc)
confint(posthocalc)

# i dont feel like stopping data ----
dontstopData <- read.delim("Davey2003.dat", header = TRUE)
dontstopData$Mood <- factor(dontstopData$Mood, levels = c(1:3),
                            labels = c("negative", "positive", "neutral"))
dontstopData$Stop_Rule <- factor(dontstopData$Stop_Rule, levels = c(1:2),
                                 labels = c("as many as can", "feel like continuing"))

# fit model
dontstopModel <- aov(Checks ~ Mood*Stop_Rule, data = dontstopData)
summary(dontstopModel)

bar <- ggplot(dontstopData, aes(Mood, Checks, fill = Stop_Rule))
bar + stat_summary(fun.y = mean, geom = "bar", position="dodge") + stat_summary(fun.data = mean_cl_normal, geom = "errorbar", position=position_dodge(width=0.90), width = 0.2) + labs(x = "Mood Induction", y = "Mean Quantity of Items Checked", fill = "Stop Rule") 

# additional exercises ----
# music data
musicData <- read.delim("fugazi.dat", header = TRUE)
musicData$music <- factor(musicData$music, levels = c(1:3),
                          labels = c("Fugazi", "ABBA", "people who are old and bold"))
musicData$age   <- factor(musicData$age, levels = c(1:2),
                          labels = c("young", "old"))
# fit model
musicModel <- aov(liking ~ music*age, data = musicData)
summary(musicModel)
summary.lm(musicModel)

# chickflick data
chick.dat <- read.delim("ChickFlick.dat", header = TRUE)
chick.fit <- aov(arousal ~ gender*film, data = chick.dat)
summary(chick.fit)
summary.lm(chick.fit)

# screaming data
scream.dat <- read.delim("Escape From Inside.dat", header = TRUE)
scream.dat$Song_Type  <- factor(scream.dat$Song_Type, levels = c(0:1),
                               labels = c("symphony", "flies"))
scream.dat$Songwriter <- factor(scream.dat$Songwriter, levels = c(0:1),
                                labels = c("dude who wrote book", "Malcolm"))

# fit model
scream.fit <- aov(Screams ~ Songwriter*Song_Type, data = scream.dat)
summary(scream.fit)
summary.lm(scream.fit)
dummy.coef(scream.fit)

# Wii data
wii.dat <- read.delim("Wii.dat", header = TRUE)
wii.fit <- aov(injury ~ wii*stretch*athlete, data = wii.dat)
summary(wii.fit)  # prevention programme was a good idea: stretching helps prevent injuries
summary.lm(wii.fit)
dummy.coef(wii.fit)





# BONUS Section: Mixed models ----
install.packages("ez")
library(ez)
library(nlme)
library(lme4)
library(lmerTest)
?subset

# speeddating data ----
speeddatingData <- read.delim("LooksOrPersonality.dat", header = TRUE)

# RESTRUCTURE
speeddatingData <- melt(speeddatingData, id = c("participant", "gender"),
                        measured = c("att_high", "av_high", "ug_high",
                                     "att_some", "av_some", "ug_some",
                                     "att_none", "av_none", "ug_none"))
names(speeddatingData) <- c("participant", "gender", "groups", "rating")
speeddatingData$personality <- gl(3, 60, labels = c("Charismatic", "Average", "idiot"))
speeddatingData$looks <- gl(3, 20, 180, labels = c("Attractive", "Average", "Ugly"))


# set contrast and fit mixed model
# build models for comparison later
# contrast for looks
contrasts(speeddatingData$looks) <- cbind(c(1, -1, 0),
                                          c(1, 0, -1),
                                          c(0, 1, -1))

# contrast for personality
contrasts(speeddatingData$personality) <- cbind(c(1, -1, 0),
                                                c(1, 0, -1),
                                                c(0, 1, -1))

speed.base <- lme(rating ~ 1, random = ~1|participant/looks/personality, data = speeddatingData,
                  method = "ML")
speed.test <- lme(rating ~ looks, random = ~1|participant/looks/personality, data = speeddatingData,
                  method = "ML")
# anova(speed.base, speed.test)
speed.1 <- update(speed.base, .~. + looks)
speed.2 <- update(speed.1, .~. + personality)
speed.3 <- update(speed.2, .~. + gender)
speed.4 <- update(speed.3, .~. + looks:personality)
speed.5 <- update(speed.4, .~. + looks:gender)
speed.6 <- update(speed.5, .~. + gender:personality)
speed.7 <- update(speed.6, .~. + looks:gender:personality)

anova(speed.base, speed.1, speed.2, speed.3, speed.4, speed.5, speed.6, speed.7)

speed.all <- lme(rating ~., random = ~1|participant/looks/personality, data = speeddatingData,
                 method = "ML")
summary.lm(speed.all)

# relationship data ----
relationshipData <- read.delim("Schutzwohl(2008).dat", header = TRUE)
# factorize and restructure
relationshipData$Gender <- factor(relationshipData$Gender, levels = c(1:2),
                                  labels = c("male", "female"))
relationshipData <- melt(relationshipData,
                         id = c("Participant", "Gender", "Relationship",
                                "Distractor_Colour", "Target_Neutral", "Target_Emotional",
                                "Target_Sexual", "Age"), 
                         measured = c("Distracter_Neutral", "Distracter_Emotional",
                         "Distracter_Sexual"))
relationshipData <- melt(relationshipData,
                         id = c("Participant", "Relationship", "Gender", "Age",
                                "variable", "value", "Distractor_Colour"), 
                         measured = c("Target_Neutral", "Target_Emotional",
                         "Target_Sexual"))

names(relationshipData) <- c("Participant", "Relationship", "Gender", "Age",
                             "Distractor_type", "Distractor_value", "Distractor_colour",
                             "Target_type", "Target_value")

menData <- relationshipData[order(relationshipData$Gender),]
menData <- subset(menData, Gender == "male")

femaleData <- relationshipData[order(relationshipData$Gender),] 
femaleData <- subset(femaleData, Gender == "female")

# fit three-way ANOVA for genders individually
men.fit    <- aov(Target_value ~ Relationship*Age*Distractor_value, data = menData)
female.fit <- aov(Target_value ~ Relationship*Age*Distractor_value, data = femaleData)
men.fit    <- lme(Target_value ~ Relationship*Age*Distractor_value, random = ~1|Participant ,data = menData,
                  method = "ML")
female.fit <- lme(Target_value ~ Relationship*Age*Distractor_value, random = ~1|Participant ,data = femaleData,
                  method = "ML")

# mixed attitude data ----
attitudeData <- read.delim("MixedAttitude.dat", header = TRUE)
attitudeData <- melt(attitudeData, id = c("Participant", "gender"),
                     measured = c("beerpos", "beerneg", "beerneut",
                                  "waterpos", "waterneg", "waterneut",
                                  "winepos", "waterneg", "waterneut"))
attitudeData$drinks  <- gl(3, 60, labels = c("Beer", "Wine", "Water"))
attitudeData$imagery <- gl(3, 20, labels = c("positive", "negative", "neutral"))

# fit mixed model using ezANOVA and lme functions
attitude.fit <- ezANOVA(data = attitudeData, wid = Participant, dv = value, between = gender,
                        within = .("drinks", "imagery"), detailed = TRUE)
attitude.lme <- lme(value ~ drinks*imagery*gender, random = ~1|Participant/drinks/imagery,
                    method = "ML", data = attitudeData)

# text messages data ----
msgData <- read.delim("TextMessages.dat", header = TRUE)
msgData$participant <- c(1:50)
msgData <- melt(msgData, id = c("participant", "Group"),
                measured = c("Baseline", "Six_months"))
names(msgData) <- c("Participant", "Group", "Time", "Score")

msg.fit <- ezANOVA(data = msgData, dv = Score, within = Time, between = Group,
                   wid = Participant, detailed = TRUE)

# big brother data ----
bigbroData <- read.delim("BigBrother.dat", header = TRUE)
bigbroData$bb <- factor(bigbroData$bb, levels = c(0:1), labels = c("Ctrl", "Got in"))
bigbroData <- melt(bigbroData, id = c("Participant", "bb"),
                   measured = c("time1", "time2"))
names(bigbroData) <- c("Participant", "bb", "time", "score")
bigbro.fit <- ezANOVA(data = bigbroData, dv = score, within = time, between = bb,
                      wid = Participant, detailed = TRUE)
