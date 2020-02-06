rm(list=ls())
library(Biostrings)
library(stringr)


# Question 2
# -----------
proteins <- "Homo_sapiens.GRCh37.71.pep.all.fa"
dat <- readAAStringSet(proteins)

# Number of proteins
length(dat)

# Protein lengths
?DNAStringSet
w <- width(dat)

# Make a histogram
hist(log2(w), xlab = "Width (log)", main = "Histogram of Protein Widths", breaks = 100)
n <- names(dat)

splitted <- str_split(n, " pep", simplify = TRUE)
prot_id <- splitted[,1]

inter <- str_split(splitted[,2], "transcript:", simplify = TRUE)
trans_id <- str_split(inter[,2], " gene_biotype", simplify = TRUE)
trans_id <- trans_id[,1]

tab <- data.frame("protein_id" = prot_id, "transcript_id" = trans_id, "length" = w)
head(tab)

write.table(tab, file = "human_protein_lengths.txt", sep="\t")


# Question 3
# ------------
dna <- "aACTa TtCcC acCtc\tcaTCC CGGCc\nTaTaT CTGaa"
dna1 <- gsub("\t", "\n", dna)
dna2 <- gsub(" ", "\n", dna1)
dna <- str_to_upper(dna2)  # function is in the library stringr
cat(dna)
