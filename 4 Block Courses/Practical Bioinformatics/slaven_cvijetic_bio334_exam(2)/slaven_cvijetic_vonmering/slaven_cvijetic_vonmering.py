# -*- coding: utf-8 -*-
"""
Created on Thu May 30 21:03:14 2019

@author: made_
"""

# slaven_cvijetic_vonmering
import numpy as np
import pandas as pd
import sys


def load_fasta(fasta):
    sequences = []
    with open(fasta) as file:
        for line in file:
            if line.startswith('>'):
                continue
            else:
                line = line.strip()
                sequences.append(line)
                
    return sequences


def main():
    # 1) already downloaded, but import to python anyway
    #filepath = sys.argv[1]
    filepath = 'protein_to_study.fasta.txt'
    
    sequences = load_fasta(filepath)
    print(sequences)
    
    # 2a) number of sequences showing the same alignment score = 24 based on BLAST search results
    # 2b) downloaded in exam folder vonmering
    
    # 3a) see corresponding files in exam folder
    # 3b) see corresponding files in exam folder
    
    # 4) see folder
    
    # 5) ./hmmsearch --domtblout domain_position.txt Paxillin.hmm high_scoring_hits.fasta
    # and ./hmmalign --outformat A2M Paxillin.hmm high_scoring_hits.fasta > domain_position.txt
    # do not work.
    # ERROR MSG: -bash: ./hmmsearch: Datei oder Verzeichnis nicht gefunden
    # even after reinstalling
    # it is somewhat difficult to work with programs that need to be re-installed during the exam
    # also, I am working on my own laptop, so it makes things even more tedious if we do not all
    # have the same conditions.
    # Also, when trying to compile hmmsearch.c, it did not work with:
    # gcc -o h1 hmmsearch.c
#    hmmsearch.c:8:23: fatal error: p7_config.h: Datei oder Verzeichnis nicht gefunden
#     #include "p7_config.h"
#                           ^
#    compilation terminated.
    # also, i had to remove hmmalign and hmmsearch from the directory as they caused problems when trying to make the zip file
    # in any case do:
    # ./hmmsearch --domtblout domain_position.txt Paxillin.hmm high_scoring_hits.fasta
    # and this generates domain_position.txt
    # then, in the shell: python3 cut_domain_from_proteins.py high_scoring_hits.fasta domain_position.txt > paxillin_clean.fasta
    # the last output can be used for Ex7 for clustalX
    
     
    # 6) see corresponding file
    
    # 7) cannot do because of error in 5)
    
    # 8a) check folder
    # 8b) the nearest neighbours are: gi|1024927658|ref|XP 016362368.1|.44 and gi|1025331920|ref|XP 016329709.1|.44
    
    
if __name__ == '__main__':
    main()

