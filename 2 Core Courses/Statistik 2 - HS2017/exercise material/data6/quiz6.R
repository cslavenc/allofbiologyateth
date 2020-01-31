# Quiz 6
# install.packages("lfe")
# library(lfe)

getwd()
wd <- "C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data6"
setwd(wd)


# Exercise 1

dat <- load("ueb765104.rda")
summary(dat)

# Fixed effects models known as linear regression simply

fm01 <- lm(y ~ x+R, data=dat) # ohne WW
fm02 <- lm(y ~ x*R, data=dat) # mit WW - wieviele geschätze Koeffizienten? 13 = 2*6 + 1
summary(fm01)
summary(fm02)
confint(fm01, level=0.95)

fm1 <- lmer(y ~ x + (x|R), data=dat) # RIRS
fm2 <- lmer(y ~ x + (1|R), data=dat) # RI
ranef(fm1)
summary(fm1)
summary(fm2)

confint(fm1)
confint(fm2)

