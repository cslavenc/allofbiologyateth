library(readr)
library(dplyr)
library(tidyr)
library(tibble)

# Question 1
# ----------
library(airway)
data("airway")
md <- as.data.frame(colData(airway))
expr <- rownames_to_column(as.data.frame(assay(airway)), "feature")
md$dex

# Transform to long format
f3 <- expr[1:3,]
f3_long <- f3 %>% gather(key="sample", value="counts", -"feature")

# Add dex
zwischen <- rownames_to_column(md, "sample")
dex <- zwischen %>% select(sample, dex)
dex

df <- inner_join(dex, f3_long, by="sample")
dd <- rename(df, dex="condition", feature="gene")

# How many samples for each gene
unique(dd$gene)

dd2 <- as_tibble(dd)
head(dd2)
counted <- dd2 %>% group_by(gene) %>% summarise(n=n())
counted



# Question 2
# ------------

dat <- read_csv("shrub-volume-data.csv")

# Replace width, height, length with volume
dat$volume <- (dat$width*dat$length*dat$height)
x <- dat %>% select(-width, -height, -length)
x

# Join together
tab <- read_csv("shrub-volume-experiments-table.csv")

df <- inner_join(x, tab, by="experiment")
df

# Get rid of site 4
dfclean <- df %>% filter(site!=4)
dfclean

# Rainout to radioactive rainout
dfr <- dfclean %>% mutate(manipulation=recode(manipulation, 
                                              rainout = "radioactive readout"))
dfr
dfr %>% group_by(manipulation) %>% 
  summarise(mean_volume=mean(volume), min_volume=min(volume), 
            max_volume=max(volume)) %>%
  arrange(-mean_volume)


# Question 3
# ------------
names <- list("S2_DRSC_CG8144_RNAi-1.count", "S2_DRSC_CG8144_RNAi-3.count",
              "S2_DRSC_CG8144_RNAi-4.count", "S2_DRSC_Untreated-1.count",
              "S2_DRSC_Untreated-3.count", "S2_DRSC_Untreated-4.count",
              "S2_DRSC_Untreated-4.count")

retc <- function(filename) {
  cf <- read_tsv(filename, col_names = c("gene", "counts"))
  add_column(cf, sample=filename)
}
ls <- lapply(names, function(i) retc(i))
ls[1]

bind_rows(ls)
df <- lapply(ls, function(i) bind_rows(i))
head(df)
