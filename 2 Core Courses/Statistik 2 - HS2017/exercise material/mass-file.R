# Bonus quizzes

# V2
# Bonus 1
wd <- "C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data2"
setwd(wd)

a <- 3.44
b <- 6.51
x <- 4.04
e <- -0.38
y <- exp(sqrt(a) + log(b)*log(x) + e) # y=59.76 is correct. DONT use log10!

load("ueb229305.rda")
fm1 <- lm(y3~x, data=dat)
summary(fm1)

load("ueb72586.rda ")
fm2 <- lm(y~x1, data=dat)
confint(fm2, level=0.99)
summary(fm2)

fm3 <- lm(y~., data=dat)
summary(fm3)
beta0 <- -0.5168
betax1 <- -0.5549
betax2 <- 1.8347
x1 <- 0.01
x2 <- -0.66
y <- beta0 + betax1*x1 + betax2*x2


# V3
# Bonus 1
setwd("C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data3")
load("ueb113641.rda")
fm4 <- lm(y~g*x, data=dat)
summary(fm4)
confint(fm4, level=0.95)



# V10 - Power analysis
# Bonus 1
setwd("C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data10")

?dnorm # density distribution fir normal distr
?pt # distribution function for t-distr
?qnorm # quantile function for normal distr
?rbinom # random generation for binomial distr

dnorm(x=-2.8, mean=-4.3, sd=3.24) # Sei X ~ N(-4.3, 3.24). Wie gross ist P(X <= x) für x = -2.8?
pbinom(q=2, 10, 0.7) # Sei X ~ Binom(10, 0.7). Wie gross ist P(X = x) für x = 2?
dbinom(x=-4, 20, 0.5) # Sei X ~ Binom(20, 0.5). Wie gross ist P(X > x) für x = 4?
set.seed(2232)
rnorm(n=13, 7.3, 0.16)

load("ueb163144.rda")
set.seed(7885)

machttest1 <- function(N, beta0, betaA, reps, alpha) {
  res <- vector('numeric', reps)
  for (i in 1:reps){
    X_sim <- sim(N, betaA)
    p.val <- test(X_sim, beta0)
    res[i] <- (p.val < alpha)
  }
  list(m=mean(res), s=sd(res)/sqrt(reps))
}
machttest1(13,53,55,94,0.06)

set.seed(750)
lis1 <- machttest1(10,45,50,46,0.06)
lis2 <- machttest1(10,45,54,46,0.06)
lis1$m - lis2$m

set.seed(1140)
lis1 <- machttest1(11,38,41,54,0.06)
lis2 <- machttest1(22,38,41,54,0.06)
lis1$m - lis2$m

set.seed(1378)
lis1 <- machttest1(7,53,58,11,0.03)
lis2 <- machttest1(7,53,58,22,0.03)
lis1$s - lis2$s

load("ueb929712.rda")
set.seed(4120)
n1 <- 11
n2 <- 22
n <- c(11,22)
lis1 <- machtAnova1(n)
lis1$m

set.seed(794)
lis1 <- machtFisher(p2=0.4)
lis2 <- machtFisher(p2=0.5)
lis1$m - lis2$m

set.seed(7533)
machtTtest2(n1=15, n2=28, m1=13, m2=11, s1=3, s2=1.8, alt="greater")

set.seed(6322)
machtFisher(n1=35, n2=50, p1=0.9, p2=0.8, alpha=0.04)

# Solutions of this bonus quiz:
Sei X ~ N(-4.3, 3.24). Wie gross ist P(X <= x) für x = -2.8?
Mit pnorm(-2.8, -4.3, 1.8) kann die gesuchte Wahrscheinlichkeit ausgerechnet werden. Somit ist die Lösung 0.798.
Sei X ~ Binom(10, 0.7). Wie gross ist P(X = x) für x = 2?
Mit dbinom(2, 10, 0.7) kann die gesuchte Wahrscheinlichkeit ausgerechnet werden. Somit ist die Lösung 0.001.
Sei X ~ Binom(20, 0.5). Wie gross ist P(X > x) für x = 4?
Mit pbinom(4, 20, 0.5, FALSE) oder 1 - pbinom(4, 20, 0.5) kann die gesuchte Wahrscheinlichkeit ausgerechnet werden. Somit ist die Lösung 0.994.
Sei X ~ N(7.3, 0.16). Setze set.seed(2232). Ziehe dann 13 Realisationen von dieser Verteilung. Berechne anschliessend den Mittelwert.
Was ist die Differenz zwischen dem Mittelwert und mu = 7.3?  Geben Sie eine positive Zahl ein.
Mit rnorm(13, 7.3, 0.4) können Realisationen gezogen werden. Der Mittelwert kann mit mean(...) ausgerechnet werden. Die Lösung ist 0.038.

Sei X ~ t(3). Für welches x gilt P(X <= x) = 0.6?
Mit qt(0.6, 3) kann das gesuchte Quantil berechnet werden. Somit ist die Lösung 0.277.
Sei X ~ Binom(11, 0.4). Setze set.seed(7408). Ziehe dann 9 Realisationen von dieser Verteilung.
Berechne anschliessend den Standard-Schätzer für p. Wie gross ist dieser?
Mit mean( rbinom(9, 11, 0.4)/11 ) kann der Standard-Schätzer für p berechnet werden. Somit ist die Lösung 0.374.


# Bonus Quiz 2 - V10
pnorm(-8.2, -6.5, 0.36)
dbinom(6, 12, 0.9)
pbinom(1, 10, 0.7, FALSE)

# Macht von z-test
alpha <- 0.05
s <- sqrt(5.29)
mu0 <- -0.9
muA <- -0.4
n <- 21
c <- qnorm(alpha, mu0, s/sqrt(n), FALSE)   # c: P_H0(T > c) = alpha
macht1 <- pnorm(c, muA, s/sqrt(n), FALSE)   # P_HA(T > c)


alpha <- 0.05
s <- sqrt(5.29) # sqrt: depends from where you got the value - only needed if it was obtained from sigma^2
mu0 <- -0.9
muA <- -0.4
n <- 42
c <- qnorm(alpha, mu0, s/sqrt(n), FALSE)   # c: P_H0(T > c) = alpha
macht2 <- pnorm(c, muA, s/sqrt(n), FALSE)   # P_HA(T > c)
macht1- macht2


set.seed(6343)
m1 <- machtTtest1(alpha=0.03)
m2 <- machtTtest1(alpha=0.003)
m1$m - m2$m

set.seed(7835)
machtTtest2(n1=14, n2=29, s1=3.9, s2=2.5, m1=17, m2=14, alt = "greater")

set.seed(4341) 
machtFisher(n1=55, n2=47, p1=0.3, p2=0.6, alpha=0.04)

set.seed(9404)
n <- 36
s <- 1.2
alpha <- 0.02
fm <- lm()


# VL 7
# Bonus quiz 1
setwd("C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data7")
load("ueb841170.rda")
mean(dat$y)
fma <- aov(y~., data = dat)
TukeyHSD(fma, conf.level=0.99)
summary(fma)

load("ueb897644.rda")
fma <- aov(y~., data = dat)
summary(fma)

# Bonus quiz 2
load("ueb667726.rda")
mean(dat$y[dat$M=='M4'])
TukeyHSD(aov(y~., data = dat), conf.level = 0.99)
# ohne Korrektur
t.test(dat$y[dat$M=='M2'], dat$y[dat$M=='M1'], conf.level = 0.99)

# Bonus quiz 3
load("ueb286169.rda")
mean(dat$y[dat$M=='M2'])
min(dat$y)
alpha <- 0.99
K <- 15
# Bonferroni-Korrektur
t.test(dat$y[dat$M=='M4'], dat$y[dat$M=='M3'], conf.level = 1-(1-alpha)/K) 


# V9 - Bonus quiz 1
setwd("C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data9")
load("ueb999050.rda")
# find the sum of healed, not healed, med and placebo
g <- sum(dat$A2=='G')
n <- sum(dat$A2=='N')
m <- sum(dat$B2=='M')
p <- sum(dat$B2=='P')
mat <- matrix(c(g,n,m,p), 2,2)
fm <- fisher.test(mat, alternative = 'greater')
summary(fm$p.value)
summary(fm$conf.int)

tab <- xtabs(Freq ~ A+B, data = dat)
chis <- chisq.test(tab)
max(abs(chis$residuals))

glm(A2 ~ B2, data = dat, family = binomial)


# V8 - Bonus quiz 2
setwd("C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data8")
load("ueb133896.rda")
fm <- aov(y~M+G, data = dat)
TukeyHSD(fm, conf.level=0.99)
summary(fm)

load("ueb265652.rda")
fm <- aov(y ~ M*G, data = dat)
summary(fm)

# VL 5 - Bonus Quiz 2
setwd("C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data5")
load("ueb362772.rda")
fm <- glm(y ~ x*g, data = dat0, family = "binomial")
summary(fm)
predict.glm(fm, newdata = dat1[101, ], type = "response")
