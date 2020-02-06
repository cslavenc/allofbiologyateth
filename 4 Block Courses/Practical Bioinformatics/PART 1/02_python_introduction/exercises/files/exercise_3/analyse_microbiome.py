# -*- coding: utf-8 -*-
"""
Created on Thu May  9 14:49:07 2019

DOES NOT PRODUCE THE FILTERED FILES AS INTENDED
"""

import os
import sys
import math

# have default options if sys.argv is not given 3 inputs
arguments = sys.argv
#print(arguments)
#script_name = arguments[0]
#input_file = arguments[1]
# make sure all paths exist

data_set_path = 'Human_Microbiome_Project'
os.path.exists(data_set_path)

if os.path.exists('output_folder') == False:
    os.makedirs('output_folder')


# output directory
out_dir = r'C:\Users\made_\Desktop\ETH\4 Block Courses\Practical Bioinformatics\PART 1\02_python_introduction\exercises\files\exercise_3\output_folder'

# go to Data directory of HMP
os.chdir(r'C:\Users\made_\Desktop\ETH\4 Block Courses\Practical Bioinformatics\PART 1\02_python_introduction\exercises\files\exercise_3\Human_Microbiome_Project')
hmp_dir = os.listdir()

# PRE : Performs one step opening a file from hmp_dir.
def pdwrapper(string, switch):
    data = pd.read_csv(string)
    body_part = data.values[0]
    abundance = data.values[1:]
    
    if body_part == switch:
        return (body_part, abundance)


# POST: Performs 1 step of filtering: Only one sample is filtered at a time
def filter_samples(body_part, abundance):
    # allocate space
    filtered_feces = []
    filtered_oral  = []
    filtered_skin  = []
    oral = 'Oral'
    skin = 'Skin'
    feces = 'Feces'
    
    # make oral
    if oral == body_part:
        filtered_oral.append(body_part, abundance)
    
    # make skin
    if skin == body_part:
        filtered_skin.append(body_part, abundance)
    
    # make feces
    if feces == body_part:
        filtered_feces.append(body_part, abundance)
    
    # make this nicer with body_part
    if filtered_feces != []:
        return filtered_feces
    elif filtered_oral != []:
        return filtered_oral
    elif filtered_skin != []:
        return filtered_skin
    else:
        print('Identification of body site: FAILED')

# PRE : A list with the names of the files inside the directory 
# POST: Creates a .txt file with all filtered samples of a body part       
def create_filtered_samples(hmp_dir):
    N = len(hmp_dir)
    switch = ['Skin', 'Oral', 'Feces']
    for s in len(switch):
        sw = switch[s]
        for i in range(N):
            body_part, abundance = pdwrapper(hmp_dir[i],s)
            filtered_df = filter_samples(body_part, abundance)
        # here we have the temporarily stored body_part file for one part
        # write it to the output folder
        filtered_df.to_csv(out_dir, index = None, header = None)
    
    

    
#
#def analysis_microbiome(input_file):
#    if input_file[0] == 'Skin':
#        pass
#        
#    elif input_file[0] == 'Oral':
#        pass
#    
#    elif input_file[0] == 'Feces':
#        pass
#    
#    else:
#        print("Invalid body part! Use: Skin, Oral or Feces")
#    
#    
# 

def main():
    create_filtered_samples(hmp_dir)
    
    
    
    
    
    if __name__ == '__main__':
        main()