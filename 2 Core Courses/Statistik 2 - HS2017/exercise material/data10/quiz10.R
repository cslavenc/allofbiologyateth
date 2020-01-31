# Quiz 10
wd <- "C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data10"
setwd(wd)
install.packages("pwr")
library("pwr")

# Exercise 1
?dnorm # normal distribution
?qnorm
?pt # t-Student test; distribution function
?rbinom # binomial distribution; generates random deviates
alpha <- 0.05

mean1 <- -8.1
sd1 <- 0.25
x1 <- -10.1
res1 <- dnorm(x1, mean1, sd1)

mean2 <- 13
sd2 <- 0.1
x2 <- 1
res2 <- dbinom(x2, mean2, sd2)

df3 <- 4
res3 <- 0.6
r <- pt(0.270725,df3) #trying to make an educated guess for x=0.270725

# part d
set.seed(7408)
mean4 <- 11
sd4 <- 0.4
n4 <- 9
x4 <- rbinom(n4, 11, 0.4)
p_mle <- sum(x4)/(9*11)

# Exercise 2
load("ueb532490.rda")
set.seed(6841)
N <- 13
reps <- 75
beta0 <- 32
betaA <- 36
alpha <- 0.03

machttest1 <- function(N, beta0, betaA, reps, alpha) {
  res <- vector('numeric', reps)
  for (i in 1:reps){
    X_sim <- sim(N, betaA)
    p.val <- test(X_sim, beta0)
  res[i] <- (p.val < alpha)
  }
  list(m=mean(res), s=sd(res)/sqrt(reps))
}

machttest1(N, beta0, betaA, reps, alpha)

# part b
set.seed(7656)
tmp1 <- machttest1(7, 52, 53, 51, 0.06)
tmp2 <- machttest1(7, 52, 58, 51, 0.06)
tmp1$m - tmp2$m

# part c
set.seed(3097)
tmp1 <- machttest1(12, 55, 58, 64, 0.04)
tmp2 <- machttest1(24, 55, 58, 64, 0.04) 
tmp1$m - tmp2$m

# part d
set.seed(884)
tmp1 <- machttest1(15, 60, 63, 14, 0.04)
tmp2 <- machttest1(15, 60, 63, 28, 0.04) 
tmp1$s - tmp2$s

    
# Exercise 3
load("ueb710862.rda")
set.seed(9)
tt1 <- machtTtest2(alt = "greater")
tt2 <- machtTtest2()
tt1$m - tt2$m

# part b
set.seed(4500)
tt1 <- machtLM(s=2)
tt2 <- machtLM(s=4)
tt1$m - tt2$m

# part c
set.seed(8029)
tt1 <- machtAnova1(n=c(14,14,14))
tt2 <- machtAnova1(n=c(28,28,28))
tt1$m - tt2$m

# part d - could not find correct answer
set.seed(8741)
vol <- 1.7
alpha <- 0.05
n <- 35
sd <- 0.9
volA <- 1.5
d <- (vol-volA)/sd
sim_d <- rt(n=n, df=68) # df = n+n - 2
temp <- t.test(sim_d)
