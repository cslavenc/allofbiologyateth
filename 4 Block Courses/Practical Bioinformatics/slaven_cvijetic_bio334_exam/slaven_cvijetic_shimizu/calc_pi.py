# -*- coding: utf-8 -*-
"""
Created on Thu May 30 21:03:14 2019

@author: made_
"""

# slaven_cvijetic_shimizu
import sys
import numpy as np
import pandas as pd


# POST: return a list with the extracted nucleotide sequences of a fasta file
def load_fasta(fasta):
    sequences = []
    checker   = False
    length    = []
    with open(fasta) as file:
        for line in file:
            if line.startswith('>'):
                continue
            else:
                line = line.strip()
                sequences.append(list(line))
                length.append(len(line))
                print(len(line))
    
    # check that all sequences have same lengths
    i = 0  # loop variable
    j = 0  # counts if all are same length
    while checker != True:
        if length[0] == length[i]:
            j += 1
        i =+ 1
        if len(length) == j:
            checker = True
    
    
    if checker == True:            
        return sequences


def nt_differences(seq1, seq2):
    N = len(seq1)
    diff = 0
    
    for i in range(N):
        if seq1[i] != seq2[i]:
            diff += 1

    return diff

    

# PRE : sequences from fasta file
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
    # when working via a terminal
    filepath = sys.argv[1]
    
    # when working within a python IDE
    #filepath = 'Athaliana_Chr1_5accessions.fa'
    sequences = load_fasta(filepath)
    
    # calculate pi
    # compare it with the alternative algorithm based on TajimasD function if result is the same
    pi = calc_pi(sequences)
    print(pi)
    
    
    
    
    
    
    
    
    
if __name__ == '__main__':
    main()