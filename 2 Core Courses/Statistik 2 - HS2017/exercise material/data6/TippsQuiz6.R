# Allgemeines zu Mixed Effects Models:

# Block Effekte (fixed Effects):Statistische Aussage für Individuen, aber nicht Bevölkerung
# Mixed effect:Statistische Aussage für Bevölkerung, aber nicht Individuen
# Random Intercept (RI): Individueller Achsenabschnitt
# Random Intercept and Random Slope (RIRS): Individueller Achsenabschnitt und Steigung


# Fixed Effects Model (kennen wir schon als lineare Regression):

fitF1 <- lm(y ~ x + R, data = dat)  # ohne Wechselwirkung
fitF2 <- lm(y ~ x * R, data = dat)  # mit Wechselwirkung

#Mixed Effects Model:

library(lmerTest)
fitM1 <- lmer(y ~ x + (1 | R), data = dat)  # RI
fitM2 <- lmer(y ~ x + (x | R), data = dat)  # RIRS
# Achtung: Beachte, welche Variable du wo setzt: 
# y: Zielvariable (Reaktionszeit bei Schlafstudie/ Besucheranzahl)
# x: kontinuierliche Variable (Tage)
# R: diskreter Faktor (Personen/ Restaurants)

# Korrelation: cor~0: Zielvariable zu Beginn hat keinen Einfluss auf Veränderung der Zielvariable 
# (Es gibt keinen signifikanten Zusammenhang zwischen anfänglicher Reaktionszeit und Wirkung des Schlafentzugs) 


# Aufgabe 1:
setwd("~/Documents/Sem 5/Statistik II /U6/data-2")
load("~/Documents/Sem 5/Statistik II /U6/data-2/ueb765104.rda")

# 1a)  Fixed Effects mit Wechselwirkung: yi = (A + Aj) + (B + Bj) * x + e, e~N(0,𝜎2) 𝑖.𝑖.𝑑
# Wie viele Restaurants? Wie viele Koeffizienten werden pro Restaurant geschätzt? + sigma des Fehlerterms nicht vergessen

# 1b) Fixed Effects Model mit WW fitten, Output mit summary(variable)

# 1c) Mixed Effects RI Model fitten, Output mit summary(variable)
library(lmerTest) #für mixed effects Befehl, package zuerst herunterladen

# 1d) 
confint(variable, level=0.95) # 95%- Vertrauensintervall


# Bonusquizzes:
# Vergleich der Güte von zwei Modellen, also RI oder RIRS bessser? (kommt nächste Woche in der Vorlesung):
anova(variable1, variable2)

# Werte der einzelnen Koeffizienten von Mixed Effects RIRS Models (zuerst normal das Model fitten):
ranef(variable)
# z.B. Steigung von Restaurant 3 berechnen: fixe Steigung + Steigung des 3. Restaurants
