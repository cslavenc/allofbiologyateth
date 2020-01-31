## Funktion um Screeplot zu erzeugen
scree <- function(x) {
  ## INPUT: x ist Objekt, das von prcomp erzeugt wird
  ## OUTPUT: Ein plot mit pve vs Anzahl PCs und ein plot mit cpve vs Anzahl PCs
  sm <- summary(x) ## Liste mit 6 Elementen; Element 'importance' enthaelt matrix mit erklaerten varianzen
  pve <- sm$importance[2,] ## 2.Zeile: Proportion of variance explained (pve)
  cpve <- sm$importance[3,] ## 3. Zeile: Cumulative proportion of variance explained (cpve)
  par(mfrow = c(1,2))
  plot(pve, xlab = "PCs", ylab = "PVE", ylim = c(0,1), type = "b")
  plot(cpve, xlab = "PCs", ylab = "Cum. PVE", ylim = c(0,1), type = "b")
}

## Kleiner Beispiel Datensatz ####
load(file = "C:/Users/kalischm/Documents/teaching/17/Bio2/V13_PCA/V13_PCA.rda")

head(dat)
plot(dat[,1], dat[,2], xlab = "X1", ylab = "X2", xlim = c(-6,6), ylim = c(-6,6))

pr.out <- prcomp(dat)
str(pr.out)

pr.out$rotation ## loadings

## Richtung der PCs
center <- c(0,0)
points(x=0, y=0, pch = 4, col = "red")
lines(x=c(0,-0.96), y=c(0,-0.29), col = "blue") ## Richtung PC 1
lines(x=c(0,0.29), y=c(0,-0.96), col = "red") ## Richtung PC 2

pr.out$x ## scores (= Koordinaten bzgl. PC Basis; wir hatten das in der VL 'z' genannt)
dat[18,] ## Koordinaten bzgl. Standardbasis
points(x=dat[18,1], y=dat[18,2], pch = 20, col = "red")
pr.out$x[18,] ## Koordinaten bzgl. PC Basis

## Check:
## Ergebnis mit prcomp
pr.out$x 
## Ergenis kann auch manuell berechnet werden; ist aber mühsam...
phi <- pr.out$rotation
phiInv <- solve(phi)
datCenter <- scale(dat, center = TRUE, scale = FALSE) ## Zentrieren der Daten
t(datCenter) ## t() transponiert eine Matrix
xManuell <- phiInv %*% t(datCenter) ## %*% ist Matrixmultiplikation
t(xManuell)
## Vergleich
pr.out$x
max(t(xManuell) - pr.out$x) ## bis auf 8*10^(-16) identisch (Maschinenungenauigkeit)

## Bsp 1: USArrests ####
?USArrests
pr.out <- prcomp(USArrests, scale = TRUE)
str(pr.out)
sm <- summary(pr.out)
sm ## Summary zeigt Tabelle mit erklaerten Varianzen
str(sm) ## Diese Tabelle ist im Listenelement $importance abgespeichert
sm$importance ## Tabelle mit erklaerten Varianzen als Matrix
sm$importance[2,1] ## Anteil der Varianz erklaert durch PC 1

pr.out$rotation
## Biplot (Projektion auf die ersten zwei PCs)
biplot(pr.out, scale = 0)

## screeplot ####
## grob
plot(pr.out)
## genauer
scree(pr.out)

## Bsp NCI60 Data (ISLR 10.6.1) ####
library(ISLR)
?NCI60
nci.labs <- NCI60$labs
nci.data <- NCI60$data
dim(nci.data)

table(nci.labs)
par(mfrow = c(1,1))
pr.out <- prcomp(nci.data, scale = TRUE) ## man kann hier streiten, ob skaliert werden soll oder nicht...
sm <- summary(pr.out)
which(sm$importance[3,]>=0.8)
plot(pr.out$x[,1:2], type = 'n')
text(pr.out$x[,1:2], labels = 1:64) ## Klare Gruppierung ersichtlich
pr.out$importance
## scree plot
scree(pr.out)

## Angenommen, wir wollen nur die ersten 10 PCs verwenden. Neuer Datensatz:
datNeu <- pr.out$x[,1:10]

## Bsp 3: Siebenkampf ####
library(MVA)
?heptathlon
data("heptathlon")
head(heptathlon)

## Reskaliere: Grosse Zahl = Gute Leistung
dat <- heptathlon
dat$hurdles <- with(heptathlon, max(hurdles)-hurdles)
dat$run200m <- with(heptathlon, max(run200m)-run200m)
dat$run800m <- with(heptathlon, max(run800m)-run800m)
dat <- dat[,-8] ## Ohne Olympischen Score

par(mfrow = c(1,1))
stars(dat, draw.segments = TRUE, key.loc = c(-0.7,5))
## Interpretation: Jeder Sektor hat eine Variable
## Grösster Wert: Voller Sektor
## Kleinster Wert: Gar kein Sektor
dat[25,] ## Nordkoreanerin ist ein "Ausreisser"; ich lasse sie weg
dat2 <- dat[-25,]
heptathlon2 <- heptathlon[-25,]
cor(dat2) ## Korrelationsmatrix

pr.out <- prcomp(dat2, scale = TRUE)

## Scree Plot
scree(pr.out)

## Scores bzgl. PC 1
pr.out$x[,1]

## Vergleich mit Olympischem Score: Gute Übereinstimmung
par(mfrow = c(1,1))
plot(heptathlon2$score, pr.out$x[,1], xlab = "Olympischer Score", ylab = "PC 1")
