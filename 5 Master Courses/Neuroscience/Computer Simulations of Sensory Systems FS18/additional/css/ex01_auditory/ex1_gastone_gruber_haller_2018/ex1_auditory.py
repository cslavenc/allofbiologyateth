# !/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Date: March 2018
Version 1
Created by Moritz Gruber
           Patrick Haller
           Alexandra Gastone Guilabert

### Instructions ###
1) Store the archive.
2) Open a terminal window.
3) Either cd into the directory and type "python ex1_auditory.py <", 
   or directly type "/your_path/ex1_auditory.py".
4) Select an input-sound-file when prompted.
5) Both input and output sounds will be played.
6) The output sound will also be written to the subfolder ~/sounds in the same 
   directory as the archive with a suffix *_out.

COMPUTER SIMULATIONS OF SENSORY SYSTEMS -- EXERCISE 1 -- COCHLEAR IMPLANTS
"""

import numpy as np
import os
import GammaTones as gt
import math
#from tkinter import filedialog
from tkinter import *
from sksound.sounds import Sound


def main():
    """
    Main function: Reads in the selected sound file, plays it and then
    calculates and plays the CI output.
    """
    soundFile = get_file()
    obj_sound_in, obj_sound_out, out_sound = simulate(soundFile)
    print('Playing input file: ')
    obj_sound_in.play()
    print()
    output_name = "{}_out{}".format(os.path.splitext(soundFile)[0], os.path.splitext(soundFile)[1])
    obj_sound_out.write_wav(output_name)
    print()   
    print('Playing output file: ')
    obj_sound_out.play()
    print('Successfully wrote output to subfolder ~/sounds')


def get_file():
    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    os.chdir(dname)
    root = Tk()
    root.filename = filedialog.askopenfilename(
        initialdir=os.curdir, title="Select sound file", filetypes=
        (("sound files", ("*.wav", "*.mp3")), ("all files", "*.*")))
    return root.filename


def simulate(input_file, fmin=200, fmax=5000, nelectrodes=20, tbin=1e-2):         # Runs the simulation with default settings
    """
    Simulates a cochlear implant audio transformation.

    INPUT
    input_file .... input sound file supplied by user
                    non-WAV files are converted to WAV using FFMPEG
    fmin .......... minimum frequency of CI electrodes
    fmax .......... maximum frequency of CI electrodes
    nelectrodes ... number of electrodes (channels) of simulated CI
    tbin .......... duration of time bin

    OUTPUT
    obj_sound_in .. an sksound.sound object of the input sound file
    out_sound ..... a one-dimesional array containing the transformed audio
                    The function also writes a .wav-file to the directory from
                    which the audio file was loaded.
    obj_sound_out . an sksound.sound object of the output sound file
    """

    ### Read data, get specs with sksounds.sound
    obj_sound_in = Sound(input_file)
    data = obj_sound_in.data
    rate = obj_sound_in.rate
    nData = len(data)
    duration = nData / rate

    ### if stereo, average channels
    if len(data.shape) == 2:
        in_sound = 0.5 * (data[:, 0] + data[:, 1])
    else:
        in_sound = 1 * data

    ### Compute GammaTone filter weights
    forward, feedback, cf, ERB, B = gt.GammaToneMake(
        rate, nelectrodes, fmin, fmax, 'moore')

    ### Apply GammaTone filter to input file
    filtered = gt.GammaToneApply(in_sound, forward, feedback)

    ### Split data into chunks of length tbin*rate
    binsize = int(np.floor(tbin * rate))                                        # bin size in terms of samples
    nbins = int(np.ceil(nData / binsize))                                       # total number of time-bins
    splitting_sites = binsize * np.arange(nbins)                                # where to split the full file into time-bins
    split_filtered = np.split(filtered, splitting_sites,
                              axis=1)                                           # this returns a list of sub-arrays (see help for numpy.split)

    ### Compute intensity for each electrode and bin, compute output
    # initialise arrays for output and time-axis
    time = np.linspace(0, duration, nData)                                      # the time-axis we need to compute the output
    out_sound = np.zeros_like(in_sound, dtype=float)                            # array containing the transformed audio
    for i in range(nelectrodes):                                                # loop through all electrodes and through all time-bins
        for j in range(nbins):
            x = split_filtered[j][i, :]                                         # get the j-th bin for the i-th electrode
            I = np.sqrt(np.sum(np.square(x)))                                   # compute the intensity
            id1, id2 = binsize * (j), binsize * (j + 1)                         # get the indices of the current time bin
            out_sound[id1:id2] += np.sin(2 * math.pi * cf[i] * time[
                                                               id1:id2]) * I    # produce the output by overlaying sine waves weighted by their intensities
    ### output sound object with sksounds.Sound
    obj_sound_out = Sound(inData=out_sound, inRate=rate)

    return obj_sound_in, obj_sound_out, out_sound


if __name__ == '__main__':
    main()
