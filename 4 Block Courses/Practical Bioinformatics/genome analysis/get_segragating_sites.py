# -*- coding: utf-8 -*-
"""
Created on Thu May 16 13:07:47 2019

@author: made_
"""

import sys


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

# only called if "not segregated" is true, alleles comes from the set differences
#def calc_MAF(sequences):
#    N = len(sequences)
#    
#    maf1 = 0
#    maf2 = 0
#    alleles = []
#    
#    for i in range(N):
#        for seq in sequences:
#            alleles.append(seq[i])
#    
#    return maf1/maf2  # = MAF

def main():
    
    # filename = sys.argv[1]
    filename = 'input.fa'    
    sequences = load_fasta(filename)    
    total_seg_sites = seg_sequences(sequences)        
    print("total segregating sites =", total_seg_sites)  # Show the total number of segregating sites 
    
if __name__ == '__main__':
    main()