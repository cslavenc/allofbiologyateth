#Quiz 1

#Ex.1
dat1 <- read.csv("ueb885938DAT32.csv", header=0)
dat2 <- read.csv("ueb885938DAT23.csv", header=TRUE)

vec <- c(89,91,1,79)
write.csv(vec,"VEC.csv")
?write.csv

x <- dat2[2:28,2]
print(x)
xmean <- mean(x)
print(xmean)

#Ex.2
dat3 <- readRDS("ueb742905.rds")
print(dat3[34])

dat4 <- load("ueb742905.rda")
print(dat4)

myname <- "slaven"
saveRDS(myname, "myname.RDS")
myname_ <- readRDS("myname.RDS")
print(myname_)

#delete workspace and reload it
save(dat1,dat2,dat3,dat4,vec,myname,myname_,x,xmean, file="quiz1_ws2.RDATA")
load("quiz1_ws.RDATA")


#Ex.3
dat <- read.csv("ueb268070.csv")
dat_ <- load("ueb268070.rda")
summary(dat)

x1 <- 1-2*dat[2]+dat[3]
print(x1)

x_ <- c(TRUE,FALSE,FALSE)
y_ <- !x_
print(y_)
z = x_/y_
print(z)  #prints 0, but solution should be 1 (TRUE)??
