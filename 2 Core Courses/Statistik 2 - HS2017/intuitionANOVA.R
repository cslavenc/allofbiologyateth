## Mit diesem skript koennen Sie zufaellige Daten einer 2-weg ANOVA mit dem Faktor Gruppe (G1, G2) 
## und dem Faktor Medikament (M1, M2, M3, M4) erzeugen. 

## Spielen Sie mit den Parametern etwas herum und versuchen Sie Ihre 
## Intuition vom Bild mit dem p-Wert der ANOVA in Einklang zu bringen.

## Hier koennen Sie die Gruppenmittelwerte einstellen (G1 und G2 sind unterschiedlich; M1 ist anders als M2, M3, M4)
a <- 5.5 ## G1 & M1
b <- 4.5 ## G1 & M2,M3 oder M4
c <- 6.5 ## G2 & M1
d <- 6 ## G2 & M2, M3 oder M4
sigma <- 10 ## Standardabweichung der Fehlerstreuung

## Ab hier muessen Sie am Code nichts mehr aendern, sondern nur noch ausfuehren ####

## erzeuge Zielgroesse
Y <- rep(NA,200)
Y[1:25] <- rep(a,25)
Y[26:100] <- rep(b,75)

Y[101:125] <- rep(c,25)
Y[126:200] <- rep(d,75)
Y <- Y+rnorm(200,sd=sigma)

## erzeuge gruppen labels
G <- rep(c("G1","G2"),each=100) ## erste 100 sind G1, zweite 100 sind G2
M <- rep(rep(c("M1","M2","M3","M4"),each=25),2) ## 25 mal M1, 25 mal M2, etc.; das Ganze zweimal

## fuege alles in einen data frame
dat <- data.frame(Y=Y,G=G,M=M)

## ANOVA
fit <- aov(Y~M+G,data=dat)
summary(fit)

## plot
stripchart(Y~M+G, data = dat, vertical = TRUE)
