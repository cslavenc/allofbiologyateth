# Practical Bioinformatics
# demo 3

install.packages("tidyr")
library(readr)
library(dplyr)
library(tidyr)
library(airway)
library(tibble)

gapminder <- read.csv("gapminder.csv")  # stringsAsFactors=FALSE as input option
str(gapminder)
n <- 10  # number of rows
head(gapminder, n)
gapminder$country

# convert type
head(as.integer(gapminder$country))
head(as.character(gapminder$country))
head(as.integer(as.factor(gapminder$year)))  # years are factors, and then we get 1,2,3,4...

gapminder2 <- read_csv("gapminder.csv")  # this function is better and faster for big data
unique(gapminder$continent)  # prints unique elements
gapminder$country %>% unique()  # same as above
gapminder$country %>% unique() %>% head(10)  # show only the first 10 unique elements

gapminder %>% filter(year == 1987 & continent == "Europe") %>% head
gapminder %>% select(country, year, pop) %>% head
gapminder %>% rename(population=pop) %>% head
gapminder %>% transmute(country, year, population=pop, gdp = population*gdpPercap)





