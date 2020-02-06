'''
Created on May 27, 2019
to execute the script, first copy it in the folder containing the input file
calling-syntax: python script.py input_alignment_file.fasta > output_sequence_file.fasta
@author: mering_group
'''

from __future__ import print_function

import sys

input_file = open(sys.argv[1],"rU") # read the BLAST generated alignment file 

for line in input_file: #loop over each line of input file
    
    if line.startswith(">"):     # check for fasta header
        header=line
        print(header, end='')    # print the fasta header
    
    else: # when the line is the sequence
        ## Q 3.b  modify using replace function to change "-" gap characters to ""
        seq_without_gaps = line.replace("-", "")

        if seq_without_gaps.isspace(): #checks if the new sequence is empty
            pass #do nothing, i.e. do not write the new sequence in the output file
        else:
            print(seq_without_gaps, end='') # print the sequence without gaps
                    

input_file.close()


            
        
    

