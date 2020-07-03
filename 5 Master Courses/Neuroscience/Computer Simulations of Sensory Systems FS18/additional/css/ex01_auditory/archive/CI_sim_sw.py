#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar 23 21:34:16 2018
Created by Moritz Gruber

COMPUTER SIMULATIONS OF SENSORY SYSTEMS -- EXERCISE 1 -- COCHLEAR IMPLANTS
"""

import numpy as np
import os
from scipy.io.wavfile import read, write
import GammaTones as gt
import math
from sksound.sounds import Sound

def test():
    """Tests the function CI_sim() on a .wav-file of your choosing."""
    audioDir = '/Users/moritzgruber/Library/Mobile Documents/com~apple~CloudDocs/Uni/Master/2nd term/Sensory Systems/Ex1/Python_Auditory/SoundData'
    soundFile = os.path.join(audioDir, 'tiger.wav') 
    CI_sim(soundFile)
    
def windows(nData,winsize,stepsize):
    """Yields a generator object that iterates through the windows."""
    for ii in range(-winsize+stepsize, nData-winsize+1, stepsize):
            yield ii-stepsize+1
            
def CI_sim(input_file,fmin=200,fmax=5000,nelectrodes=20,twin=1e-2,tstep=5e-3):
    """
    Simulates a cochlear implant audio transformation.
    
    INPUT
    soundFile ... directory of input file
    fmin ........ minimum frequency of CI electrodes
    fmax ........ maximum frequency of CI electrodes
    nelectrodes . number of electrodes (channels) of simulated CI
    twin ........ duration of time window
    tstep ....... duration of sliding step
    
    OUTPUT
    out_sound ... a one-dimesional array containing the transformed audio
                  The function also writes a .wav-file to the directory from 
                  which the audio file was loaded.
    NOTES
    A. The function uses a sliding window of duration twin to compute the 
    intensities necessary for the audio output.
    B. The function applies the filter first, and then cuts the file into time
    bins to simulate the output, and not vice versa. 
    C. The audio file sounds correct only when written using sksound! This is 
    why the output is first written using scipy.io, read and played by sksound 
    and finally written by sksound. 
    """
    ### Read data, get specs
    rate, data = read(input_file) #!
    nData = len(data)
    duration = nData/rate
    
    ### If stereo, make mono (average the channels)
    if len(data.shape)==2:
        in_sound = data[:,0]
    else:
        in_sound = 1*data
        
    ### Compute GammaTone filter weights        
    forward,feedback,cf,ERB,B = gt.GammaToneMake(rate,nelectrodes,fmin,fmax,'moore')
    
    ### Apply GammaTone filter to input file 
    filtered = gt.GammaToneApply(in_sound,forward,feedback)
    
    ### Get window size and step size in terms of samples
    winsize = int(np.floor(twin*rate))  
    stepsize = int(np.floor(tstep*rate)) 
    
    ### Initialise output array and time array
    out_sound = np.zeros((nelectrodes, nData), dtype=float)  
    time = np.linspace(0, duration, nData)
    
    ### Loop over windows
    for k in windows(nData,winsize,stepsize):
        # Get indices of current window
        idx1 = max(0,k)
        idx2 = min(k+winsize,nData)
        if idx2 > 0:
            x = filtered[:,idx1:idx2] # get current window           
            I = np.sqrt(np.sum(np.square(x),axis=1)) # compute sqrt(intensity)
            for elec in range(nelectrodes):
                # Create audio output for every electrode
                out_sound[elec,idx1:idx2] = np.sin(2*math.pi*cf[elec]*time[idx1:idx2])*I[elec]
    
    # Sum rows to yield a single audio track, write and play back
    out_sound = np.sum(out_sound,axis=0)
    outname = '_fin_out.wav'
    write(outname,rate,out_sound)
    playout = Sound(outname)
    playout.play()
    playout.write_wav(outname)
    
    return out_sound
