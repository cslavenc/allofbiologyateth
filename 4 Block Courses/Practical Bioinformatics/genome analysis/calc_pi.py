# -*- coding: utf-8 -*-
"""
Created on Thu May 16 11:03:41 2019

@author: made_
"""
import numpy as np
import sys

# PRE : requires two gene sequences (may be the same)
# POST: returns the number of differences between two genes (that is, the number)
#       of different nucleotides
def nt_differences(seq1, seq2):
    N = len(seq1)
    diff = 0
    
    for i in range(N):
        if seq1[i] != seq2[i]:
            diff += 1

    return diff


# POST: return a list with the extracted nucleotide sequences of a fasta file
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


# PRE : sequences from fasta file
# POST: calculates the PI-value of two sequences
def calc_pi(sequences):
    
    # calculate nucleotide diversity
    pw_comp =  len(sequences)
    Nc = pw_comp*(pw_comp-1)/2
    
    diversity = 0
    
    for i in range(len(sequences)):
        for j in range(i+1, len(sequences)):
            diversity += nt_differences(sequences[i],sequences[j])
                
    
    pi_ij = diversity/Nc
    PI = pi_ij/len(sequences[0])
    
    return PI


def main():
    sequences = load_fasta(sys.argv[1])
    pi = calc_pi(sequences)
    print("pi =", "%.4f" % pi)
  
    
if __name__ == '__main__':
    main()