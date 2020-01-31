      # Quiz 13
# PCA

wd <- "C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data13"
setwd(wd)
load("ueb716565.rda")

pr.out <- prcomp(dat)
summary(pr.out$x[120,77])
sumy <- summary(pr.out)
sumy$importance[2,3]
which(sumy$importance[3,] > 0.31)[1]
pve <- sumy$importance[2,]
cpve <- sumy$importance[3,]
plot(pve)
plot(cpve)
