## V3

## Packages ####
## Klicke auf "Packages", dann "Install Packages"; tippe "ISLR" ein
## Wenn das package installiert ist, kann es jederzeit im dem Befehl
library(ISLR)
## geladen werden.
## Pro Computer muss man ein package nur EINMAL installieren.
## Das Paket muss man aber JEDESMAL neu laden (mit dem Befehl 'library'), wenn man R Studio neu startet.

## Daten einlesen ####
## Verkaufszahlen (sales) vs. Marketingausgaben (TV, Radio, Newspaper)
## Datensatz von www.StatLearning.com
dat <- read.csv(file = "C:/Users/kalischm/Documents/teaching/17/Bio2/V3_RegressionMitFaktoren/Advertising.csv", 
                row.names = 1, header = TRUE)

## Typische Fehler beim Dateneinlesen:
## Problem: Umlaute oder Sonderzeichen im Pfadname: C:/meine.übung/etc
## Lösung: Pfadnamen in Windows Explorer (o.Ä.) ändern (oder character encoding ändern)
##
## Problem: Schrägstriche im Pfadnamen verkehrt herum (Windows Explorer und R verwenden unterschiedliche Schrägstriche). 
## Z.B.: C:\bla statt C:/bla
## Lösung: Schrägstriche umkehren

head(dat)
dim(dat)
## Streudiagramm: Sales vs Newspaper
plot(Sales ~ Newspaper, data = dat)

## Einfache lineare Regression ####
fit1 <- lm(Sales ~ Newspaper, data = dat)
summary(fit1)

## Residuenanalyse
plot(fit1, which = 1:2)

## Multiple Lineare Regression ####
## Streudiagramme
plot(Sales ~ Newspaper + TV + Radio, data = dat)

## Fitte lineares Modell
fit1 <- lm(Sales ~ Newspaper + TV + Radio, data = dat)
summary(fit1)

plot(fit1, which = 1:2)

## Faktoren ####
dat2 <- read.csv(file = "C:/Users/kalischm/Documents/teaching/16/Bio2/V3_RegressionMitFaktoren/Credit.csv", 
                row.names = 1, header = TRUE)
head(dat2)
dim(dat2)

plot(Balance ~ Age, data = dat2)
boxplot(Balance ~ Gender, data = dat2)
str(dat2) ## 'Gender' ist Faktor mit zwei levels
levels(dat2$Gender) ## Level 'Male' wird zuerst genannt, ist also Referenzlevel

## Lineare Regression (OHNE Wechselwirkung)
fit2 <- lm(Balance ~ Age + Gender, data = dat2)
summary(fit2)

## Modell MIT Wechselwirkung ####
fit3 <- lm(Balance ~ Age * Gender, data = dat2)
summary(fit3)

fit4 <- lm(Balance ~ Age + Gender + Age:Gender, data = dat2)
summary(fit4) ## gleich wie fit3

## Gapminder Daten ####
library(gapminder) ## Lade Paket 'gapminder'
data(gapminder) ## Mache data frame 'gapminder' aus dem Paket sichtbar
?gapminder ## Beschreibung zum Datensatz

head(gapminder)
str(gapminder)

levels(gapminder$continent)
## Mache Europa zur Referenzkategorie
gapminder$continent <- relevel(gapminder$continent, ref = "Europe")
levels(gapminder$continent)
table(gapminder$continent)

continentID <- as.numeric(gapminder$continent)
## 1=Europe, 2=Africa, 3=Americas, 4=Asia, 5=Oceania
table(continentID)

## Ueberblick ueber Daten
plot(gapminder$year, gapminder$lifeExp)
plot(lifeExp ~ year, data = gapminder, pch = continentID, col = continentID)
legend("bottomright",legend=c("Eu", "Af", "Am", "As", "Oc"), pch=1:5, col=1:5)
plot(lifeExp ~ jitter(year), data = gapminder, pch = continentID, col = continentID)
legend("bottomright",legend=c("Eu", "Af", "Am", "As", "Oc"), pch=1:5, col=1:5)

## Globale Verbesserung der Lebenserwartung
fm1 <- lm(lifeExp ~ year, data = gapminder)
summary(fm1)
plot(fm1, which = c(1,2))

## Parallelverschiebung 
fm2 <- lm(lifeExp ~ year + continent, data = gapminder)
summary(fm2)
plot(fm2, which = c(1,2))

## Unterschiedliches Wachstum der Lebenserwartung
fm3 <- lm(lifeExp ~ year*continent, data = gapminder)
summary(fm3)
plot(fm3, which = c(1,2))

## Ausblick: Grafikpaket 'ggplot2' ####
library(ggplot2)
qplot(jitter(year), lifeExp, data=gapminder, colour = continent, geom = c("point", "smooth"))
