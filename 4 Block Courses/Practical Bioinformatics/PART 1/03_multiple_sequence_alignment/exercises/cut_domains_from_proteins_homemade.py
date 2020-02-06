# -*- coding: utf-8 -*-
"""
Created on Fri May 10 11:06:39 2019

@author: made_
"""

import sys

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
                    print(proteinDict[proteinName][start:end+1])

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
    
    # requires the coordinates of a coordinated sequence file
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
    
    
    



def main():
    # If files are passed via a terminal to the program
#    protSeqFile = sys.argv[1]
#    coordSeqFile= sys.argv[2]
    
    # define names manually for testing
    protSeqFile = 'mfs_domain_proteins.fa'
    coordSeqFile= 'domains_found.tsv'
    
    # User-defined functions approach
    proteinDict = create_proteinDict(protSeqFile)   
    print(proteinDict.keys())                             
    clean_and_print(coordSeqFile, proteinDict)
    print(proteinDict)
    
    # Object-oriented approach
    p1 = ProtObj(protSeqFile, coordSeqFile)
    proteinDict = p1.create_proteinDict
    p1.clean_and_print(coordSeqFile, proteinDict)
    print(proteinDict)
    
    
if __name__ == '__main__':
    main()


