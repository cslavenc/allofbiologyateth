# Mixed Effects Models book
getwd()
wd <- "C:/Users/made_/Desktop/ETH/4 Block Courses/Discovering Statistics using R/MEMoR/data"
setwd(wd)  # location of data files


library(AED)  # not available
# instead use this link to download the data:
dl <- "http://www.highstat.com/index.php/mixed-effects-models-and-extensions-in-ecology-with-r"

# Search packages ----
ap <- available.packages()
View(ap)
"AED" %in% rownames(ap)

# libraries ----
library(nlme)
library(lattice)

# Chapter 4 ----
# Squid data ----
squidData <- read.delim("Squid.txt", header = TRUE)
# use gls instead of lm if variance is heterogeneous
squid.lm <- gls(Testisweight ~ DML * MONTH, data = squidData, na.action = na.omit)
vf1Fixed <- varFixed(~DML)  # this means: sigma^2 * DML
squid.gls1 <- gls(Testisweight ~ DML*MONTH, data = squidData, na.action = na.omit,
                  weights = vf1Fixed)
anova(squid.lm, squid.gls1)  # gls1 is better

# this accounts for different std dev in the month
vf2 <- varIdent(form = ~1|MONTH)
squid.gls2 <- gls(Testisweight ~ DML*MONTH, data = squidData, na.action = na.omit,
                  weights = vf2)
anova(squid.lm, squid.gls1, squid.gls2)

# sigma^2 * abs(DML)^2delta, delta needs to be estimated, dont use if there are vals = 0
vf3 <- varPower(form = ~DML)
squid.gls3 <- gls(Testisweight ~ DML*MONTH, data = squidData, na.action = na.omit,
                  weights = vf3)
anova(squid.gls1, squid.gls3)

# varExp if ther are negative vals and 0
# varConstPower if there are many vals close to 0

# biodiversity data ----
biodivData <- read.delim("Biodiversity.txt", header = T)
# make factors
biodivData$Treatment <- factor(biodivData$Treatment)
biodivData$Nutrient  <- factor(biodivData$Nutrient)
boxplot(Concentration ~ Treatment*Nutrient, data = biodivData)
biodiv.lm <- lm(Concentration ~ Treatment*Nutrient*Biomass, data = biodivData)

# apply gls

biodiv.gls2 <- gls(Concentration ~ Nutrient*Treatment*Biomass, data = biodivData)
biodiv.gls3 <- gls(Concentration ~ Nutrient*Treatment*Biomass, data = biodivData,
                   weights = varIdent(form = ~1|Treatment*Nutrient))
anova(biodiv.gls2, biodiv.gls3)
summary(biodiv.gls3)

# Chapter 5 ----
# Beach data ----
beachData <- read.delim("RIKZ.txt", header = T)
beachData$Beach <- factor(beachData$Beach)

f1 <- formula(Richness ~ NAP*Beach)
beach.mi1 <- lme(Richness ~ NAP*Beach, data = beachData, random = ~1|Beach)
beach.mi2 <- lme(f1, data = beachData, random = ~NAP|Beach)
anova(beach.mi1, beach.mi2)  #. RI model has lower AIC

summary(beach.mi1)


