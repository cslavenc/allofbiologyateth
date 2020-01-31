install.packages("vcd")
library(vcd) ## Paket "Visualization for Categorical Data"

## Fisher Test ####
m <- matrix(c(15,10, 9,11), 2,2)
m
fisher.test(m, alternative = "greater")

## Tabellen & Mosaic-Plot ####
## Haar- und Augenfarbe
HairEyeColor
## table to df: as.data.frame
df <- as.data.frame(HairEyeColor)
df ## Freq: Anzahl Beobachtung mit der gleichen Merkmalsauspraegung (z.B. Black/Brown/Male kam 32 mal vor)
## df to table: xtabs
xtabs(Freq ~ ., data = df)

## Nur eine Tabelle fuer beide Geschlechter:
tab <- xtabs(Freq ~ Hair + Eye, data = df)
tab

## Mosaic plot
mosaic(Freq ~ Eye + Hair, data = df)

## Chi-Quadrat Test ####
chisq.test(tab)

## Shading: Mosaic plot inkl. Chi-Quadrat Test ####
mosaic(Freq ~ Hair + Eye, data = df, shade = TRUE)

## Simpson: Zulassung zu UC Berkeley in 1973 - Diskriminierung ? ####
UCBAdmissions
dfUCB <- as.data.frame(UCBAdmissions)
head(dfUCB)

tabUCB <- xtabs(Freq ~ Admit + Dept + Gender, data = dfUCB)
tabUCB <- xtabs(Freq ~ Admit + Gender, data = dfUCB)
tabUCB

## Methodenvergleich: Fisher Test, Chi-Quadrat Test, Logistische Regression
## Fisher Test
ft <- fisher.test(tabUCB)
ft
ft$conf.int ## 95%-VI fuer odds fuer Ablehnung: [1.621; 2.091]
## Chi-Quadrat Test
mosaic(Freq ~ Gender + Admit, data = dfUCB, shade = TRUE)
## (Einfache) Logistische Regression
fm1 <- glm(Admit ~ Gender, weights = Freq, family = binomial, data = dfUCB)

## Neu ist das Argument weights: Im data frame dfUCB hat jede Merkmalsauspraegung (z.B. Admitted/Male/A) nur EINE
## Zeile aber dann noch die Zusatzinformation Freq (also, wie oft diese Beobachtung gemacht wurde; hier 512 mal)
## Alternativ koennte man Freq auch weglassen und fuer jede Person eine Zeile mit Merkmalsauspraegungen hinschreiben. 
## Dann kaemme z.B. die Zeile Admitted/Male/A genau 512 mal vor. Der Datensatz waere viel laenger 
## (4526 statt 24 Zeilen; koennen Sie das nachrechnen?); der Trick mit der Spalte Freq bzw. mit dem Argument weights
## spart also sehr viel Platz bei dem Datensatz, den wir abspeichern muessen.

levels(dfUCB$Admit) ## 0: Admitted, 1: Rejected (Erfolgswa. in GLM bezieht sich auf zweites Level: Reject)
## => Modelliert wird Wa. fuer REJECT !!! (ueberpruefe mit glm output und mosaic plot)
levels(dfUCB$Gender) ## 'Male' ist Referenzklasse
summary(fm1)
exp(0.61035) ## Odds Ratio = odds(R|F) / odds(R|M)
confint(fm1) ## 95%-VI fuer log-odds
exp(confint(fm1)) ## 95%-VI fuer odds fuer Ablehnung: [1.625; 2.087]

## Aufloesung Simpson: Bereinigter Effekt mit (multipler) logistischer Regression ####
fm2 <- glm(Admit ~ Gender+Dept, weights = Freq, family = binomial, data = dfUCB)
levels(dfUCB$Admit) ## 0: Admitted, 1: Rejected
summary(fm2) ## Geschlecht ist nicht mehr signifikant
confint(fm2) ## 95%-VI fuer log-odds
exp(confint(fm2)) ## 95%-VI fuer odds fuer Ablehnung: [0.77; 1.06]
## 95%-VI fuer odds umschliesst 1; daher kein sign. Effekt

