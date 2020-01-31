#Bonusquiz 1 V13
#Aufgabe 1
#a) beide gleich
#b) Daten zentrieren - x2 von 2. Datenpunkt = 2.2
7.2-5
#c) Steigung = 0 von rotierten Daten
#d) -5.893
#daten zentrieren
x1<-1.1-6
x2<-8.4-5
x1
x2
z1<-x1*0.71+x2*(-0.71)
z1

#Aufgabe 2
#a) gesamtleistung --> ähnliche Werte = PC1 = 3. Spalte
#b)varianz von PC4 = 5. Spalte = 82.81
9.1^2
#c) totale Varianz = 1101.88
totvar<-10.1^2+14.1^2+26^2+6.5^2+9.1^2
totvar
#d) prop. Anteil der gesamten Varianz wird durch PC+,2 und 3 erklärt = 0.887
var123<-26^2+14.1^2+10.1^2
var123/totvar

#Aufgabe 3
load("ueb265944.rda")
#a) 0.0172
PCA<-prcomp(dat)
summary(PCA)
#b) 0.282
#c) 13
#d)Ja = 1
PCA$rotation[, c(1,2)]
z1<-PCA$rotation[,1]
z2<-PCA$rotation[,2]
plot(z1,z2,col = y)