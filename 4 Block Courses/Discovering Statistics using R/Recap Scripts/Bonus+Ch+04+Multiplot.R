############################################### Recap Ch 04 Bonus, 10-04-2019 ##
## Yesterday, some of you asked whether it is possible to plot more than one  ##
## ggplot graph in the same window. As always, there are many ways to achieve ##
## this, one of the simpler ones I briefly demonstrate below.                 ##
##                                                                            ##
## The code for the function used below was taken from:                       ##
## http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/    ##
################################################################################

#### -----
## Housekeeping
#### -----

## Cleanup workspace, set working directory and load required package
  rm(list= ls())
  setwd("C:/Users/Erik/Clouds/OneDrive - aim.uzh.ch/Teaching/BIO209/2019/DSuR/Data")
  library(ggplot2)

## Define a function called "multiplot()"
  multiplot<- function(..., plotlist= NULL, file, cols= 1, layout= NULL) {
    library(grid)
    
    # Make a list from the ... arguments and plotlist
    plots <- c(list(...), plotlist)
    
    numPlots = length(plots)
    
    # If layout is NULL, then use 'cols' to determine layout
    if (is.null(layout)) {
      # Make the panel
      # ncol: Number of columns of plots
      # nrow: Number of rows needed, calculated from # of cols
      layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                       ncol = cols, nrow = ceiling(numPlots/cols))
    }
    
    if (numPlots==1) {
      print(plots[[1]])
      
    } else {
      # Set up the page
      grid.newpage()
      pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
      
      # Make each plot, in the correct location
      for (i in 1:numPlots) {
        # Get the i,j matrix positions of the regions that contain this subplot
        matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
        
        print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                        layout.pos.col = matchidx$col))
      }
    }
  }

## Import data
  examData<- read.delim("Exam Anxiety.dat", header= T)

## Create a very simple graph from Ch 04
  graph<- ggplot(examData, aes(Anxiety, Exam))

#### -----
## Let's plot this graph
#### -----
  
## This is what we already know
  graph + geom_point()
  
## Now let's use our function to plot this graph 3 times
  multiplot(graph + geom_point() + labs(title= "Graph 1"),
            graph + geom_point() + labs(title= "Graph 2"),
            graph + geom_point() + labs(title= "Graph 3"))

## To overrule the default, we can specify the number of columns we want
  multiplot(graph + geom_point() + labs(title= "Graph 1"),
            graph + geom_point() + labs(title= "Graph 2"),
            graph + geom_point() + labs(title= "Graph 3"),
            cols= 3)  
  
## For even greater flexibility, we can use the layout argument
  multiplot(graph + geom_point() + labs(title= "Graph 1"),
            graph + geom_point() + labs(title= "Graph 2"),
            graph + geom_point() + labs(title= "Graph 3"),
            layout= matrix(c(1, 1, 2, 3), ncol= 2))
  
  multiplot(graph + geom_point() + labs(title= "Graph 1"),
            graph + geom_point() + labs(title= "Graph 2"),
            graph + geom_point() + labs(title= "Graph 3"),
            layout= matrix(c(1, 1, 2, 3), nrow= 2, byrow= T))

## To save the active plot, use "Export" pane in bottom-right window
  