# -*- coding: utf-8 -*-
"""
Created on Mon Mar 12 21:59:41 2018

@author: made_
"""

# Hill reaction in pea thylakoids- result evaluation

from matplotlib.pyplot import *
from numpy import *

def func(arr):
    default = abs(arr[0] - arr[1])
    temp = zeros(10)
    for i in range(len(temp)):
        temp[i] = arr[i+2] / default * 100
    return temp

ext = array([0.876, 0.717, 0.871, 0.736, 0.933, 1.004, 0.824, 0.747, 0.914, 0.803, 0.697, 0.699])
N = arange(len(ext)+1)
N = N[3:13]
temp = func(ext)

xlabel("test tube according to the extinction series")
ylabel("% of maximal DCPIP reduction")
plot(N, temp)

