# -*- coding: utf-8 -*-
"""
Created on Sat May 18 13:05:20 2019

@author: made_
"""

# bio334 utils
# useful functions for genome analysis

import numpy as np
import pandas as pd
import os
import glob

# PRE : requires a gene sequence and a length N to test whether a repeat appears
#       within that length
# POST: returns the truncated identified repeat
def check_repeats(sequence,length):
    probe = sequence[0:length]
    cond = True
    ii = 0
    
    while cond:
        if probe == sequence[ii:length+ii]:
            ii += length
            
        else:
            cond = False
    if ii >= length: return sequence[ii-length:] 

   
# PRE : sequence has to be a list
# POST: returns reversed sequence
def reverse_sequence(sequence):
    reversed_sequence = list()
    N_ = len(sequence)
    ii = 0
    
    while ii < N_:
        reversed_sequence.append(sequence[N_-1-ii])
        ii += 1
    
    print("".join(reversed_sequence))
    reversed_sequence = "".join(reversed_sequence)
    return reversed_sequence


# PRE : must be truncated first with the check_repeats() function
# POST: prints the found matches of a repeat within a gene sequence
def search_matches(truncated, search):
    M = len(search)
    temp = []
    
    print(truncated)  # just to see the new truncated reference sequence
    
    for i in range(len(truncated)):
        temp = truncated[i:i+M]
        if temp == search:
            print(i, "\t", temp, "\t", '    Matched')
        else:
            print(i, "\t", temp, "\t", 'Not Matched')


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

    # uncomment for additional numerical insights
#    print("Total differences =", total_diff)
#    print("nC2 =", combination)
#    print("Lenght of sequence =", len_sequence)
    print("Nucleotide diversity pi =", pi)
#    print("Pair-wise difference PI =", PI)
#    print("Number of SNP sites (total segregating sites) S =", total_seg_sites)
#    print("Frequency of SNP sites s = S/sequence_length =", s)
#    print("sum_{i=1}^{n-1}(1/i) =", sum_)
#    print("estimated pi = s/sum(1/i) =", estimated_pi)
#    print("d = pi - estimated_pi =", d)
    print("Tajima's D =", td)
    return td, pi


# PRE : requires a file containing a protein sequence in one-letter format
# POST: creates a protein dictionary
def create_proteinDict(protSeqFile):
    proteinDict = {}
    
    with open(protSeqFile, 'r') as load:
        for line in load:
            if line.startswith('>'):
                proteinName = line.split()[0][1:]
                proteinDict[proteinName] = ""
            else:
                proteinDict[proteinName] += line.strip()
    
    return proteinDict


# PRE : requires a protein dictionary and coordinate sequence file
# POST: prints the protein names cleanly and nicely.
def clean_and_print(coordSeqFile, proteinDict):
    with open(coordSeqFile, 'r') as load:
        for line in load:
            
            if not line.startswith('#'):
                proteinName = line.strip().split()[0]
                start = int(line.strip().split()[19])
                end = int(line.strip().split()[20])
                c_value = float(line.strip().split()[11])
                
                if c_value < 10**-8:
                    print('>', proteinName)
                    #print(proteinDict[proteinName][start:end+1])



# class for proteins. It basically summarizes the above functions in a handy class
# for an object-oriented approach
class ProtObj:
    def __init__(self,sequence,coordinates):
        self.sequence = sequence
        self.coordinates = coordinates
        self.dictionary = {}
        
    def set_sequence(newsequence):
        self.sequence = newsequence
        
    def get_sequence():
        return self.sequence
    
    def set_coordinates(newcoordinates):
        self.coordinates = newcoordinates
        
    def get_coordinates():
        return self.coordinates
        
        
    def create_proteinDict(self,protSeqFile):
        self.dictionary = {}
    
        with open(self.protSeqFile, 'r') as load:
            for line in load:
                if line.startswith('>'):
                    proteinName = line.split()[0][1:]
                    self.dictionary[proteinName] = ""
                else:
                    self.dictionary[proteinName] += line.strip()
                        
        return self.dictionary


    
    def clean_and_print(self,coordinates, dictionary):
           with open(self.coordinates, 'r') as load:
               for line in load:
            
                   if not line.startswith('#'):
                    proteinName = line.strip().split()[0]
                    start = int(line.strip().split()[19])
                    end = int(line.strip().split()[20])
                    c_value = float(line.strip().split()[11])
                
                    if c_value < 10**-8:
                        print('>', proteinName)
                        #print(dictionary[proteinName][start:end+1]) 
