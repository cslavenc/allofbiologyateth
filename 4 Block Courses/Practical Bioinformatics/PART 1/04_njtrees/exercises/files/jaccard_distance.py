# -*- coding: utf-8 -*-
"""
Created on Fri May 10 14:15:07 2019

@author: made_
"""

import numpy as np
import sys


def jaccard_comparison(p_seq1, p_seq2):
    assert(len(p_seq1) == len(p_seq2))
    N = len(p_seq1)
    diss = 0
    
    for i in range(N):
        if p_seq1[i] != p_seq2[i]:
            diss += 1
    
    return(1 - ((N-diss)/N))

      
    
    
def main():
    # sys.argv usage
    #protseqfile = sys.argv[1]
    
    protseqfile = 'protseq.txt'
    
    
    proteinlist = []
    #count = 0
    
    with open(protseqfile, 'r') as load:
        for line in load:
            if not line.startswith('>'):
                proteinlist.append(line.strip())
                #count += 1
           
    
    #print(proteinlist)  # for checking if it exists
    N = len(proteinlist)
    M = len(proteinlist[0])
    measure = np.zeros([5,5])
    
    for j in range(N):
        for k in range(N):
            if j == k:
                measure[j,k] = 0
            else:
                measure[j,k] = jaccard_comparison(proteinlist[j], proteinlist[k])
                measure[k,j] = measure[j,k]
            
    print(measure)
    
if __name__ == '__main__':
    main()