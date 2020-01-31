# Biology Practical resul evaluation

# Exp. 4 - C4
f <-  function(w_init, w_final){
  return (abs(w_final-w_init))/w_init *100}

w_init <- c(2.01, 2.04, 2.01, 2.09, 2.02, 1.97)
w_final <- c(2.41, 2.43, 2.35, 2.15, 1.89, 1.67)
y <- f(w_init, w_final)
x <- c(0, 0.1, 0.2, 0.3, 0.4, 0.5)

fm <- lm(y~x)
summary(fm)

# Exp. 1 - E15
ext2 <- c(0.022,  0.174,  0.341,  1.348,  1.659,  2.246)
gluc_sol <- c(0, 5, 10, 20, 30, 40)

fm <- lm(ext2~gluc_sol)
summary(fm)
sd(ext2)
