# plant biology practical
# Exp. 3 day 1 - evaluation
library("mvoutlier")
getwd()
setwd('C:/Users/made_/Desktop/ETH/Core Courses/Biologiepraktikum 2/plant biology/Day 2')
# data matrix
?cbind
# [pea_light, barley_light, pea_dark, barley_dark]
mat <- matrix(c(2.6, 3.4, 2.1, 2.1, 3.6, 2.7, 3.4, 2.5, 2.4, 4.7,
         8.4, 8.5, 5.8, 4.5, 7.5, 7.2, 8.4, 7.8, 7.4, 9.0,
         4.5, 5.3, 3.6, 3.9, 4.3, 3.2, 4.5, 4.2, 4.6, 4.4,
         4.0, 4.4, 8.4, 10.5, 8.1, 9.0, 7.0, 7.2, 10.0, 8.5),
         nrow=10, ncol=4)
?write.csv
#write.csv(mat) # wrong function, I want data ouptut in the folder
mean(mat[,1]) # pea light
mean(mat[,2]) # barley light
mean(mat[,3]) # pea dark
mean(mat[,4]) # barley dark
vec <- as.vector(mat)

plot(vec)
?pcout
pcout(mat, makeplot=1)
