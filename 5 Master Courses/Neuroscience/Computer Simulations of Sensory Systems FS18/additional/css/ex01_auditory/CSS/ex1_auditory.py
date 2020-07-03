#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Date: March 2018
Authors: Moritz Gruber, Alexandra Gastone, Patrick Haller

instructions: store the archive and run ex1_auditory.py (you don't have to cd into the
target directory, but the path to the python program has to be specified if you run it 
from a directory other than the location where you saved it.) You are asked to select
a sound file, which is directly stored to the subfolder /sounds with a suffix *_out

COMPUTER SIMULARIONS OF SENSORY SYSTEMS -- EXERCISE 1 -- COCHLEAR IMPLANTS
"""

import numpy as np
import os
from scipy.io.wavfile import read, write
import GammaTones as gt
import math
from sksound.sounds import Sound

from tkinter import filedialog
from tkinter import *


def main():
    """
    Main method: Read in soundfile, 
    """   
    soundFile = get_file()   
    obj_sound_in, obj_sound_out, out_sound, rate = simulate(soundFile)

    print('Playing input file: ')
    obj_sound_in.play()
    print()

    output_name = "{}_out{}".format(
        os.path.splitext(soundFile)[0], os.path.splitext(soundFile)[1])
    write(output_name,rate,out_sound)
    print('successfully wrote output to subfolder sounds')

    print('Playing output file: ')
    obj_sound_out.play()


def get_file():
    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    os.chdir(dname)
    root = Tk()
    root.filename =  filedialog.askopenfilename(
        initialdir = os.curdir,title = "Select file",filetypes = 
        (("sound files", ("*.wav", "*.mp3")),("all files","*.*")))
    return root.filename                                            

def windows(nData,winsize,stepsize):
    """Yields a generator object that iterates through the windows."""
    for ii in range(-winsize+stepsize, nData-winsize+1, stepsize):
            yield ii-stepsize+1

def simulate(input_file,fmin=200,fmax=5000,nelectrodes=20,twin=1e-2,tstep=5e-3):
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
    input_sound = Sound(input_file)
    data = input_sound.data
    (source, rate, numChannels, totalSamples, duration, bitsPerSample) = input_sound.get_info()
    nData = totalSamples
    
    ### if stereo, cut second channel
    if numChannels==2:
        data.astype(float)
        in_sound = data[:,0]
    else:
        in_sound = data

    ### Compute GammaTone filter weights        
    forward,feedback,cf,ERB,B = gt.GammaToneMake(
        rate,nelectrodes,fmin,fmax,'moore')

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
                out_sound[elec,idx1:idx2] = np.sin(
                    2*math.pi*cf[elec]*time[idx1:idx2]
                    )*I[elec]
    
    # Sum rows to yield a single audio track, write and play back
    out_sound = np.sum(out_sound,axis=0)
    obj_sound_out = Sound(inData=out_sound, inRate=rate)

    return input_sound, obj_sound_out, out_sound, rate

if __name__ == '__main__':
    main()