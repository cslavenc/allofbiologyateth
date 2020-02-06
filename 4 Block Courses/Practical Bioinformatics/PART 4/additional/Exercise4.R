# Question 1
# -----------

library(ggplot2)
library(readr)
library(dplyr)

gap <- read_csv("gapminder-FiveYearData.csv")

# First plot
ggplot(gap, aes(x=year, y=lifeExp, color=continent)) + geom_point() +
  xlab("Life expectancy") +
  ylab("Year") +
  labs(color="Continent") +
  theme_gray() +
  theme(axis.text.x = element_text(angle=40))


# Second plot
ggplot(gap, aes(x=year, y=lifeExp, color=continent)) + geom_point() + 
  facet_wrap(~continent, nrow=1) +
  theme(legend.position = "bottom") +
  theme_gray() +
  theme(axis.text.x = element_text(angle=40))


# Third plot
ggplot(gap, aes(x=year, y=lifeExp, color=continent)) + geom_point(alpha=0.2) + 
  facet_wrap(~continent, nrow = 1) +
  theme_gray() +
  theme(axis.text.x = element_text(angle=50)) +
  geom_smooth(model=lm(year~lifeExp, data=gap)) +
  theme(legend.position = "bottom")


# Fourth plot
ch <- gap %>% filter(country=="Switzerland")

ggplot(gap, aes(x=year, y=lifeExp, color=continent)) + geom_point(alpha=0.2) + 
  facet_wrap(~continent, nrow=1) +
  theme_gray() +
  theme(axis.text.x = element_text(angle=50)) +
  geom_smooth(model=lm(year~lifeExp, data=gap)) +
  theme(legend.position = "bottom") +
  geom_point(ch, mapping = aes(color=country))

# Fifth plot
sub <- gap %>% filter(country %in% c("Australia", "New Zealand"))
ggplot(sub, aes(x=gdpPercap, y=lifeExp, color=country)) + geom_label(aes(label=sub$year)) +
  facet_wrap(~country) +
  theme_gray()

# Sixth plot
library(cowplot)
g1 <- ggplot(gap, aes(x=year, y=lifeExp, color=continent)) + geom_point(alpha=0.2) + 
  facet_wrap(~continent, nrow = 1) +
  theme(axis.text.x = element_text(angle=50, size=5)) +
  geom_smooth(model=lm(year~lifeExp, data=gap)) +
  theme(legend.position = "bottom")
g2 <- ggplot(gap, aes(x=year, y=lifeExp, color=continent)) + geom_point() +
  xlab("Life expectancy") +
  ylab("Year") +
  labs(color="Continent") +
  theme(axis.text.x = element_text(angle=40))
plot_grid(g2, g1)



# Question 2
# -----------
library(RColorBrewer)
library(ComplexHeatmap)

load("/Volumes/UsersBio/rameis/Robinson/day3/airway_subset.RData")
length(gene_counts[1,]) # 8
length(unique(rownames(gene_counts))) # 20

sample_info %>% group_by(group) %>% summarise(n=n()) # 4

Heatmap(gene_counts, name="Count")
ann <- HeatmapAnnotation(group=sample_info$group, col=list(group=c("trt"="orange", "untrt"="grey")))
box <- rowAnnotation(value=anno_boxplot(gene_counts))
Heatmap(gene_counts, name="count", row_title_gp = gpar(fontsize=15, fontface="bold"), top_annotation = ann, left_annotation = box, show_row_dend = FALSE, row_title = "Gene", 
        column_title = "Sample", column_title_gp = gpar(fontsize=15, fontface="bold"), row_names_gp = gpar(fontsize=7), column_names_gp = gpar(fontsize=7))

# One gene that differs greatly: ENSG00000125148
