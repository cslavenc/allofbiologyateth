## Daten einlesen: Kaggle Restaurant Revenue Challenge ####

getwd() ## Was ist der aktuelle Ordner?
setwd("C:/Users/kalischm/Documents/teaching/17/Bio2/V4_RegressionFuerVorhersage/kaggle/") ## Setze richtigen Ordner
## Je nach Betriebssystem darf der Pfadname keine Sonderzeichen (z.B. Umlaute) enthalten
dir() ## Welche Files sind in dem Ordner ?
tmp <- read.csv(file = "train.csv", header = TRUE) ## Lade Training Daten
tmpTest <- read.csv(file = "test.csv", header = TRUE) ## Lade Test Daten
## Wir verwenden nur die Variablen City.Group und P1,...,P37;
## Bei den anderen Faktoren gibt es im Test-Datensatz levels, die im Trainingsdatensatz nicht vorkommen
## Um das zu behandeln müssten wir mehr Zeit investieren.
colnames(tmp)
idxTrain <- c(4,6:43) ## ohne Id, Open.Date, City, Type
dat <- tmp[,idxTrain]
colnames(dat) ## Pruefe, ob Auswahl funktioniert hat
idxTest <- c(1,4,6:42) ## ohne Open.Date, City, Type, revenue
datTest <- tmpTest[,idxTest] 
colnames(datTest) ## Pruefe, ob Auswahl funktioniert hat

## Direkte Methode 1: Trainings- und Testdatensatz ####
n <- nrow(dat)
n
set.seed(123)
train <- sample(n, 90)
train
fm <- lm(revenue~., data = dat, subset = train) ## "." bedeutet "alle anderen Variablen"
summary(fm)

## Berechne Test MSE
yHut <- predict(fm,dat) ## mache Vorhersage fuer alle Datenpunkte
quadratResid <- (dat$revenue - yHut)^2 ## berechne Residuenquadrat fuer alle Datenpunkte
quadratResidTest <- quadratResid[-train] ## waehle Datenpunkte aus dem TEST-set aus
mseTest <- mean(quadratResidTest) ## berechne MSE Test
rmseTest <- sqrt(mseTest) ## Root Mean Squared Error
rmseTest ## Kaggle macht das Ranking der Vorschlaege bzgl. RMSE: 5.86 Mio

## Direkte Methode 2: CV ####
## Leave-One-Out Cross-Validation
library(boot)
?cv.glm
fmVoll <- glm(revenue~., data = dat) 
## ist das gleiche wie lm(revenue~., data = dat)
## "Voll" weil alle erklärenden Variablen vorkommen
cv.err <- cv.glm(data = dat, glmfit = fmVoll)
sqrt(cv.err$delta) ## erste Zahl ist MSE Test; 
##===============================##
## Volles Modell: RMSE = 3.45 Mio
##===============================##

cv.err <- cv.glm(data = dat, glmfit = fmVoll) ## wenn man LOOCV nochmal ausfuehrt, kommt genau das gleiche raus
sqrt(cv.err$delta) ## erste Zahl ist MSE Test

## 10-fold Cross-Validation
set.seed(123)
cv.err10<- cv.glm(data = dat, glmfit = fmVoll, K = 10)
sqrt(cv.err10$delta) ## erste Zahl ist MSE Test; RMSE: 3.67 Mio

cv.err10<- cv.glm(data = dat, glmfit = fmVoll, K = 10)
## wenn man 10-fold CV nochmal ausfuehrt, ist das Ergebnis leicht anders 
## (weil die 10 Bloecke zufaellig gewaehlt werden)
sqrt(cv.err10$delta) 

## Zum Vergleich: Intercept Modell (nur beta_0, aber keine erklärenden Variablen)
fmInt <- glm(revenue~1, data = dat) 
cv.errInt <- cv.glm(data = dat, glmfit = fmInt)
sqrt(cv.errInt$delta) ## erste Zahl ist MSE Test; 
##==================================##
## Intercept Modell: RMSE = 2.59 Mio
## (Volles Modell: RMSE = 3.45 Mio)
##==================================##

## Modellwahl: Bestes subset (dauert ca. 30 Sek) 
install.packages("leaps")
library(leaps)
m1 <- regsubsets(revenue ~ ., data = dat, method = "exhaustive", nvmax = 19) ## nvmax: Max. Anz. erklärender Variablen
## Max. 19 Variablen sollen aufgenommen werden, damit mein Laptop
## noch schnell genug rechnen kann
m1s <- summary(m1)
m1s ## Beste Modelle mit vorgegebener Anzahl Variablen
plot(m1)
?plot.regsubsets
m1s$bic ## BIC Werte für die optimalen Modelle mit 1, 2, ... Variablen
ncoef<-which.min(m1s$bic) ## Modell mit 2 Variablen hat beste Vorhersagekraft gemaess BIC
ncoef
coef(m1, ncoef) ## Modellparameter für das beste Modell für Vorhersage

## Schaetze RMSE fuer bestes Modell mit LOOCV
fmBest <- glm(revenue~P6+P8, data = dat) ## bestes Modell bzgl BIC
cv.errBest <- cv.glm(data = dat, glmfit = fmBest)
sqrt(cv.errBest$delta) ## Wie erwartet ist der Test MSE im besten Modell kleiner
##==========================================##
## Bestes Modell bzgl. BIC: RMSE = 2.52 Mio
## (Volles Modell: RMSE = 3.45 Mio)
## (Intercept Modell: RMSE = 2.59 Mio)
##==========================================##

## Modellwahl: Stepwise forward
m2 <- regsubsets(revenue ~ ., data = dat, method = "forward", nvmax = 38)
## Keine Einschränkung an die Anzahl Variablen im Modell
m2s <- summary(m2)
m2s
plot(m2)
m2s ## Beste Modelle mit vorgegebener Anzahl Variablen
m2s$bic ## BIC Werte für die optimalen Modelle mit 1, 2, ... Variablen
ncoef <- which.min(m2s$bic) ## Modell mit 1 Variablen hat beste Vorhersagekraft gemaess stepwise forward
ncoef
coef(m2, ncoef)

## Schaetze RMSE fuer stepwise forward Modell mit LOOCV
fmSF <- glm(revenue~City.Group, data = dat) ## bestes Modell bzgl stepwise forward
cv.errSF <- cv.glm(data = dat, glmfit = fmSF)
sqrt(cv.errSF$delta) ## Wie erwartet ist der Test MSE im besten Modell kleiner
##============================================##
## Stepwise Forwrad bzgl. BIC: RMSE = 2.53 Mio
## (Bestes Modell bzgl. BIC: RMSE = 2.52 Mio)
## (Volles Modell: RMSE = 3.45 Mio)
## (Intercept Modell: RMSE = 2.59 Mio)
##============================================##

## Modellwahl: Stepwise backward 
m3 <- regsubsets(revenue ~ ., data = dat, method = "backward", nvmax = 38)
m3s <- summary(m3)
m3s
plot(m3)
m3s ## Beste Modelle mit vorgegebener Anzahl Variablen
m3s$bic ## BIC Werte für die optimalen Modelle mit 1, 2, ... Variablen
ncoef <- which.min(m3s$bic) ## Modell 8: Anderes Ergebnis als vorhergehende Methoden
ncoef
coef(m3, ncoef) ## gleiches Modell wie bei best subset
##=========================================================##
## Bestes Modell (all subsets & backward): RMSE = 2.52 Mio
## (Stepwise Forwrad bzgl. BIC: RMSE = 2.53 Mio)
## (Volles Modell: RMSE = 3.45 Mio)
## (Intercept Modell: RMSE = 2.59 Mio)
##=========================================================##

## Vorhersage auf Test-Datensatz von Kaggle ####
revenuePredict <- predict(fmBest, newdata = datTest)
res <- data.frame(Id=datTest$Id, Prediction=revenuePredict)
head(res)
?write.csv
write.csv(x=res, file = "myKaggleSubmission.csv", row.names = FALSE)

