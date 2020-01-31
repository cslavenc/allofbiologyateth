## Transformationen ####
dat <- read.csv(file = "C:\Users\made_\Desktop\Statistik 2 - HS2017\lecture material\animal.csv", header = TRUE)

brain.g ## geht nicht
attach(dat) ## mache Spalten von 'dat' als Variablen sichtbar
brain.g ## geht nun nach dem 'attach' Befehl
## Achtung: brain.g erscheint NICHT im Fenster "Environment"; detach() nicht vergessen...

## x vs. y - Linearer Zusammenhang
plot(brain.g, body.kg, xlab = "Hirnmasse [g]", ylab = "Koerpermasse [kg]")
fitAnimal <- lm(brain.g ~ body.kg)
summary(fitAnimal)
par(mfrow = c(1,2))
plot(fitAnimal, which = 1:2, ask = FALSE) ## Residuen

## log(x) vs. y - Exponentieller Zusammenhang
plot(log(brain.g), body.kg)
fitAnimalLog <- lm(log(brain.g) ~ body.kg)
summary(fitAnimalLog)
par(mfrow = c(1,2))
plot(fitAnimalLog, which = 1:2, ask = FALSE)

## log(x) vs. log(y) - Polynomieller Zusammenhang
plot(log(body.kg), log(brain.g))
points(log(body.kg)[12], log(brain.g)[12], col = 2, pch = 20) ## Mensch
points(log(body.kg)[5], log(brain.g)[5], col = 3, pch = 20) ## Elefant
points(log(body.kg)[16], log(brain.g)[16], col = 4, pch = 20) ## Maus
fitAnimalLogLog <- lm(log(brain.g) ~ log(body.kg))
abline(fitAnimalLogLog)
summary(fitAnimalLogLog)
par(mfrow = c(1,2))
plot(fitAnimalLogLog, which = 1:2, ask = FALSE)

## Hirnmasse = 8.9*Koerpermasse^0.75

## Multiple Regression: Lebensmittel ####
dat <- read.csv("C:/Users/kalischm/Documents/teaching/17/Bio2/V2_MultipleRegression/foodLabel.csv")

par(mfrow = c(1,3))
plot(dat$gE, dat$kcal)
plot(dat$gK, dat$kcal)
plot(dat$gF, dat$kcal)

## Einfache Lineare Regression (z.B. mit Fett als erklärende Variable)
fit1 <- lm(kcal ~ gF, data = dat)
summary(fit1) ## R-squared = 0.666

## Residuen
par(mfrow = c(1,2))
plot(fit1, which = c(1,2))

## Multiple Lineare Regression
fit <- lm(kcal ~ gE + gK + gF, data = dat)
summary(fit) ## R-squared = 0.9995
confint(fit)
## Residuen
par(mfrow = c(1,2))
plot(fit, which = c(1,2))

## gE: Gramm Eiweis, gK: Gramm Kohlehydrate, gF: Gramm Fett
## kcal = 4*gE + 4*gK + 9*gF

## Autokauf ####
dat <- read.csv(file = "C:/Users/kalischm/Documents/teaching/17/Bio2/V2_MultipleRegression/auto.csv",
                header = TRUE)
## preis ~ km + alter
fm <- lm(preis ~ km + alter, data = dat)
summary(fm) ## F-Test und t-Tests wiedersprechen sich; Interpretation der Parameter schwierig
plot(dat$alter, dat$km) ## alter und km sind stark kollinear
cor(dat$alter, dat$km)

## Wenn man eine von beiden Variablen weglässt, ist das Problem gelöst
## preis ~ km
fm1 <- lm(preis ~ km, data = dat)
summary(fm1) ## 

## preis ~ alter
fm2 <- lm(preis ~ alter, data = dat)
summary(fm2) ## 

## Weiterführend: Nicht prüfungsrelevant
library(rgl)
plot3d(dat$preis, dat$alter, dat$km, col = 2, size = 5)

library(car)
vif(fm) ## Faustregel: vif < 4: ok; 4 < vif < 10: grenzwertig; vif > 10: kritisch
