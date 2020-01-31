# Quiz 8
wd <- "C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data8"
setwd(wd)
load("ueb320020.rda") # saved as dat

# Exercise 1
# F.M = ? df_Res = 130 (p=14) => F.M_4;130 = ?
# MS.r = 399.3/130 = 3.072 => MS.M/MS.r = 48.875/3.072 = 15.912

# Exercise 3
mHemo <- median(dat$y)
fm1 <- aov(y ~ M + G, data=dat)
confint(fm1, level=0.99)
summary(fm1)

fm2 <- aov(y ~ M*G, data=dat)
confint(fm2, level=0.999)
summary(fm2)

TukeyHSD(fm2, which = "G", conf.level=0.935)
