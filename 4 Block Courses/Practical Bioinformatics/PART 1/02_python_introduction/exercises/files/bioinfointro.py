# -*- coding: utf-8 -*-
"""
BIOINFORMATICS INTRO EXERCISES
"""

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def remove_odd(lists):
    even = []
    N = np.size(lists)
    
    for i in range(N):
        if lists[i] % 2 == 0:
            even.append(lists[i])
    
    return even



def main():
    # Exercise 1
    interval = np.linspace(1,20,20, dtype=int)
    sq_interval = np.zeros_like(interval)
    
    for i in range(np.size(interval)):
        sq_interval[i] = interval[i]**2
        
    interval2 = np.linspace(1,20,20, dtype=int)
    squared2  = []
    
    i = 0
    while i < 20:
        squared2.append(interval2[i]**2)
        i += 1
    print(interval, sq_interval)
    print(interval2, squared2)
    
    # remove odd numbers
    even_list = remove_odd(squared2)
    print(even_list)
    
    # string manipulation
    some_dna = "aACTa TtCcC acCtc\tcaTCC CGGCc\nTaTaT CTGaa"
    stripped = some_dna.strip()  # removes (leading) ws, if input is given, then it removes the input
    print('It is stripped now:', stripped)
    splitted = stripped.split()
    print('It is split now:', splitted)
    
    upper_dna = []

    
    i = 0
    while i < 6:
        upper_dna.append(splitted[i].upper())
        i += 1
       
    print(upper_dna)
    
    upper_dna = '\n'.join(upper_dna)
    print(upper_dna)
    
    
    # Exercise 2
    os.chdir(r"C:\Users\made_\Desktop\ETH\4 Block Courses\Practical Bioinformatics\PART 1\02_python_introduction\exercises\files\exercise_2")
    dnaseq = pd.read_csv('strange_dna.txt', header = None)
    dnavals = dnaseq.values
    
    items = ['A', 'C', 'T', 'G']
    for i in range(len(items)):
        print('Numbers of Nucleotide', items[i], 'is: ', str(dnavals).count(items[i]))

    # count #nucleotides in a more laborious way
    print('Number of Nucleotide A: ', str(dnavals).count('A'))
    print('Number of Nucleotide C: ', str(dnavals).count('C'))
    print('Number of Nucleotide T: ', str(dnavals).count('T'))
    print('Number of Nucleotide G: ', str(dnavals).count('G'))
    
    
if __name__ == '__main__':
    main()