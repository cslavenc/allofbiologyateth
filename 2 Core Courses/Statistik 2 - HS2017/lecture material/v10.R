## Power Analyse
## Siehe auch: power.t.test, power.anova.test, power.prop.test (komfortabel, aber auch eingeschraenkt)
## Zudem: Paket 'pwr'

## Theorie: Macht des Binomialtest ####
1 - pbinom(q=13, size = 50, prob = 0.333)

## Programmieren in R ####
## Vektoren & Matrizen (jeder Eintrag hat gleichen Datentyp)
v1 <- vector("numeric", 5)
v1[2] <- 2
v1
v2 <- c(1,4,9)
v2
v2[2]
m <- matrix(c(1,2,3,4,5,6), 2,3)
m
m[2,3]
m[,3]
m[2,]

v1
class(v1)
v1[2] <- "a"
v1
class(v1) ## Datentyp wurde von numeric zu character umgewandelt
## Ein Vektor/Matrix kann nur einen einzigen Datentyp enthalten -> Liste, Data Frame

## Listen (Eintraege koennen unterschiedliche Datentypen haben)
myList <- list(a=4, b=v1, c=m, d="hallo")
myList
myList$b ## Element mit Namen 'b'
tmp <- myList[2] ## zweites Element der Liste; ACHTUNG: [[]], nicht []
tmp$b[2]
tmp2 <- myList[[2]]
tmp2[2]
## for-Schleife
reps <- 20
res <- vector("numeric", reps)
for (i in 1:reps) {
  res[i] <- i
}
res
sum(res)

## Funktion
sumUp <- function(n=70) { ## Code einmal ausfuehren, dann kann Funktion verwendet werden
  ## Default-Input: 10
  res <- vector("numeric", n)
  for (i in 1:n) {
    res[i] <- i
  }
  sum(res) ## Ausgabe der letzten Zeile wird von Funktion zurueckgegeben
}

sumUp
sumUp()
sumUp(n=80)
sumUp(70) ## !!! der source code muss nur EINMAL ausgefuehrt werden; danach reicht Aufruf sumUp(...)

## Quiz ####
f <- function(x=2, n=3) {
  res <- vector("numeric", n)
  for (i in 1:n) {
    res[i] <- x*i
  }
  list(res1 = res[1], res2 = res[2])
}
f(x=3)$res2

## Binomialtest ####
p0 <- 0.5

## Konkrete Alternative
pA <- 0.7

n <- 50
x <- rbinom(n=1, size = n, prob = pA) ## Simuliere vom Modell unter der Alternative (pA)
binom.test(x, n = n, p = p0) ## Mache Binomialtest
tmp<- binom.test(x, n = n, p = p0)
str(tmp)
tmp$p.value
tmp$p.value < 0.05 ## Wird Test verworfen? (TRUE = 1, FALSE = 0)

## Macht fuer n=50
reps <- 10000
res <- vector("numeric", reps)
for (i in 1:reps) {
  x <- rbinom(n=1, size = n, prob = pA) ## Simuliere Daten
  tmp <- binom.test(x, n = n, p = p0) ## Mache Test
  res[i] <- (tmp$p.value < 0.05) ## Speichere Ergebnis
}
mean(res) ## Macht bei n = 50
sd(res)/sqrt(length(res)) ## Genauigkeit der Machtschaetzung (Wurzel-n-Gesetz)

## Funktion fuer beliebiges n
machtBinom <- function(n=50, reps = 1000, alpha = 0.05, pA = 0.7, 
                       p0 = 0.5, alt = "two.sided") {
    res <- vector("numeric", reps)
    for (i in 1:reps) {
        x <- rbinom(n=1, size = n, prob = pA) ## Simuliere Daten
        tmp <- binom.test(x, n = n, p = p0, alternative = alt) ## Mache Test
        res[i] <- (tmp$p.value < alpha) ## Speichere Ergebnis
    }
    list(m = mean(res), s = sd(res)/sqrt(reps) )
}
machtBinom() ## default Werte: n = 50, reps = 1000, alpha = 0.05, etc.
machtBinom(n=30) ## default Werte: reps = 1000, alpha = 0.05, etc.

## Suche nach Stichprobengroesse z.B. fuer Macht = 0.9
nAll <- seq(1, 100, by = 1) ## 1,2,...,99,100
macht <- vector("numeric", length(nAll))
for (j in 1:length(nAll)) {
  n <- nAll[j]
  macht[j] <- machtBinom(n = n, pA = 0.7, alt = "greater")$m
}

plot(nAll, macht, type = "b") ## Haifischzaehne...
abline(h = 0.9)
which(macht > 0.9)[1]
## ca. n = 50 fuer Macht = 0.9 

## Von Hand statt for-Schleife: Binäre Suche (Ziel Macht = 0.9)
set.seed(123)
machtBinom(n=10, pA = 0.7, alt = "greater") ## zu tief
machtBinom(n=100, pA = 0.7, alt = "greater") ## zu hoch -> teste Mitte des Intervalls
machtBinom(n=50, pA = 0.7, alt = "greater") ## richtige Groessenordnung
## Um das Ergebnis genauer zu bestimmen, muessten wir 'reps' erhoehen; das erhoeht auch die Rechenzeit

## t-Test ####
## Konkrete Alternative
m1 <- 0
m2 <- 1

x <- rnorm(n=20, mean = m1, sd = 1) ## simuliere Daten
y <- rnorm(n=20, mean = m2, sd = 1)
tmp <- t.test(x,y, paired = FALSE) ## Mache Test
str(tmp)
tmp$p.value < 0.05 ## Ergebnis des Tests

machtTtest2 <- function(n1=20, n2=20, m1=0, m2=1, s1=1, s2=1, reps = 1000, alpha = 0.05) {
    ## Ungepaarter t-Test mit evtl. ungleichen Varianzen
    res <- vector("numeric", reps)
    for (i in 1:reps) {
        x <- rnorm(n=n1, mean = m1, sd = s1) ## Simuliere Daten
        y <- rnorm(n=n2, mean = m2, sd = s2) 
        tmp <- t.test(x,y, paired = FALSE) ## Mache Test
        res[i] <- (tmp$p.value < alpha) ## Speichere Ergebnis
    }
    list(m=mean(res), s=sd(res)/sqrt(reps))
}
machtTtest2()

## Varianzen gleich: Wie sollte man Stichproben auf beide Gruppen aufteilen ?
set.seed(123)
nAll <- seq(10, 100, by = 10)
nn <- length(nAll)
macht <- matrix(0, nn, nn)
for (j1 in 1:nn) {
    cat("Schleife",j1," von ", nn,"\n")
    for (j2 in 1:nn) {
        n1 <- nAll[j1]
        n2 <- nAll[j2]
        macht[j1, j2] <- machtTtest2(n1 = n1, n2 = n2, s1=2, s2=2)$m
    }
}
macht ## Beste Macht, wenn Gruppen gleich gross sind (z.B. Total 100 -> 50-50)

## Varianzen unterschiedlich: Wie sollte man Stichproben auf beide Gruppen aufteilen ?
nAll <- seq(10, 100, by = 10)
nn <- length(nAll)
macht <- matrix(0, nn, nn)
for (j1 in 1:nn) {
        cat("Schleife",j1," von ", nn,"\n")
    for (j2 in 1:nn) {
        n1 <- nAll[j1]
        n2 <- nAll[j2]
        macht[j1, j2] <- machtTtest2(n1 = n1, n2 = n2, s1=1, s2=5)$m
    }
}
macht ## Beste Macht, wenn Gruppen unterschiedlich gross sind (Z.B. Total 100 -> 70-30)

## Einweg-ANOVA ####
n <- c(10, 7, 12)

## Konkrete Alternative
mu <- c(0, -1, 1)

## Simuliere Daten
## Modell unter Alternative: Y = mu + eps, eps ~ N(0,1)
x <- rep(LETTERS[1:length(n)], times = n)
y <- c(rnorm(n[1], mean = mu[1]),
       rnorm(n[2], mean = mu[2]),
       rnorm(n[3], mean = mu[3]))
df <- data.frame(x=x, y=y)
## Mache Test
sm <- summary(aov(y~x, data = df))
pval <- sm[[1]][[5]][1]
## Ergebnis des Tests
( pval < 0.05 )

machtAnova1 <- function(n, mu, s=1, reps = 1000, alpha = 0.05) {
    res <- vector("numeric", reps)
    for (i in 1:reps) {
        ## Simuliere Daten
        x <- rep(LETTERS[1:length(n)], times = n)
        y <- vector("numeric",0)
        for (j in 1:length(n)) {
            y <- c(y,rnorm(n[j], mean = mu[j], sd = s))
        }
        df <- data.frame(x=x, y=y)
        ## Mache Test
        sm <- summary(aov(y~x, data = df))
        pval <- sm[[1]][[5]][1]
        ## Speichere Ergebnis
        res[i] <- ( pval < alpha )
    }
    list(m = mean(res), s = sd(res)/sqrt(reps))
}
machtAnova1(n = c(10,7,12), mu = c(0,-1,1))

## Lin Reg: Macht fuer Steigung (NICHT FUER DIE PRUEFUNG) ####
n <- 5

## Konkrete Alternative
b0 <- 0
b1 <- 1

## Simuliere Daten
## Y = 0 + 1*x + e, x ~ Unif(-1; 1), e ~ N(0, 1)
x <- runif(n=n, min = -1, max = 1)
y <- b0 + b1*x + rnorm(n, mean = 0, sd = 1)
## Mache Test
sm <- summary(lm(y~x))
sm
sm$coefficients
pval <- sm$coefficients[2,4]
## Ergebnis des Tests
(pval < 0.05)

machtLM <- function(n = 5, b0 = 0, b1 = 1, s=1, reps = 1000, alpha = 0.05) {
    res <- vector("numeric", reps)
    for (i in 1:reps) {
        ## Simuliere Daten
        x <- runif(n=n, min = -1, max = 1)
        y <- b0 + b1*x + rnorm(n, mean = 0, sd = s)
        ## Mache Test
        tmp <- lm(y~x)
        pval <- summary(tmp)$coefficients[2,4] 
        ## Speichere Ergebnis
        res[i] <- (pval < alpha)
    }
    list(m = mean(res), s = sd(res)/sqrt(reps))
}
machtLM()

## Fisher Test (NICHT FUER DIE PRUEFUNG) ####
## n Patienten
## Medikament (Heilungswa. p1; n1 Patienten) vs. Placebo (Heilungswa. p2; n2 Patienten)
##  | G |  nG
## ______________
## M| x1| x2 | n1
## ______________
## P| y1| y2 | n2

set.seed(123)
## Konkrete Alternative
p1 <- 0.3
p2 <- 0.1
## Simuliere Daten
n1 <- n2 <- 50
x1 <- rbinom(n=1, size=n1, prob=p1)
x2 <- n1 - x1
y1 <- rbinom(n=1, size=n2, prob=p2)
y2 <- n2 - y1
tt <- matrix(c(x1,y1,x2,y2),2,2)
## Mache Test
tmp <- fisher.test(tt)
pval <- tmp$p.value 
## Ergebnis des Tests
pval < 0.05

machtFisher <- function(n1 = 50, n2 = 50, p1 = 0.3, p2 = 0.1, reps = 1000, alpha = 0.05) {
    res <- vector("numeric", reps)
    for (i in 1:reps) {
        ## Simuliere Daten
        x1 <- rbinom(n=1, size=n1, prob=p1)
        x2 <- n1 - x1
        y1 <- rbinom(n=1, size=n2, prob=p2)
        y2 <- n2 - y1
        tt <- matrix(c(x1,y1,x2,y2),2,2)
        ## Mache Test
        tmp <- fisher.test(tt)
        pval <- tmp$p.value 
        ## Ergebnis des Tests
        res[i] <- (pval < alpha)
    }
    list(m = mean(res), s = sd(res)/sqrt(reps))
}
machtFisher()

