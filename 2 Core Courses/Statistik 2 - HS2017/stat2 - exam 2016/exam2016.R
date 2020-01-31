# Exam 2016

setwd("C:/Users/made_/Desktop/Statistik 2 - HS2017/stat2 - exam 2016")

# Ex. 5
library("stats")
s <- 2.5
alpha <- 0.05
n <- 20
mu_old <- 5
mu_new <- 8

power.t.test(20, 3, 2.5, 0.05, type = "two.sample", alternative = "one.sided")

# Ex. 9
load("chisq.rda")
# Tabelle konstruieren
tab1 <- xtabs(Freq ~ Treatment + Improvement, data = df)
fm <- chisq.test(tab1)
fm$p.value
fm$residuals

# Ex. 18
dat <- read.csv("lernen.csv")
fm <- lm(y ~ x1, data = dat)
summary(fm)
confint(fm)

fm <- lm(y ~ x1 + x2*q, data = dat)
summary(fm)
x1 <- 1.12
x2 <- 3.75
q <- "M"
frame <- data.frame(x1,x2,q)
predict.lm(fm, newdata = frame)
predict.lm(fm, newdata = frame, interval = "prediction", level = 0.95)

# Ex. 29
load("sport.rda")
min(dat$weight)

# RIRS Modell
library("lme4")
fm <- lmer(weight ~ week + (week|person), data = dat)
fm2 <- lm(weight ~ week:person, data = dat)
fm2 <- lmer(weight ~ week + (1|person), data = dat)
anova(fm, fm2)

# Ex. 35
load("rauchen.rda")
which(df$x>9) # gibt an welche Zeile jeweils. hier: 2.
fm <- glm(y ~ x*g, data = df)
summary(fm)
