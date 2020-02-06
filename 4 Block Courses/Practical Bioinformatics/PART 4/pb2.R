# Practical Bioinformatics 2
# Demo 2

library(Biostrings)
library(GenomicRanges)
library(ggplot2)
library(BSgenome.Hsapiens.UCSC.hg38)



# Create a GRanges object
?GRanges
gr <- GRanges(seqnames = c("chr1", "chr1", "chr1"),
              ranges = IRanges(start = c(1,8,11),
                               end = c(5,15,15)),
              strand = c("+", "+", "+"))
gr

# add one meta column - GRanges automatically knows that it needs to assign this column as type
# as a metacolumn (see output)
gr$type <- c("exon", "intron", "exon")
gr[1,]  # gr[,1] cannot be executed for GRanges objects, but gr[1,] works fine
gr[gr$type == "exon"]  # prints those with exons as type

# extract granges
granges(gr)  # only coordinates, no metacolumns as output
ranges(gr)

# seqinfo cannot be called with $, but works with @ on a ranges(obj) object
gr[ranges(gr)@start == 1]

mcols(gr)  # extract metadata
seqinfo(gr)

?reduce
reduce(gr)
gaps(gr)
gr1 <- resize(gr, fix = "start", width = 2)  # start/end is fixed, and then width only 2 so we
# lose width from before

gr2 <- disjoin(gr)  # no overlaps in IRanges anymore (compare it to gr)

# get subsets
gr3 <- gr[1:2]
gr4 <- gr[3]

gr5 <- findOverlaps(gr3,gr4)
queryHits(gr5)


### Work with the human genome from here on
getSeq(Hsapiens, names = "chr1")
dd <- GRanges(seqnames = c("chr1", "chr2"),
              ranges = IRanges(start = c(10000,20000),
                               end = c(10050, 20050)))
getSeq(Hsapiens, dd)



