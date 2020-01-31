getwd()
wd <- "C:/Users/made_/Desktop/Statistik 2 - HS2017/exercise material/data9"
setwd(wd)

# Exercise 1
# 116 * 72 / 368

# Exercise 2
load("ueb695150.rda")
?xtabs
# Chi-square test
# Initialization and construction of Chi-table - but I do not need this form
# chitab <- cbind(c(0,0,0,0),
#                 c(0,0,0,0),
#                 c(0,0,0,0))
# chitab <- t(chitab) # transpose
# G <- 'G'
# EG <- 'EG'
# EN <- 'EN'
# M1 <- 'M1'
# M2 <- 'M2'
# P <- 'P'
# tt <- 0 # temporary variable
# 
# treat <- c(M1, M2, P)
# cure <- c(G,EG,EN,N)
# 
# for (i in 1:length(treat)){
#   for (j in 1:length(cure)){
#     for (k in 1:length(dat$A)){
#       if ((dat$A[k] == cure[j]) & (dat$B[k] == treat[i])){
#         tt <- tt + 1
#         # show(tt)
#       }
#     }
#     chitab[i,j] <- tt
#     tt <- 0 # reset the temporary variable
#   }
# }
# 
# # Chi-squre test
# chisq.test(chitab)
# pchisq(q=0, df=6)

tab <- xtabs(Freq ~ A + B , data=df)
chisq.test(tab)

# Construction of Fisher's table
# Initializations and definitions
fish = cbind(c(0,0),
             c(0,0))
temp = 0
G = 'G'
N = 'N'
M = 'M'
P = 'P'

# Calculate: Med and cured
for (i in 1:length(dat$A2)){
  if ((dat$A2[i] == G) & (dat$B2[i] == M)){
  temp <- temp + 1}
}
fish[1,1] <- temp
temp <- 0 # reset temp


# Calculate: Placebo and cured
for (i in 1:length(dat$A2)){
  if ((dat$A2[i] == G) & (dat$B2[i] == P)){
    temp <- temp + 1}
}
fish[1,2] <- temp
temp <- 0


# Calculate: Med and not cured
for (i in 1:length(dat$A2)){
  if ((dat$A2[i] == N) & (dat$B2[i] == M)){
    temp <- temp + 1}
}
fish[2,1] <- temp
temp <- 0


# Calculate: Placebo and not cured
for (i in 1:length(dat$A2)){
  if ((dat$A2[i] == N) & (dat$B2[i] == P)){
    temp <- temp + 1}
}
fish[2,2] <- temp
temp <- 0

fisher.test(fish, alternative = 'two.sided')


# Logistical Regression

glm()
