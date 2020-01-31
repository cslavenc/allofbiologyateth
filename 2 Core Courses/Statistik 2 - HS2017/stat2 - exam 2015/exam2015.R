# Exam 2015

# Question 7
mat <- matrix(c(30, 10, 17, 23), 2,2)
fit <- fisher.test(mat, alternative = 'greater')
fit$conf.int
fit$estimate

# Q8
n <- 45
alpha <- 0.05
p0 <- 0.2
pA <- 0.5

machtBinom <- function(n = 50 , reps = 1000 , alpha = 0.05 , pA = 0.7 , p0
                       = 0.5 , alt = 'two.sided') {
  res <- vector('numeric' , reps)
  for (i in 1:reps) {
    x <- rbinom(n = 1 , size = n , prob = pA)
    tmp <- binom.test(x , n = n , p = p0 , alternative = alt)
    res[i] <- (tmp$p.value < alpha)
  }
  list (m = mean(res), s = sd(res)/sqrt(reps))
}
machtBinom(n, reps=1000, alpha=0.05, pA=0.5, p0=0.2, alt='greater')


# Q9
getwd()
wd <- 'C:/Users/made_/Desktop/stat2 - exam 2015'
setwd(wd)
load('examANOVA_Impf.rda')

fitaov <- aov(y ~ p, data = dat)
summary(fitaov)
TukeyHSD(fitaov)
plot(TukeyHSD(fitaov))

library(multcomp)
K1 <- c(1,0,-1,0)
glht(fitaov, linfct = mcp(x = K1))

fitaov2 <- aov(y~g+p, data = dat)
summary(fitaov2)
TukeyHSD(fitaov2)


# Q27
dat1 <- read.csv('linmod.csv')
fit2 <- glm(y ~ x1*x2, data=dat1)
summary(fit2)
fit2$cont.int


# Q41
load('pca.rda')
pr.out <- prcomp(dpca)
show(pr.out)
