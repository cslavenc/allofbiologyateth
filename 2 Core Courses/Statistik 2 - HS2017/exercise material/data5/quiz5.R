# Quiz 5
# Exercise 1
 

# Exercise 2
getwd()
wd <- wd <- "C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data5"

setwd(wd)

dat <- load('ueb537501.rda')
fm1 <- glm(y ~ x , dat0, family=binomial)
new <- data.frame(x=122)
lo  <- predict.glm(fm1, newdata=new, type="link", se.fit=TRUE)
res <- predict.glm(fm1, newdata=dat0[122,], type="response", se.fit=TRUE)
print(res)

# part c
fm2 <- glm(y~x+g, dat0, family=binomial)
new2 <- data.frame(x=1)
lo2 <- predict.glm(fm2, newdata=new2, type="link", se.fit = TRUE)
res2 <- predict.glm(fm2, newdata=dat0[1,], type="response", se.fit=TRUE)
print(res2)

# part d
fm3 <- glm(y~x*g, dat0, family=binomial)
pp3 <- predict.glm(fm3, newdata=dat1, type="response")
class <- (pp3 >= 0.5)
classn <- as.numeric(class)
s = sum(classn == dat1$y)
print(s)