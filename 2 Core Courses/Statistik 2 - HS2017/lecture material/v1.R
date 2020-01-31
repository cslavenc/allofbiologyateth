## R & R-Studio ####
2+2
## setwd("C:/Users/kalischm/Documents/") ## Nur für Demonstrationszwecke später
## RStudio: Zeilen mit Ctrl-Enter ausführen
## Mehr Infos zu RStudio: Help > Cheat Sheets > RStudio IDE Cheat Sheet

?mean
?install.packages ## Pakte muss man NUR EINMAL installieren; 
## siehe auch Tab 'Packages' rechts unten
## '?' vor dem Befehl zeigt Hilfeseite
library(MASS) ## in jeder Session muss man Pakete NEU LADEN

## Daten einlesen ####
read.csv("Daten.csv") ## Fehler, weil das File nicht im aktuellen Working Directory ist
## Lösung 1: Kompletten Pfad angeben (beachte Richtung der Schraegstriche)
read.csv(file = "C:/Users/kalischm/Documents/teaching/17/Bio2/V1_AdminUndR/Daten.csv")
dat <- read.csv(file = "C:/Users/kalischm/Documents/teaching/17/Bio2/V1_AdminUndR/Daten.csv") ## Zuweisung
## Beachte rechts oben das Fenster "Environment": Zeile 'dat' ist erschienen (Symbole: Dreieck, Tabelle, Loeschen)
## Lösung 2: Working Directory setzen
getwd() ## Was ist das aktuelle Working Directory?
setwd("C:/Users/kalischm/Documents/teaching/17/Bio2/V1_AdminUndR/") ## Setze neues Working Directory
## Siehe auch Session > Set Working Directory
dir()
dat <- read.csv("Daten.csv")

## Komfortabler, aber nicht automatisierbar: "Import Dataset" über RStudio Menü
## Hier wird das Paket readr zum Einlesen verwendet
## Beachte generierten Code in Console; diesen kann man in sein skript kopieren

## erzeuge noch ein Objekt, um alles als rda-File zu speichern
x <- seq(from=1, to=10, by=1)
y <- 2 + 3*x + rnorm(10)
lm.fit <- lm(y~x)
summary(lm.fit) ## R Output, wie Sie ihn aus Statistik 1 kennen

save.image(file = "alleObjekte.rda") ## speichert restlos alles
## Demo: Clear Workspace und lade erneut
load("alleObjekte.rda")

save(dat, lm.fit, file = "auswahlVonObjekten.rda") ## speichert nur die angegebene Auswahl von Objekten
## Demo: Clear Workspace und lade erneut
load("auswahlVonObjekten.rda")

saveRDS(dat, file = "datenObjekt.rds") ## speichere nur 'dat'
d <- readRDS(file = "datenObjekt.rds") ## Lade 'dat' aber mit anderem Namen
## identical(d,dat)

## Daten bearbeiten ####
## Einfachstes Format: Vektor
## Die Elemente eines Vektors haben gleichen Datentyp
a <- c(5.3, 5.5, 4.7, 4.1, 5.9) ## Datentyp: "numeric"
a
b <- c("Julia", "Jonas", "Tim", "Georg", "Anna") ## Datentyp: "character"
b
c <- c(TRUE, FALSE, FALSE) ## Datentyp: "logical"
c
d <- as.factor(c("blau", "gelb", "rot", "gelb", "rot")) ## Datentyp: "factor" = "Kategorie"
d ## Per default sind Levels alphabetisch sortiert
## intern werden Faktoren mit den Levelstufen gespeichert:
## 1: blau, 2: gelb, 3: rot (alphabetisch)

## Datentypen umwandeln: as()
as.character(a)
as.numeric(c)
as.numeric(b) ## character kann nicht in numeric verwandelt werden
as.numeric(d) ## Levelstufen

## Auswahl von Elementen des Vektors
a[2]
a[c(1,3)]

## Rechnen mit Vektoren
mean(a)
?mean
2*a
a + a

## Matrizen: Mehrere Vektoren nebeneinander
m1 <- rbind(c(1,3), ## "rowbind"
            c(1,4))
m1
m2 <- rbind(c(2,1),
            c(5,2))
m2
m1 %*% m2 ## Matrixmultiplikation
m1 * m2 ## Multiplikation pro Element

## Liste
c(2, "a") ## Vektor MUSS gleichen Datentyp enthalten; sonst automatisch konvertiert
list(2, "a")

## data.frame
## Liste von Vektoren: Datentabelle, jede Spalte hat gleichen Datentyp
## Aus Vektoren generieren
noten <- data.frame(Note = a, Name = b, stringsAsFactors = FALSE)
noten

## Aus Text-File laden
personen <- read.csv("personen.csv", stringsAsFactors = FALSE, header = TRUE)
personen
head(personen) ## zeige nur erste paar Zeilen

## Auswahl aus Data frame 
## Gezielte Eintraege
personen[2,3]
personen[c(1,2), c(2,3)]

## ganze Spalte
personen[,2] ## oder:
personen[, "Jahrgang"] ## oder:
personen$Jahrgang
## ganze Zeile
personen[2,]

## Vektor mit TRUE oder FALSE (Boolscher Vektor)
jg <- (personen[, "Jahrgang"] < 1990)
jg
st <- (personen[, "Studium"] %in% c("Bio", "Chemie"))
st
jgst <- ( (personen[, "Jahrgang"] < 1990) & (personen[, "Studium"] %in% c("Bio", "Chemie")) )
jgst

## kompliziertere Auswahl mit boolschen Vektoren
personen[jg,]
personen[st,]
personen[jgst,]

## Graphiken erstellen und exportieren ####
x <- seq(from=1, to=10, by=1)
y <- 2*x + 3
plot(x,y)
plot(x,y, main = 'Titel', xlab = 'x [cm]', ylab = 'y [kg]') ## per default: Punkte
plot(x,y, main = 'Titel', xlab = 'x [cm]', ylab = 'y [kg]', pch = 2) ## point character

plot(x,y, main = 'Titel', xlab = 'x [cm]', ylab = 'y [kg]', type = 'l') ## 'l' Linie
plot(x,y, main = 'Titel', xlab = 'x [cm]', ylab = 'y [kg]', type = 'b') ## 'b' both: Punkte & Linie
?plot.default ## viele Optionen

## Linie hinzufügen
lines(x=c(2,8), y=c(15,5), lty = 2) ## lty: line type
?par ## VIELE graphische PARameter; z.B. lty = line type

## Exportieren
jpeg("bild.jpg") ## Grafikfile öffnen
plot(x,y) ## Bild erzeugen
dev.off() ## Grafikfile schliessen
