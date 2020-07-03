# -*- coding: utf-8 -*-
"""
Created on Sat Mar 24 15:17:55 2018

@author: made_


NOTES: Name the variables more nicely
"""
from numpy import *


def outsound(segsize, stepsize, tbin, i, j, time, I, cf):
    '''
    Helper function for readibility.
    j is the j-th step in the loop the function is called. Same for i.
    
    OUTPUT:
        Overlapping sine waves weighted by their intensities using a small
        stepsize to produce the data.
    '''
    # Discard any negative exponent. E.g. in tbin = 6e-3, we are only interested in 6 to use in linspace
    tbin_ = tbin
    while tbin_ <= 1:
        tbin_ *= 10
    ss, step = linspace(0, tbin_, stepsize*tbin_, retstep=True)
    a, b = zeros(int(tbin_ * stepsize**-1)) # del a,b later
    outdata = zeros_like(ss)
    
    for k in range(len(ss)):
        a, b = segsize*j + ss[k], segsize*j + ss[k+1]    
        outdata[a:b] += np.sin(2 * pi * cf * time[a:b]) * I
        del a, b
        
    return outdata
    