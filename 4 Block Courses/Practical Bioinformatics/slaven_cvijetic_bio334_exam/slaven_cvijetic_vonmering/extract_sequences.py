'''
    Created on May 27, 2019
    To execute the script, first copy it in the folder containing the input file
    calling-syntax: python script.py input_alignment.fasta > output_alignment.fasta
    author: von Mering group
'''

from __future__ import print_function

import sys

sequence_file = open(sys.argv[1]) # read the alignment file

sequences_to_extract = 24 # change to select only the top n sequences, n = 24

extracted_sequences = 0

for line in sequence_file:
    
    if line.startswith('>'):
        
        if extracted_sequences < sequences_to_extract:
            extracted_sequences += 1
        else:
            break
            
    print(line, end='')
