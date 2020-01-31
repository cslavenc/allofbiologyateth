# Set working directory
getwd()
setwd("C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data2")

load("ueb498952.rda")
fm <- lm(y3 ~ x, data = dat)
summary(fm)


load("ueb309872.rda")
#linear regression
fm2 <- lm(y ~ x2, data=dat)
summary(fm2)

confint(fm2, level=0.90)

