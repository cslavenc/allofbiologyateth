### Question 1
# ---------------
library(rtracklayer)
library(GenomicRanges)
load("/Volumes/GroupsBio/Bio_334/Robinson/data/load_datasets_ex2.RData")

# k450 <- import.bed("LNCAP_450k_chr1.bed")
# rrbs <- import.bed("GSM683924_hg19_wgEncodeHaibMethylRrbsLncapDukeSitesRep2.bedRrbs_chr1.bed")
seqinfo(k450)
k450
rrbs # ranges only give C position

ranges(k450)
ranges(rrbs)

overlap <- findOverlaps(ranges(k450), ranges(rrbs))
head(overlap)

rrbs_meth <- as.numeric(rrbs$blockSizes[subjectHits(overlap)])
k450$meth_percent <- k450$score/10
k450_meth <- k450$meth_percent[queryHits(overlap)]

par(mfrow=c(1,2))
plot(k450_meth, rrbs_meth, main = "Methylation scores")

# Only locations with coverage > 10:
rrbs_cov <- rrbs[rrbs$blockCount>10]
overlap2 <- findOverlaps(ranges(k450), ranges(rrbs_cov))

k450_cov_meth <- k450$meth_percent[queryHits(overlap2)]
rrbs_cov_meth <- as.numeric(rrbs_cov$blockSizes[subjectHits(overlap2)])
plot(k450_cov_meth, rrbs_cov_meth, main = "Methylation scores with RRBS coverage > 10")


# Question 2
#-------------
# How many transcript isoforms?
gtf <- readRDS("/Volumes/GroupsBio/Bio_334/Robinson/data/gtf.rds")
head(gtf)
unique(gtf$transcript_version)
length(unique(gtf$transcript_version))
# 4 transcript versions and 1 NA

# What does transcript_biotype describe?
unique(gtf$transcript_biotype)
# Tells you what kind of sequence it is / if that sequence is coding or noncoding, an intron etc

# Select only exons
unique(gtf$type)
exons <- gtf[gtf$type=="exon"]

# Get specific transcript
en <- exons[exons$transcript_id == "ENST00000393577"]
en

# Determine ranges of genomic acceptor and donator sites
beg <- flank(en, width=-2, start=TRUE)
beg
end <- flank(en, width=-2, start=FALSE)
end
ranges(beg)
ranges(end)

library(BSgenome.Hsapiens.UCSC.hg38) # needs rtracklayer
