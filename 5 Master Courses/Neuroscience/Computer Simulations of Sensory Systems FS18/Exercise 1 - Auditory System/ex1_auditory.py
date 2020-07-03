# -*- coding: utf-8 -*-
"""
Author : Slaven Cvijetic, 14-913-362
Version: 1.2.0
Created on March 25th 2018 (Sun)

-------------------------------------------------------------------------------
Computer Simulations of Sensory Systems: Exercise 1 (Auditory System)

Run program by pressing the run button.

NOTES
-------------------------------------------------------------------------------
Any non-WAV files are converted to WAV using the module FFMPEG.

"""

import numpy as np
import os, ffmpeg, math
import tkinter as tk
from sksound.sounds import Sound
from numpy.fft import *
from scipy.io.wavfile import write
import GammaTones as gt


def main():
    """
    Main function
    """
    # Select a sound file.
    infile, soundname, outputname = select_sound()
    soundIn, soundOut, CIsound, fs = CIsimulate(infile)
    print('Now playing: ', soundname)
    soundIn.play()
    
    write(outputname, fs, CIsound)
    print('Now playing: ', outputname)
    soundOut.play()
    
    return 0


def select_sound():
    """
    This function opens a GUI to select a sound file using the module tkinter.
    
    OUTPUT
    ---------------------------------------------------------------------------
    root.fname  : Full filepath of the selected sound file.
    soundname   : Name of the selected sound file.
    outputname  : Name of the output sound file for later use.
    """
    
    filePath = os.path.abspath(__file__)
    pathDir = os.path.dirname(filePath)
    os.chdir(pathDir)   # change directory to where this script is opened
    root = tk.Tk()
    root.fname = tk.filedialog.askopenfilename(                                 # get the complete filepath as a string
            initialdir=os.curdir, title="Select file", filetypes=
            (("sound files", ("*.wav", "*.mp3")), ("all files", "*.*")))
    root.destroy()                                                              # close tk.Tk() 
    soundname = os.path.basename(root.fname)                                    # (otherwise, Tk window remains open and cannot be closed manually. This crashes python.)
    splitname = os.path.splitext(root.fname)
    temp = '_out'
    outputPath = splitname[0] + temp + splitname[1]
    outputname = os.path.basename(outputPath)
    
    return root.fname, soundname, outputname


def CIsimulate(infile, Fmin=200, Fmax=5000, numElectrodes=20, tSeg=6*10**-3,
                stepSize=5*10**-4):
    """
    Simulation of a cochlear implant audio transformation.
    
    INPUT
    ---------------------------------------------------------------------------
    inFile       : Filepath of the sound file.
    Fmin         : Lower frequency boundary of CI electrodes.
    Fmax         : Upper frequency boundary of CI electrodes.
    numElectrodes: Number of (active) electrodes to simulate a cochlea implant.
    tSeg         : Seg means segment. tSeg is the time length of a segment.
    stepSize     : Size of step to proceed in a time segment.
        
    OUTPUT
    ---------------------------------------------------------------------------
    soundIn      : An skound.sounds object of type Sound. 
    soundOut     : An skound.sounds object of type Sound. It simulates the 
                   signal which a cochlear implant user would hear, hence it is
                   the transformed form of soundIn.
    CIsound      : An 1-D array containing the weighted intensities. It is used
                   to produce the final WAV file.
    fs           : Sample frequency of the input sound file.
    
    NOTES
    ---------------------------------------------------------------------------
    write notes when the complete and final program is ready to be handed in.
    Any non-WAV files are converted to WAV using the module FFMPEG.
    
    """
    # Get data with sksound.sounds
    soundIn = Sound(inFile=infile)
    data = soundIn.data
    fs = soundIn.rate
    nData = len(data)
    duration = nData / fs

    # Make stereo to mono if applicable
    if len(data.shape) == 2:
        soundData = 0.5 * (data[:, 0] + data[:, 1])
    else:
        soundData = 1 * data

    # Compute GammaTone filter weights
    forward, feedback, cf, ERB, B = gt.GammaToneMake(
            fs, numElectrodes, Fmin, Fmax, 'moore')

    # Apply GammaTone filter to inFile
    filtered = gt.GammaToneApply(soundData, forward, feedback)

    # Split data into slices of length tSeg*fs
    segSize = int(np.floor(tSeg * fs))                                          # length of segment size
    nSegments = int(np.ceil(nData / segSize))                                   # total number of segments
    split_sites = segSize * np.arange(nSegments)                                # location of split segments
    split_filtered = np.split(filtered, split_sites,                            # an array containing sub arrays of the split segments
                              axis=1)

    # Compute intensity for each electrode and segment, compute output
    # Allocate memory for output and time-axis
    time = np.linspace(0, duration, nData)
    CIsound= np.zeros_like(soundData, dtype=float)                              # allocate memory for the transformed sound
    for i in range(numElectrodes):
        for j in range(nSegments):
            temp = split_filtered[j][i, :]                                      # access the j-th segment for the i-th electrode
            I = np.sqrt(np.sum(np.square(temp)))                                # compute intensity                                
            ind1 = segSize * (j)                                                # get the indices of the current time segment
            ind2 = segSize * (j + 1)
            CIsound[ind1:ind2] += np.sin(2 * math.pi * cf[i] * time[            # generate the transformed sound as floats
                                                               ind1:ind2]) * I  # from the sine waves with intensity I as the weight
    # Output: Sound object using sksound.sounds.Sound
    soundOut = Sound(inData=CIsound, inRate=fs)                                 # generate the transformed sound from the obtained floats

    return soundIn, soundOut, CIsound, fs


if __name__ == '__main__':
    main()