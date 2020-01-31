# Quiz 7
wd <- "C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data7"
setwd(wd)


# Exercise 2
load("ueb830054.rda")
summary(dat)
fm = aov(y ~ M, data=dat)
summary(fm)

# Exercise 3
load("ueb579560.rda")
summary(dat)
fm2 <- aov(y ~ M, data=dat)
summary(fm2)

# Part d - contrast analysis
library(multcomp)
K <- rbind("M1-P" = c(1,0,0,0,0,0,-1),
           "M2-P" = c(0,1,0,0,0,0,-1),
           "M3-P" = c(0,0,1,0,0,0,-1),
           "M4-P" = c(0,0,0,1,0,0,-1),
           "M5-P" = c(0,0,0,0,1,0,-1),
           "M6-P" = c(0,0,0,0,0,1,-1))
colnames(K) <- levels(dat$M)
K # only to look if everything is correct
summary(glht(fm2, linfct = mcp(M=K)))
