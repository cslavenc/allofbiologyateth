## WDH: Interpretation von plots
## Streudiagramm & Lin. Regression
set.seed(12)
n <- 50
x <- rnorm(n)
y <- rnorm(n)
fm <- lm(y~x)
plot(x,y, type = 'n')
abline(fm)
## tbc... ####
summary(fm)

rm(list = ls())

## lade Daten (df und dfJ) ####
load("v8daten.rda")

## Interaktionsplot 
interaction.plot(x.factor = df$m, trace.factor = df$g, response = df$y)

## 2-weg ANOVA ####
fm1 <- aov(y ~ m*g, data = df)
summary(fm1)

## TukeyHSD ####
TukeyHSD(fm1)

## Residuenanalyse ####
plot(fm1)

## Lineare Regression ####
summary(lm(y ~ m*g, data = df))
levels(df$g) ## Referenzlevel bzgl. Geschlecht: F
levels(df$m) ## Referenzlevel bzgl. Medikament: M

## Juckreiz: Randomized Block Design ####
str(dfJ)
boxplot(y~m, data = dfJ)
boxplot(y~pers, data = dfJ)

fm2 <- aov(y ~ m + pers, data = dfJ)
summary(fm2)
## Zum vergleich: Ohne Blockfaktor weniger Macht
## summary(aov(y~m, data = dfJ))

plot(fm2, which = 1:2)

tk <- TukeyHSD(fm2, which = "m")
rn <- rownames(tk$m) ## Verkuerze Zeilen Namen zu besseren plotten
## Die folgende Zeile muessen Sie nicht verstehen
rnShort <- gsub("([A-Z][a-z])[^-]*-([A-Z][a-z]).*", "\\1-\\2", rn) ## It's a kind of magic ... ;)
rownames(tk$m) <- rnShort
plot(tk, las = 2)

## balanciert vs. unbalanciert ####
load("energyDrink.rda")
attach(datDrink) ## Bequemlichkeit: Mache die Spalten von datDrink als Variablen verfuegbar; siehe auch detach(), search()
drink
gender
table(drink, gender)

## Zum Aufwärmen: Nur ein erklärender Faktor
fm <- aov(y~drink)
summary(fm)
drop1(fm)
## Manuell
yA <- y[drink == "A"]
nA <- length(yA)
yB <- y[drink == "B"]
nB <- length(yB)
RSSdrink <- sum( (mean(yA) - yA)^2 ) + sum( (mean(yB) - yB)^2) ## 1869: RSS von model y ~ drink
RSS1 <- sum( (mean(y) - y)^2 )  ## 3014.9: RSS von model y ~ 1
SS <- nA*( (mean(yA) - mean(y))^2 ) + nB*( (mean(yB) - mean(y))^2) ## 1146: Vgl. Modellvorhersagen von y~1 und y~drink

## Type I: Sequentieller Vergleich der Faktoren
fit <- aov(y~gender+drink)
summary(fit)
fit2 <- aov(y~drink+gender)
summary(fit2) ## Residuenquadratsummen & p-Werte sind unterschiedlich !!!
## Type III: Vergleich mit Modell das den einen Faktor NICHT enthält
drop1(fit, test = "F")
drop1(fit2, test = "F")

## Geschätzte Koeffizienten sind in beiden Fällen gleich
coef(fit)
coef(fit2)
## Auch lm hat kein Problem
summary(lm(y~gender + drink))
summary(lm(y~drink + gender))

