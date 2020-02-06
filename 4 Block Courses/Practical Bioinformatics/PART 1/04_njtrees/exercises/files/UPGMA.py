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
    
    with open(protseqfile, 'r') as load:
        for line in load:
            if not line.startswith('>'):
                proteinlist.append(line.strip())
           
    
    #print(proteinlist)  # for checking if it exists
    N = len(proteinlist)
    #M = len(proteinlist[0])  # length of a protein sequence
    measure = np.zeros([N,N])
    
    for j in range(N):
        for k in range(N):
            if j == k:
                measure[j,k] = 0
            else:
                measure[j,k] = jaccard_comparison(proteinlist[j], proteinlist[k])
                measure[k,j] = measure[j,k]
            
    print(measure)  # only the first step
    
    # find maximal resemblance, which is the smallest value != 0 --- must become a loop later or fun
    testm = measure.flatten()
    testm1= sorted(testm)
    print(testm1)
    testm1 = np.unique(testm1)
    print(testm1)
    minval = testm1[1]  # the smallest value will always be 0, which is the trivial
    
    # get index where minval is from the measure array
    idxtest = measure.index(minval)  # does not work yet
    
if __name__ == '__main__':
    main()