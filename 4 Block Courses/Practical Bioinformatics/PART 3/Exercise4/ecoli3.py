# -*- coding: utf-8 -*-
"""
Created on Wed May 22 14:24:19 2019

@author: made_
"""

import numpy as np
import matplotlib.pyplot as plt
import cobra
from cobra.io import read_sbml_model
from cobra.flux_analysis import single_reaction_deletion
import pandas as pd

def main():
    modelfile = pd.read_csv('iJO1366_reactionInfo.csv')
    print(modelfile.keys())
    print(modelfile.values[:,11])
    print(modelfile)
    
    model = modelfile.to_dict()
    
    

    
    
if __name__ == '__main__':
    main()