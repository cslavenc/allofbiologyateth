## ANOVA mit mehreren Gruppen ####
setwd("C:/Users/made_/Desktop/Statistik 2 - HS2017/lecture material")
load("medikamente.rda") ## Lade Daten: df, n

boxplot(y ~g, data = df, ylab = "Senkung Blutdruck [mmHg]")

fm <- aov(y ~ g, data = df) ## Berechne ANOVA; aov = Analysis Of Variance
summary(fm) ## Erzeuge ANOVA Tabelle

## Paarweise Vergleiche: TukeyHSD ####
## Zwischen welchen Gruppen sind signifikante Unterschiede ?
## 95%-Vertrauensintervall fuer Differenzen ?
## Tukey Honest Significant Difference: Korrigiert fuer multiples Testen
TukeyHSD(fm)
plot(TukeyHSD(fm))
## Wa., dass ALLE Intervalle den wahren Wert berdecken ist mind. 95%

## Allgemeine Kontraste ####
install.packages("multcomp")
library(multcomp)
## Paarweise Vergleiche (Alternative zu TukeyHSD)
K <- rbind("M2-M1" = c(-1,1,0),
           "P-M1" = c(-1,0,1),
           "P-M2" = c(0,-1,1))
colnames(K) <- levels(df$g)
K
## vergleiche mit TukeyHSD: (praktisch) identisch, aber flexibler
## fm <- lm(y~g, data =df)
summary(fm)
summary(glht(fm, linfct = mcp(g=K)))
## das 'g' in 'g=K' bezieht sich auf den Variablennamen, bzgl. dem der Kontrast angewendet wird. Wuerden wir die Variable 'g' in 'grp' umbenennen, muessten wir also 'grp=K' schreiben

## Gruppe der Medikamente vs. Placebo und M1 vs. M2
K <- rbind("M-P" = c(0.5,0.5,-1),
           "M2-M1" = c(-1,1,0))
colnames(K) <- levels(df$g)
K
summary(glht(fm, linfct = mcp(g=K))) 

## Residuenanalyse ####
plot(fm, which = c(1,2))

