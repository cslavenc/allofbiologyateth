# Practical bioinformatics 4
# demo
install.packages("ComplexHeatmap")


library(ggplot2)
library(dplyr)
library(readr)


# work with the gapminder data again
gapminder <- read_csv(data = "gapminder.csv")

# ggplot
g1 <- ggplot(data = gapminder, aes(x = lifeExp, y = gdpPercap), color = continent) + geom_point()
g2 <- scale_color_manual(values = c("blue", "pink", "yellow", "green", "red"))
g3 <- scape_shape_manual(values = 1:5)
g4 <- scale_color_gradientn(colours = rainbow(10))
g1+g2+g3+g4

# use another library
library(RColorBrewer)
colors2 <- colorRampTalette(c("red", "yellow", "green", "darkgreen"))(10)
g4_ <- scale_color_gradientn(colours = colors2)
color3 <- colorRampTalette(brewer.pal(n = 9, name = "Spectral"))(20)
stuff <- theme_bw() + ggtitle("a title") + xlab("x axis") + ylab("y axis") + theme(axis.title = element_text(face = "bold"))
facetstuff <- facet_wrap(~continent) # wrap for rows, grid for columns

# bar for discrete, histogram and density for continuous data
new2 <- ggplot(gapminder, aes(lifeExp)) + geom_histogram(binwidth = 1)
new3 <- ggplot(gapminder, aes(lifeExp)) + geom_density()
new4 <- ggplot(gapminder, aes(continent)) + geom_bar()
new5 <- ggplot(gapminder, aes(continent, lifeExp, color = continet)) + geom_boxplot() + geom_jitter(alpha = 0.2)
violin <- geom_violin(scale = "width")  # shows distribution


# use another library
library(cowplot)

# places plots next to each other
plot_grid(p1, p2)  # px = one of the above plot like new2


# do heatmaps
library(ComplexHeatmap)
m <- matrix(1, nrow = 10, ncol = 4)
m
Heatmap(m, name = "Count", col = "blue", rect_gp = gpar(col = "white"))
rownames(m) <- paste0("gene", 1:10)
colnames(m) <- paste("sample", 1:4)
r <- c(1,3,5)
m[r,c(1,3)] <- m[r,c(1,3)] + 1
Heatmap(m, cluster_rows = TRUE, cluster_columns = FALSE, row_names_side = "left")

group <- rep(c("treated", "control"),2)
names(group) <- colnames(m)
ha <- HeatmapAnnotation(group = group, col = list(group))
Heatmap(m, top_annotation = ha,
        cluster_rows = TRUE, cluster_columns = FALSE, row_names_side = "left")
err <- matrix(rnorm(40, mean = 0, sd = 0.1), nrow = 10)
mU <- m + err
Heatmap(mU, row_names_side = "left")

ha2 <- rowAnnotation(value = anno_boxplot(m))
Heatmap(mU, row_names_side = "left", right_annotation = ha2,
        top_annotation = ha)

# multiple heatmaps
h1 <- Heatmap(m, row_title = "gene", column_title = "samples")
h2 <- Heatmap(mU)
h1+h2  # next to each other
h1 %v% h2  # vertical

