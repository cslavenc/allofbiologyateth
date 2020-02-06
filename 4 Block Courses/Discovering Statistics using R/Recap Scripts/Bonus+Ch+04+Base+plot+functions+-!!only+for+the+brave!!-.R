################################### Alternative plotting functions 09-04-2019 ##
## Although the ggplot2 package undoubtedly offers some great plotting        ##
## functionality, I here provide additonal code that uses R base functions to ##
## draw similar plots. In many statistics books (and online resources) on R   ##
## you will come across these functions, so it's good to at least have seen   ##
## them once before. I find the construction of these graphs more insightful  ##
## (though undeniably more cumbersome!), but as with many things in R, this is##
## probably a matter of personal taste.                                       ##
################################################################################

#### -----
## Housekeeping and data import
#### -----

## Cleanup workspace, set working directory, load libraries
  rm(list= ls())
  setwd("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/DSuR/Data")
  library(reshape)

## Import data used in Chapter 4 to illustrate the different plot types
  examData<- read.delim("Exam Anxiety.dat", header= T)
  
  festivalData2<- read.delim("DownloadFestival(No Outlier).dat",  header= T)
  
  chickFlick<- read.delim("ChickFlick.dat", header= T)
  
  hiccupsData<- read.delim("Hiccups.dat", header= T)    # Restructure from wide
    hiccups<- stack(hiccupsData)                        # to long format (Ch 03)
    names(hiccups)<- c("Hiccups", "Intervention")

  textData <- read.delim("TextMessages.dat", header= T) # Restructure from wide
    textData$Ind<- row(textData[1])                     # to long format (Ch 03)
    textMessages<- melt(textData, id= c("Ind", "Group"),
                        measured= c("Baseline", "Six_months"))
        names(textMessages)[c(3, 4)]<- c("Time", "Grammar_Score")

#### -----
## Scatterplots (exam anxiety)
#### -----

## Simple scatter
  plot(Exam~ Anxiety, examData, main= "Simple scatterplot",
       xlab= "Exam Anxiety", ylab= "Exam Performance %")

  # To add a smooth line
    # Calculate summary statistics
      xs<- min(examData$Anxiety):max(examData$Anxiety)
      smooth<- loess(Exam~ Anxiety, examData)
      preds<- predict(smooth, data.frame(Anxiety= xs), se= T)
      cis.lo<- preds[[1]] - 1.96 * preds[[2]]
      cis.up<- preds[[1]] + 1.96 * preds[[2]]
    # Draw elements
      lines(xs, preds[[1]], col= "blue")              # Fit line
      lines(xs, cis.lo, col= "lightblue",lty= 2)      # CI lower
      lines(xs, cis.up, col= "lightblue",lty= 2)      # CI upper
    # 95% confidence polygon
      xspoly<- c(xs, rev(xs))
      predspoly<- c(cis.lo, rev(cis.up))
      cspoly<- col2rgb("lightblue")/255
      polygon(xspoly, predspoly, col= rgb(cspoly[1], cspoly[2], cspoly[3], .2),
              border= NA)

  # To add a straight line
    # Calculate statistics
      xl<- min(examData$Anxiety):max(examData$Anxiety)
      lin.mod<- lm(Exam~ Anxiety, examData)
      predl<- predict(lin.mod, data.frame(Anxiety= xl), interval= "confidence", 
                      level= 0.95, type= "response")
    # abline(lin.mod, col= "red")                   # This function is often
                                                    # used as well to draw
                                                    # a straight line
      lines(xl, predl[, 1], col= "red")
      lines(xl, predl[, 2], col= "orange",lty= 2)
      lines(xl, predl[, 3], col= "orange",lty= 2)
    # 95% confidence polygon
      xlpoly<- c(xl, rev(xl))
      predlpoly<- c(predl[, 2], rev(predl[, 3]))
      clpoly<- col2rgb("orange")/255
      polygon(xlpoly, predlpoly, col= rgb(clpoly[1], clpoly[2], clpoly[3], .2),
              border= NA)

  # After drawing polygons or lines, you may want to re-plot the points (and
  # lines!) in your graph, so that they are the top-layer
    points(Exam~ Anxiety, examData, pch= 21, bg= "lightgrey")
    box()                                           # Redraw plot outline

## Grouped scatter
  plot(Exam~ Anxiety, examData, main= "Grouped scatter", xlab= "Exam Anxiety",
       ylab= "Exam Performance %", pch= 20 + as.numeric(Gender),
       bg= as.numeric(Gender))
  # To add straight lines + CI's
  xl<- min(examData$Anxiety):max(examData$Anxiety)
  xlpoly<- c(xl, rev(xl))
  for(i in 1: length(levels(examData$Gender))){
      lin.mod<- lm(Exam~ Anxiety, subset= Gender== levels(Gender)[i], examData)
      predl<- predict(lin.mod, data.frame(Anxiety= xl), interval= "confidence", 
                    level= 0.95, type= "response")
      predlpoly<- c(predl[, 2], rev(predl[, 3]))
      clpoly<- col2rgb(i)/255
      polygon(xlpoly, predlpoly, col= rgb(clpoly[1], clpoly[2], clpoly[3], .2),
              border= NA)
      lines(xl, predl[, 1], col= i)
      lines(xl, predl[, 2], col= i,lty= 2)
      lines(xl, predl[, 3], col= i,lty= 2)
    }
  points(Exam~ Anxiety, examData, pch= 20 + as.numeric(Gender),
         bg= as.numeric(Gender))
  box()

#### -----
## Histograms (festival hygiene, outlier removed)
#### -----

## Frequency histogram
  hist(festivalData2$day1)
  
## Density histogram
  hist(festivalData2$day1, freq= F, col= "darkgrey", xlab= "",
       main= "Density distribution Hygiene \n (Day 1)")
  # Add density line
  lines(density(festivalData2$day1), col= "red")
  box()

#### -----
## Boxplots (festival hygiene, outlier removed)
#### -----

## R automatically draws a boxplot when the explanatory variable is a factor
  plot(day1~ gender, festivalData2, col= 1 + as.numeric(gender))
  # To manually specify colours
  plot(day1~ gender, festivalData2, col= c("pink", "lightblue"), xlab= "",
       ylab= "Hygiene score (Day 1)")

#### -----
## Error bar charts (Chick flick)
#### -----

 # There is a preference among statisticians to, Whenever possible, use
 # boxplots instead of barplots as they contain more information about the
 # distribution of the data. Unfortunately then, R doesn't offer a straight-
 # forward function to draw nice barplots with error bars. The default, to be
 # honest, is a little pathetic...

## Manually calculate means first
  y.means<- by(chickFlick$arousal, chickFlick$film, mean)
## Draw the barplot
  barplot(y.means, xlab= "Film", ylab= "Arousal", main= "Rather disappointing!")
  
  # To improve upon this, use the following (don't worry about the code below,
  # simply execute it to create a function)
  error.bar<- function(x, y, upper, lower= upper, length= 0.1, ...){
    if(length(x)!= length(y) | length(y)!= length(lower) |
       length(lower)!= length(upper)) stop("vectors must be same length")
    arrows(x, y + upper, x, y - lower, angle= 90, code= 3, length= length, ...)
    }
  
## Manually calculate required summary statistics
  y.means<- by(chickFlick$arousal, chickFlick$film, mean)
  y.sd<- by(chickFlick$arousal, chickFlick$film, sd)
  y.n<- by(chickFlick$arousal, chickFlick$film, length)
  y.se<- y.sd/sqrt(y.n)
  y.CI<- 1.96 * y.se
  # Create a barplot object and plug it into the error.bar() function
  bar<- barplot(y.means, xlab= "Film", ylab= "Mean Arousal",
                col= c("lightyellow", "brown"),
                ylim= c(0, (1.05*(max(y.means)+ max(y.CI)))))
  error.bar(bar, y.means, y.CI)
  box()

  # Follow the same procedure to plot separate bars for the two genders, and add
  # a legend
  yy.means<- by(chickFlick$arousal, chickFlick[, c("gender", "film")], mean)
  yy.sd<- by(chickFlick$arousal, chickFlick[, c("gender", "film")], sd)
  yy.n<- by(chickFlick$arousal, chickFlick[, c("gender", "film")], length)
  yy.se<- yy.sd/sqrt(yy.n)
  yy.CI<- 1.96 * yy.se
  bar<- barplot(yy.means, xlab= "Film", ylab= "Mean Arousal", beside= T,
                col= c("darkblue", "lightblue"),
                ylim= c(0, (1.05*(max(yy.means)+ max(yy.CI)))))
  error.bar(bar, yy.means, yy.CI)
  box()
  legend("topleft", legend= c("Female", "Male"), inset= 0.01,
         fill= c("darkblue", "lightblue"))

#### -----
## Line graphs (hiccups)
#### -----

## Calculate summary statistics
  hic.x<- unique(hiccups$Intervention)
  hic.y<- by(hiccups$Hiccup, hiccups$Intervention, mean)
  hic.sd<- by(hiccups$Hiccup, hiccups$Intervention, sd)
  hic.n<- by(hiccups$Hiccup, hiccups$Intervention, length)
  hic.se<- hic.sd/sqrt(hic.n)
  hic.CI<- cbind((-1.96 * hic.se) + hic.y, (1.96 * hic.se) + hic.y)

## Plot the graph elements
  plot(hic.y~ hic.x, main= "Line graph", border= "white", xlab= "Intervention",
       ylab= "Hiccups", ylim= c(0, 16))
  arrows(as.numeric(hic.x), hic.CI[, 1], as.numeric(hic.x), hic.CI[, 2],
         angle= 90, code= 3, length= 0.1)
  lines(hic.y~ hic.x, lty= 4, col= "red")
  points(hic.y~ hic.x, pch= 21, bg= "grey")

## For multiple groups
  sms.x<- unique(textMessages$Time)
  sms.y<- by(textMessages$Grammar_Score, textMessages[, c("Time", "Group")],
             mean)
  sms.z<- length(unique(textMessages$Group))
  sms.sd<- by(textMessages$Grammar_Score, textMessages[, c("Time", "Group")],
              sd)
  sms.n<- by(textMessages$Grammar_Score, textMessages[, c("Time", "Group")],
             length)
  sms.se<- sms.sd/sqrt(sms.n)
  sms.CI<- cbind((-1.96 * sms.se) + sms.y, (1.96 * sms.se) + sms.y)  

## Plot
  plot(sms.y[, 1]~ sms.x, main= "Line graph (multiple groups)", border= "white",
       xlab= "Time", ylab= "Mean Grammar Score", ylim= c(40, 75))
  
  for(i in 1: sms.z){
    arrows(as.numeric(sms.x), sms.CI[, i], as.numeric(sms.x), sms.CI[, i + sms.z],
           angle= 90, code= 3, length= 0.1, col= i)
    lines(sms.y[, i]~ sms.x, lty= 4, col= i)
    points(sms.y[, i]~ sms.x, pch= 21, bg= i)
  }
  
  legend("bottomright", legend= c("Control", "Text Messagers"), inset= 0.01,
         pch= 21, pt.bg= c(1, 2))

## To plot multiple graphs in same window
  # Change the default parameters of the plotting window. There are many options
  # to play around with here, see ?par
  par(mfrow= c(2, 2))
  # Now plot your graphs
  plot(Exam~ Anxiety, examData, main= "Graph 1", xlab= "Exam Anxiety",
       ylab= "Exam Performance %")
  plot(Exam~ Anxiety, examData, main= "Graph 2", xlab= "Exam Anxiety",
       ylab= "Exam Performance %")
  plot(Exam~ Anxiety, examData, main= "Graph 3", xlab= "Exam Anxiety",
       ylab= "Exam Performance %")
  plot(Exam~ Anxiety, examData, main= "Graph 4", xlab= "Exam Anxiety",
       ylab= "Exam Performance %")
  # Restore parameters
  par(mfrow= c(1, 1))

## Saving graphs to your working directory
  # To export a graph into your working directory, place its code between e.g.
  # the "tiff()" and "dev.off()" functions (for other file format options,
  # see ?tiff). Not that the file is created without displaying the graph in R!

  tiff("Example graph.tiff", width= 10.0, height= 9.0, units= "cm", res= 600,
       pointsize= 10, compression= "lzw", family= "")
   
    plot(Exam~ Anxiety, examData, main= "Simple scatter", xlab= "Exam Anxiety",
         ylab= "Exam Performance %", las= 1, type= "n")
      polygon(xlpoly, predlpoly, col= rgb(clpoly[1], clpoly[2], clpoly[3], .2),
              border= NA)
      lines(xl, predl[, 1], col= "red")
      lines(xl, predl[, 2], col= "orange",lty= 2)
      lines(xl, predl[, 3], col= "orange",lty= 2)
      points(Exam~ Anxiety, examData, pch= 21, bg= "white", cex= 0.8)
      box()

  dev.off()
