# -*- coding: utf-8 -*-
"""
Created on Sun Mar 25 10:44:04 2018

@author: made_
Used for CIsimulate() opimization.
"""

# Frequency analysis to denoise (how many are there fulfilling a condition)
import numpy as np

def freq_counter(inSound, condition=None):
    # inSound has to be mono
    if len(inSound.shape) == 2:
        inSound = 0.5 * (inSound[:, 0] + inSound[:, 1])
    else:
        inSound = 1 * inSound
        
    if condition == None:
        condition = int(input("Choose Fmin: "))
    
    # Allocate memory for counter and indicies container    
    N = len(inSound)
    count = 0
    ind = np.zeros(N)
    
    for i in range(N):
        if inSound[i] < condition:
            counter += 1
            ind[i] = i # save the index where the condition was fulfilled

    return count, ind