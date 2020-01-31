# Quiz 4
getwd()
wd <- "C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data4"
setwd(wd)
dir()

# Question 1
datas <- load("ueb455154.rda")
fm0 <- lm(y ~ 0, dat)

summary(fm0)
rss0 <- sum(fm0$residuals^2)
mse0train <- mean(fm0$residuals^2)

# part c
fm1 <- lm(dat$y ~x1, dat)
fm3 <- lm(dat$y ~x1+x2+x3, dat)

mse1train <- mean(fm1$residuals^2)
mse3train <- mean(fm3$residuals^2)
abs(mse3train - mse1train)

# part d
fm8 <- lm(y~., dat)
summary(fm8)
rse8 <- 3.244
bic8 <- (mean(fm8$residuals^2) + log(96) * 8 * rse8^2)/96
bic0 <- (mean(fm0$residuals^2))/96
bic_diff <- abs(bic8-bic0)
print(bic_diff)


# Question 2
load("ueb277297.rda")
library(leaps)
fitforw <- regsubsets( y ~ ., data = dat, method = "forward", nvmax = 5) 
fitback <- regsubsets( y ~ ., data = dat, method = "backward", nvmax = 5) 
fitbest <- regsubsets( y ~ ., data = dat, method = "exhaustive", nvmax = 5)
summary(fitback)
ncoef <- which.min(summary(fitback)$bic)
coef(summary(fitback), ncoef)
  