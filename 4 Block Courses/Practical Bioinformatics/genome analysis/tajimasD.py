# -*- coding: utf-8 -*-
"""
Created on Thu May 16 14:04:44 2019

@author: made_
"""

import math
import sys
import numpy as np

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


# PRE : requires two gene sequences (may be the same)
# POST: returns the number of differences between two genes (that is, the number)
#       of different nucleotides
def nt_diversity(seq1, seq2):
    N = len(seq1)
    diff = 0
    
    for i in range(N):
        if seq1[i] != seq2[i]:
            diff += 1

    return diff


# PRE : sequence must be in fasta format
# POST: returns the total number of segregated sequences and prints MAF value
def seg_sequences(sequences):
    # count segregation
    total_seg_sites = 0
    for i in range(0,len(sequences[0])):
        alleles = []
        for seq in sequences:
            alleles.append(seq[i])
        print(sorted(list(set(alleles))), end="\t")
        dic = {}
        for word in set(alleles):
            dic[word] = alleles.count(word)
        dic_list = list(dic.items())
        if len(set(alleles)) > 1:
            total_seg_sites += 1
            if dic_list[0][1] > dic_list[1][1]:
                MAF = dic_list[1][1] / (dic_list[0][1] + dic_list[1][1])
                print('segregated, MAF = ', "%.3f" %MAF)
            if dic_list[0][1] < dic_list[1][1]:
                MAF = dic_list[0][1] / (dic_list[0][1] + dic_list[1][1])
                print('segregated, MAF = ', "%.3f" %MAF)
        else:
            print('not segregated')
                
    return total_seg_sites


# PRE : requires a sequence in fasta format and output from nt_differences() and seq_sequences()
# POST: returns Tajima's D and other values when print() is uncommented.
def tajimasD(sequences, total_diff, total_seg_sites):    
    
    # Calculate pi and d
    num_sequences = len(sequences)
    len_sequence = len(sequences[0])
    combination = num_sequences*(num_sequences-1)/2.0
    pi = total_diff/combination/len_sequence
    
    # Calculate Tajima's D
    a_1 = sum_ = sum([1.0/i for i in range(1, num_sequences)])
    a_2 = sum_2 = sum([1.0/i**2 for i in range(1, num_sequences)])
    b_1 = (num_sequences+1)/(3*(num_sequences-1))
    b_2 = (2*(num_sequences**2 + num_sequences +3))/(9*num_sequences*(num_sequences-1))
    c_1 = b_1 - 1/sum_
    c_2 = b_2 -((num_sequences + 2)/(sum_*num_sequences)) + sum_2/sum_**2
    e_1 = c_1/sum_
    e_2 = c_2/(sum_**2 + sum_2)
    
    s = float(total_seg_sites)/len_sequence
    estimated_pi = s/sum_
    d = pi - estimated_pi
    PI = pi*len_sequence
    dd = PI - total_seg_sites/sum_
    td = dd/math.sqrt((e_1*total_seg_sites + e_2*total_seg_sites*(total_seg_sites-1)))
    
    print("Nucleotide diversity pi =", pi)
    print("Tajima's D =", td)
    return td
    

def main():
    
    filename = sys.argv[1]
    #filename = 'input.fa'
    
    sequences = load_fasta(filename)
    total_seg_sites = seg_sequences(sequences)
    
        # calculate nucleotide diversity
    diversity = 0
    
    for i in range(len(sequences)):
        for j in range(i+1, len(sequences)):
            diversity += nt_diversity(sequences[i],sequences[j])
    total_diff = diversity  # rename
    
    tajimasD(sequences, total_diff, total_seg_sites)

    td, pi = tajimasD(sequences, total_diff, total_seg_sites)
    print('GeneID', "\t", 'PI',pi, "\t", 'Tajimas D',td)
    
if __name__ == '__main__':
    main()