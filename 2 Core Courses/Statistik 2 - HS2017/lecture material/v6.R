install.packages("lme4")

library(lme4)
library(lmerTest) ## Verbesserte Methoden fuer p-Werte

?sleepstudy
str(sleepstudy)

## Daten grafisch darstellen ####
## !! Dieser Plot ist nicht pruefungsrelevant !!
library(ggplot2)
ggplot(data = sleepstudy, aes(x = Days, y = Reaction)) + 
  geom_point() + geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~ Subject, ncol = 6) + coord_fixed(ratio = 0.06) +
  xlab("Days of sleep deprivation") +
  ylab("Average reaction time (ms)")

## Block Effekt: Sehr unuebersichtlich
summary(lm(Reaction ~ Days*Subject, sleepstudy))

## RIRS ####
fm1 <- lmer(Reaction ~ Days + (Days | Subject), sleepstudy)
summary(fm1)

## Residuenanalyse ####
plot(fm1) ## Tukey-Anscombe Plot
qqnorm(residuals(fm1)) ## QQ-Plot fuer Residuen
rEff <- ranef(fm1) ## Zufällige Achsenabschnitt und Steigung pro Person
qqnorm(rEff$Subject[,1]) ## QQ-Plot von zuf. Achsenabschnitt
qqnorm(rEff$Subject[,2]) ## QQ-Plot von zuf. Steigung

## RI ####
fm2 <- lmer(Reaction ~ Days + (1|Subject), sleepstudy)
summary(fm2)

## Passt RI oder RIRS besser ? ####
anova(fm1, fm2) ## RIRS passt signifikant besser

## Vertrauensintervalle ####
confint(fm1, oldNames = FALSE)

