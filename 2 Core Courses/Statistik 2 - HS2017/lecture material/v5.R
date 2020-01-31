## Bsp Kreditausfall (Default)
install.packages("ISLR")
library(ISLR)
?Default

## Bsp 1: default ~ balance ####
fm1 <- glm(default ~ balance, data = Default, family = binomial)
summary(fm1)

## Vorhersage & Bsp 2: ####
dNew <- data.frame(balance = 730)
lo <- predict.glm(fm1, newdata = dNew, type = "link", se.fit = TRUE) ## log-odds
lo
p <- predict.glm(fm1, newdata = dNew, type = "response", se.fit = TRUE) ## probability
p
p$fit/(1-p$fit) ## odds von Hand berechnen
## es gibt keine option fuer die Vorhersage der odds
## check: log(p/(1-p)) ist gleich wie prediction von log-odds (lo)
log(p$fit/(1-p$fit)) ## ergibt wieder log-odds wie in objekt 'lo'

## Bsp 2: default ~ student ('student' ist ein Faktor) &
fm2 <- glm(default ~ student, data = Default, family = binomial)
summary(fm2)

## Bsp 3: default ~ balance + income + student ####
fm3 <- glm(default ~ balance + income + student, data = Default, family = binomial)
summary(fm3)

## Ist eine Wechselwirkung nötig ?
summary(glm(default ~ balance * student + income, data = Default, family = binomial))
summary(glm(default ~ balance + student * income, data = Default, family = binomial))
## Wechselwirkungen sind nicht signifikant -> lasse sie weg

## Klassifikation und Vorhersagefehler ####

## ! Falsch: Vorhersagefehler auf Trainingsdaten -> potenziell zu optimistisch
predProb <- predict(fm3, data = Default, type = "response")
predDefault <- (predProb > 0.5)
table(Default$default)
table(predDefault, Default$default) ## Fehlerrate: (40 + 228) / 10000 = 0.0268

## Richtig: Mit Cross-Validation (z.B. 10-fold)
## weil cv.glm die Vorhergesagten Werte nicht ausgibt, müssen wir CV von Hand implementieren
set.seed(123) ## Damit Sie mein Ergebnis reproduzieren können
k <- 10 ## wäre LOOCV auch schnell genug? Versuchen Sie es: k <- 10000
n <- nrow(Default)
folds <- sample(1:k, n, replace = TRUE)
cv.predProb <- rep(NA, n)
for (i in 1:k) {
  ## Schätze Modell mit allen Blöcken ausser Block i
  mod <- glm(default ~ balance + student + income, data = Default[folds != i,], family = binomial)
  ## Welche Zeilen gehören im Originaldatensatz zu Block i ?
  idx <- which(folds == i)
  ## Mache Vorhersage für Block i und schreibe das Ergebnis in die richtige Position (erste Datenzeile an erster Stelle von cv.predProb, zweite Datenzeile an zweiter Stelle etc.)
  cv.predProb[idx] <- predict(mod, newdata = Default[folds == i,], type = "response")
}
  
cv.predDefault <- (cv.predProb > 0.5)
table(cv.predDefault, Default$default) ## Fehlerrate: (41 + 227) / 10000 = 0.0268
## Fehlerrate wurde auf Trainingsdaten auch gut geschätzt; 
## aber nur mit CV haben wir die Gewissheit, dass die Fehlerrate nicht zu optimistisch ist

## Bemerkung: Weil wir nur 4 Parameter in der Logistischen Regression verwenden (Intercept, balance, student, income) ist das Modell nicht sehr flexibel. Gleichzeitig haben wir viele (10000) Datenpunkte. Unser Modell wird diese vielen Datenpunkte kaum perfekt fitten können. Daher ist die Gefahr von Overfitting gering und die Fehlerrate auf dem Trainingsdatensatz ist praktisch gleich gross wie die "richtige" Fehlerrate, die wir mit CV berechnen.

