# Practical bioinformatics 1

library(BiocManager)
source("https://bioconductor.org/biocLite.R")
biocLite("Biostrings")

library(Biostrings)
library(airway)
install.packages("airway")

BiocManager::install("airway")


# ----------------------------------------------------------------------------------------- #

# Basics of Biostring
x <- DNAString("TTGATGCGCTGGC")
?DNAString
x

countPattern(patter = "GC", x)
?countPattern

freq <- oligonucleotideFrequency(x, width = 2)
freq
freq[names(freq) == "GC"]

x <- c("TTGATTGCCCTGTAA", "GCGCGGCCCGCGCCCACCCGATCCC")
x <- DNAString(x)
x

vcountPattern(pattern = "GC", x)
oligonucleotideFrequency(x, width = 2)

x <- "TTGATGCGCTGGC"
n <- nchar(x)
start <- 1:(n-1)

# define a function
get_dinucleotide <- function(seq, ind) {
  substring(seq, ind, ind+1)
}





