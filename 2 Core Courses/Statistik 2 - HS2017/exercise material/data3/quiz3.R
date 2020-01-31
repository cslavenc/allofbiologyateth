# Quiz 3
getwd()
setwd("C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data3")

# Question 2
load("ueb222178.rda")

levels(dat$g)
dat$g <- relevel(dat$g, ref = 'W')
fm <- lm(dat$y ~ dat$x + dat$g + dat$x:dat$g)
summary(fm)

#pred <- data.frame(dat$x = 1, g="M")
predict.lm(fm, newdata=pred)


fm2 <- lm(dat$y ~ dat$x + dat$g)
summary(fm2)
t.test(dat$x, data=dat, conf.level = 0.90)


