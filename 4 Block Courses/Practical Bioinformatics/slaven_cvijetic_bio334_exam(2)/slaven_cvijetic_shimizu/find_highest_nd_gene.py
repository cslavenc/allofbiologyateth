# -*- coding: utf-8 -*-
"""
Created on Thu May 30 21:03:14 2019

@author: made_
"""

# slaven_cvijetic_shimizu
import sys
import numpy as np


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
                #print(len(line))
    
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

# PRE : a gff filepath
def load_gff(gff):
    start_list = []
    end_list   = []
    gene_list  = []
    with open(gff) as file:
        for i in range(1,5):
            for line in file:
                if line.startswith('Chr'+str(i)) and line.split()[2] == 'gene':
                    start_list.append(line.split()[3])
                    end_list.append(line.split()[4])
                    # append the gene name
                    #gene_list.append(line[8].strip('ID=').split(';')[0])
                    #line = line.split(';')
                    gene_list.append(line.split()[8].split(';')[0].strip('ID='))
                    
                    
    return start_list, end_list, gene_list

              
def find_highest_nd_gene(start, end, gene_list, sequences):
    # calculate nucleotide diversity for every gene and print the one with the highest diversity
    nd_container = []
    N = len(start)
    chromo, n = np.shape(sequences)  # chromo = 5
    
    gene_idx = 0
    
    
    # fill up nt_container by iterating over the sequences and their chromosomes
    # maybe I need to save the chromosome_id somewhere
    for chrom_id in range(0,chromo-1):
        for i in range(N):
            temp = nt_differences(sequences[chrom_id][start[i]:end[i]],
                                  sequences[chrom_id+1][start[i]:end[i]])
            nd_container.append(temp)
    
    highest_nd = nd_container[gene_idx]    
    # search for the highest nd and update appropriately
    for i in np.arange(0, len(nd_container)):
        if nd_container[i] > highest_nd:
            gene_idx = i
            highest_nd = nd_container[gene_idx]
    
#    print(np.shape(nd_container))
#    print(len(set(nd_container)))      
    # 'Gene:', gene_list[gene_idx]
    #print('Max nucleotide difference:', nd_container[gene_idx], gene_list[gene_idx])
    print('Max nucleotide difference:', nd_container[gene_idx], ', Gene idx:', gene_idx)
    
    return nd_container[gene_idx], gene_list[gene_idx] #, gene_idx
    
   
    
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
    print(np.shape(sequences))
    # load gff file
    #filepath_gff = sys.argv[2]
    filepath_gff = 'Athaliana_Chr1.gff'
    start_list, end_list, gene_list = load_gff(filepath_gff)
    start_list = list(map(int,start_list))
    end_list = list(map(int, end_list))
    
    #print(gene_list)  # gene names are saved successfully
    
    # find gene with highest nucleotide diversity
    nd_val, gene_name = find_highest_nd_gene(start_list, end_list, gene_list, sequences)
    
    
    
if __name__ == '__main__':
    main()