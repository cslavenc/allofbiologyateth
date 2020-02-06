# -*- coding: utf-8 -*-
"""
Created on Wed May 15 14:57:27 2019

@author: made_
"""


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
    
#    print(sequence)
#    print("".join(temp2))
    return reversed_sequence



def main():
    # Comparison
    reference = 'ATGCATGCATGCATGCATATATGCATGC'
    search = 'ATAT'

    M = len(search)
    temp = []
    
    ref_new = check_repeats(reference, M)
    print(ref_new)  # just to see the new truncated reference sequence
    
    for i in range(len(ref_new)):
        temp = ref_new[i:i+M]
        if temp == search:
            print(i, "\t", temp, "\t", '    Matched')
        else:
            print(i, "\t", temp, "\t", 'Not Matched')
    
            
    # reverse sequence
    reference2 = 'ATGCATGCATGCATGCATATATGCATGC'
    temp2 = reverse_sequence(reference2)
    
    print(reference2)
    print("".join(temp2))
 
    
if __name__ == '__main__':
    main()