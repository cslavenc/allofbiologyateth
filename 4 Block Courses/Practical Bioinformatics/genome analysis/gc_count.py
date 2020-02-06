# -*- coding: utf-8 -*-
"""
Created on Thu May 16 09:10:26 2019

@author: made_
"""

import sys


def main():
    genome_size = 0
    gc_count    = 0
    read_count  = 0
    good_lines  = []
    temp        = 0
  
    # for fast testing  --- else use sys.argv[1]
    filename = 'sample.fq'
    file = open(filename)
    
    for i in file:
        temp += 1
        if temp == 2:
            i = i.strip()
            good_lines.append(i)
            
        elif temp == 4:
            temp = 0  # reset temp so that you can extract DNA sequence
            
    read_count = len(good_lines)
            
    for i in range(len(good_lines)):
        genome_size += len(good_lines[i])
        
        for j in range(len(good_lines[i])):
            if 'G' == good_lines[i][j]:
                gc_count += 1
            elif 'C' == good_lines[i][j]:
                gc_count += 1
        
    
    file.close()              
    
    print(read_count)
    print('Average read length = ', genome_size/read_count, 'bp')
    print('GC content = GC count/genome size = ', gc_count/genome_size)
   
    
if __name__ == '__main__':
    main()