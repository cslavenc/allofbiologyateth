#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar 20 13:57:46 2018
Created by Moritz Gruber

COMPUTER SIMULARIONS OF SENSORY SYSTEMS -- EXERCISE 1 -- COCHLEAR IMPLANTS
"""

import numpy as np
import os
from scipy.io.wavfile import read, write
import GammaTones as gt
import math

def test():
    """
    Tests the function CI_sim()
    Replace the path in audioDir with yours and insert the name of the
    sound file.
    """   
    audioDir = '/home/padraigh/Desktop/patsstuff/sounds'   
    soundFile = os.path.join(audioDir, 'tiger.wav')     
    output = CI_sim(soundFile)                                                  # Runs the simulation with default settings
    return output

def CI_sim(input_file,fmin=200,fmax=5000,nelectrodes=20,tbin=1e-2):
    """
    Simulates a cochlear implant audio transformation.
    
    INPUT
    soundFile ... directory of input file
    fmin ........ minimum frequency of CI electrodes
    fmax ........ maximum frequency of CI electrodes
    nelectrodes . number of electrodes (channels) of simulated CI
    tbin ........ duration of time bin
    
    OUTPUT
    out_sound ... a one-dimesional array containing the transformed audio
                  The function also writes a .wav-file to the directory from 
                  which the audio file was loaded.
    NOTES
    A. The function crops off the last part of the audio-file that remains 
    after integer division of its length by the bin size. This was deemed 
    acceptable since it only concerns less than 10 ms of audio in the default 
    setting.
    B. The function applies the filter first, and then cuts the file into time
    bins to simulate the output, and not vice versa.  
    
    """
    
    ### Read data, get specs
    rate, data = read(input_file)
    nData = len(data)
    duration = nData/rate
    
    ### if stereo, make mono (average the channels)
    if len(data.shape)==2:
        data.astype(float)
        in_sound = data[:,0]
    else:
        in_sound = 1*data
        
    ### Compute GammaTone filter weights        
    forward,feedback,cf,ERB,B = gt.GammaToneMake(rate,nelectrodes,fmin,fmax,'moore')

    ### Apply GammaTone filter to input file 
    filtered = gt.GammaToneApply(in_sound,forward,feedback)
    
    ### Split data into chunks of length tbin*rate   
    binsize = int(np.floor(tbin*rate))                                          # bin size in terms of samples
    nbins = int(np.ceil(nData/binsize))                                         # total number of time-bins
    splitting_sites = binsize*np.arange(nbins)                                  # where to split the full file into time-bins
    split_filtered = np.split(filtered,splitting_sites,axis=1)                  # this returns a list of sub-arrays (see help for numpy.split)
        
    ### Compute intensity for each electrode and bin, compute output
    # initialise arrays for output and time-axis
    time = np.linspace(0,duration, nData)                                       # the time-axis we need to compute the output
    out_sound = np.zeros_like(in_sound,dtype=float)                             # array containing the transformed audio 
    for i in range(nelectrodes):                                                # loop through all electrodes and through all time-bins
        for j in range(nbins):
            x = split_filtered[j][i,:]                                          # get the j-th bin for the i-th electrode
            I=np.sqrt(np.sum(np.square(x)))                                     # compute the intensity
            id1, id2 = binsize*(j), binsize*(j+1)                               # get the indices of the current time bin 
            out_sound[id1:id2] += np.sin(2*math.pi*cf[i]*time[id1:id2])*I       # produce the output by overlaying sine waves weighted by their intensities
        
    ### Write .wav-file into directory of origin
    output_name = '_out.wav'                                                    # !! concatenate the suffix '_out2.wav' with whatever the          
    write(output_name,rate,out_sound)                                           # !! input file was called, so that the output that is written
                                                                                # !! is called 'name_of_input_out.wav'      
    return out_sound

if __name__ == '__main__':
    test()