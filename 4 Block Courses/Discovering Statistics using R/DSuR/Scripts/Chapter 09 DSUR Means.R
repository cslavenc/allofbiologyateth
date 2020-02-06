#---------------------------------------------------------------------------------------------------------
#R Code for Chapter 9 of:
#
#Field, A. P., Miles, J. N. V., & Field, Z. C. (2012). Discovering Statistics Using R: and Sex and Drugs and Rock 'N' Roll. #London Sage
#
#(c) 2011 Andy P. Field, Jeremy N. V. Miles & Zoe C. Field
#-----------------------------------------------------------------------------------------------------------




#----Set the working directory------

setwd("~/Documents/Academic/Data/DSU_R/Chapter 09 (t-tests)")
imageDirectory<-"~/Documents/Academic/Books/Discovering Statistics/DSU R/DSU R I/DSUR I Images"

setwd("~/Public/Academic/Data/DSU_R/Chapter 09 (t-tests)")
imageDirectory<-"~/Public/Academic/Books/Discovering Statistics/DSU R/DSU R I/DSUR I Images"


#----Install Packages-----
install.packages("ggplot2")
install.packages("pastecs")
install.packages("WRS")


#------And then load these packages, along with the boot package.-----
library(ggplot2)
library(pastecs)
library(reshape)

# library(Rcmdr)
# library(WRS)
# source("http://www-rcf.usc.edu/~rwilcox/Rallfun-v14")


#load the data

spiderWide<-read.delim("SpiderWide.dat", header = TRUE)
spiderLong<-read.delim("SpiderLong.dat", header = TRUE)


#enter the data manually

picture<-c(30, 35, 45, 40, 50, 35, 55, 25, 30, 45, 40, 50)
real<-c(40, 35, 50, 55, 65, 55, 50, 35, 30, 50, 60, 39)
spiderWide<-data.frame(picture, real)

Group<-gl(2, 12, labels = c("Picture", "Real Spider"))
Anxiety<-c(30, 35, 45, 40, 50, 35, 55, 25, 30, 45, 40, 50, 40, 35, 50, 55, 65, 55, 50, 35, 30, 50, 60, 39)
spiderLong<-data.frame(Group, Anxiety)


#adjust the repeated measures data

rmMeanAdjust<-function(dataframe)
{
	varNames<-names(dataframe)
	
	pMean<-(dataframe[,1] + dataframe[,2])/2
	grandmean<-mean(c(dataframe[,1], dataframe[,2]))
	adj<-grandmean-pMean
	varA_adj<-dataframe[,1] + adj
	varB_adj<-dataframe[,2] + adj
	
	output<-data.frame(varA_adj, varB_adj)
	names(output)<-c(paste(varNames[1], "adj", sep = "_"), paste(varNames[2], "adj", sep = "_"))
	return(output)
}


rmMeanAdjust(spiderWide)


spiderWide$pMean<-(spiderWide$picture + spiderWide$real)/2
grandMean<-mean(c(spiderWide$picture, spiderWide$real))
spiderWide$adj<-grandMean-spiderWide$pMean
head(spiderWide)

spiderWide$picture_adj<-spiderWide$picture + spiderWide$adj
spiderWide$real_adj<-spiderWide$real + spiderWide$adj

spiderWide$pMean2<-(spiderWide$picture_adj + spiderWide$real_adj)/2

#plot the adjusted means

spiderWide$id<-gl(12, 1, labels = c(paste("P", 1:12, sep = "_")))
adjustedData<-melt(spiderWide, id = c("id", "picture", "real", "pMean", "adj", "pMean2"), measured = c("picture_adj", "real_adj"))
adjustedData <-adjustedData[, -c(2:6)]
names(adjustedData)<-c("id", "Group", "Anxiety_Adj")
adjustedData$Group<-factor(adjustedData$Group, labels = c("Spider Picture", "Real Spider"))

bar <- ggplot(adjustedData, aes(Group, Anxiety_Adj))
bar + stat_summary(fun.y = mean, geom = "bar", fill = "White", colour = "Black") + stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + labs(x = "Type of Stimulus", y = "Anxiety") + scale_y_continuous(limits = c(0, 60), breaks = seq(from = 0, to = 60, by = 10))
ggsave(file = paste(imageDirectory,"09 spider RM bar.png",sep="/"))



#Self-Test: t-test as a GLM

t.test.GLM<-lm(Anxiety ~ Group, data = spiderLong)
summary(t.test.GLM)


#computing t-test from means and SDs

x1 <- mean(spiderLong[spiderLong$Group=="Real Spider", ]$Anxiety)
x2 <- mean(spiderLong[spiderLong $Group=="Picture", ]$Anxiety)
sd1 <- sd(spiderLong[spiderLong $Group=="Real Spider", ]$Anxiety)
sd2 <- sd(spiderLong[spiderLong $Group=="Picture", ]$Anxiety)
n1 <- length(spiderLong[spiderLong $Group=="Real Spider", ]$Anxiety)
n2 <- length(spiderLong[spiderLong $Group=="Picture", ]$Anxiety)

ttestfromMeans<-function(x1, x2, sd1, sd2, n1, n2)
{	df<-n1 + n2 - 2
	poolvar <- (((n1-1)*sd1^2)+((n2-1)*sd2^2))/df
	t <- (x1-x2)/sqrt(poolvar*((1/n1)+(1/n2)))
	sig <- 2*(1-(pt(abs(t),df)))
	paste("t(df = ", df, ") = ", t, ", p = ", sig, sep = "")

}

ttestfromMeans(x1, x2, sd1, sd2, n1, n2)



#plot the data
spiderBoxplot <- ggplot(spiderLong, aes(Group, Anxiety))
spiderBoxplot + geom_boxplot() + labs(x = "Type of Stimulus", y = "Anxiety") + scale_y_continuous(limits = c(0, 100), breaks = seq(from = 0, to = 100, by = 10))
ggsave(file = paste(imageDirectory,"09 spider boxplot.png",sep="/"))

bar <- ggplot(spiderLong, aes(Group, Anxiety))
bar + stat_summary(fun.y = mean, geom = "bar", fill = "White", colour = "Black") + stat_summary(fun.data = mean_cl_normal, geom = "pointrange") + labs(x = "Type of Stimulus", y = "Anxiety") + scale_y_continuous(limits = c(0, 60), breaks = seq(from = 0, to = 60, by = 10))
ggsave(file = paste(imageDirectory,"09 spider bar.png",sep="/"))

#describe the data
by(spiderLong$Anxiety, spiderLong$Group, stat.desc, basic = FALSE, norm = TRUE)

stat.desc(spiderWide$picture, basic = FALSE, norm = TRUE)
stat.desc(spiderWide$real, basic = FALSE, norm = TRUE)

# t-test

ind.t.test<-t.test(Anxiety ~ Group, data = spiderLong)
ind.t.test

ind.t.test<-t.test(spiderWide$real, spiderWide$picture)
ind.t.test


#Effect sizes

t<-ind.t.test$statistic[[1]]
df<-ind.t.test$parameter[[1]]
r <- sqrt(t^2/(t^2+df))
round(r, 3)

#Robust tests

#Independent groups
yuen(spiderWide$real, spiderWide$picture, tr=.2, alpha=.05)
yuenbt(spiderWide$real, spiderWide$picture, tr=.2, alpha=.05, nboot = 2000)
#CI
pb2gen(spiderWide$real, spiderWide$picture, alpha=.05, nboot=2000, est=mom)


#normality of differences

spiderWide$diff<-spiderWide$real-spiderWide$picture
stat.desc(spiderWide$diff, basic = FALSE, desc = FALSE, norm = TRUE)





#Dependent t test

stat.desc(spiderWide, basic = FALSE, norm = TRUE)

dep.t.test2<-t.test(Anxiety ~ Group, data = spiderLong, paired = TRUE)
dep.t.test2

dep.t.test<-t.test(spiderWide$real, spiderWide$picture, paired = TRUE)
dep.t.test

t<-dep.t.test$statistic[[1]]
df<-dep.t.test$parameter[[1]]
r <- sqrt(t^2/(t^2+df))
round(r, 3)

yuend(spiderWide$real, spiderWide$picture, tr=.2, alpha=.05)
ydbt(spiderWide$real, spiderWide$picture, tr=.2, alpha=.05, nboot = 2000)
CI
bootdpci(spiderWide$real, spiderWide$picture, est=tmean, nboot=2000)




