# !/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on
Created by Moritz Gruber
           Patrick Haller
           Alexandra Gastone Guilabert

COMPUTER SIMULATIONS OF SENSORY SYSTEMS -- EXERCISE 1 -- COCHLEAR IMPLANTS

----------------------------
note to us:
   I can't run it because tkinter makes my python crash...
    but I just added the sksound.sounds handling so that can use non-WAV files as input files to CI_sim function,
    and use the Sound objects to play the input and output sounds in main()

to do:
   - readme.txt
   - does it make sense to filter the whole file and then divide into time bins?
   - 'The time-windows which are typically used for the determination of the stimulation
      parameters are about 6 ms, and are moved forward in steps of about 0.5 ms.'
      should we do this or stick to the 10ms time bins, move forward to next 10ms?
   - should we make gui for setting CI_sim parameters?
----------------------------

"""

import numpy as np
import os
from scipy.io.wavfile import read, write
import GammaTones as gt
import math
from tkinter import filedialog
from tkinter import *
from sksound.sounds import Sound


def main():
    """
    Main function
    """
    soundFile = get_file()
    obj_sound_in, obj_sound_out, out_sound, rate = CI_sim(soundFile)
    print('Playing input file: ')
    obj_sound_in.play()
    print()

    output_name = "{}_out{}".format(os.path.splitext(soundFile)[0], os.path.splitext(soundFile)[1])
    write(output_name, rate, out_sound)
    print('Successfully wrote output to subfolder sounds')
    print()

    print('Playing output file: ')
    obj_sound_out.play()


def get_file():
    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    os.chdir(dname)
    root = Tk()
    root.filename = filedialog.askopenfilename(
        initialdir=os.curdir, title="Select file", filetypes=
        (("sound files", ("*.wav", "*.mp3")), ("all files", "*.*")))
    root.destroy()
    return root.filename


def CI_sim(input_file, fmin=200, fmax=5000, nelectrodes=20, tbin=6*10**-3):     # Runs the simulation with default settings
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
    rate .......... rate of the output sound (scalar)
    obj_sound_out . an sksound.sound object of the output sound file

    NOTES
    A. The function crops off the last part of the audio-file that remains
    after integer division of its length by the bin size. This was deemed
    acceptable since it only concerns less than 10 ms of audio in the default
    setting.
    B. The function applies the filter first, and then cuts the file into time
    bins to simulate the output, and not vice versa.

    """

    ### Read data, get specs with sksounds.sound
    obj_sound_in = Sound(input_file)
    data = obj_sound_in.data
    rate = obj_sound_in.rate
    nData = len(data)
    duration = nData / rate

    ### if stereo, make mono (average the channels)
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

    return obj_sound_in, obj_sound_out, out_sound, rate


if __name__ == '__main__':
    main()
