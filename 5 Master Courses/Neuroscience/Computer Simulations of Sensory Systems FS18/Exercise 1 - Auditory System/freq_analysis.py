# -*- coding: utf-8 -*-
"""
Created on Sun Mar 25 10:55:04 2018

@author: made_
"""

# Analysis of frequencies

import numpy as np
import os, ffmpeg, math
import tkinter as tk
from sksound.sounds import Sound
from numpy.fft import *
from scipy.io.wavfile import read, write
from matplotlib.pyplot import *
# import scipy.io.wavfile as wv
import GammaTones as gt

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
            count += 1
            ind[i] = i # save the index where the condition was fulfilled

    return count, ind

# choose a sound file
filePath = os.path.abspath(__file__)
pathDir = os.path.dirname(filePath)
os.chdir(pathDir) # change directory to where this file is opened
root = tk.Tk()
root.fname = tk.filedialog.askopenfilename(
        initialdir=os.curdir, title="Select file", filetypes=
        (("sound files", ("*.wav", "*.mp3")), ("all files", "*.*")))
root.destroy()
soundname = os.path.basename(root.fname)
splitname = os.path.splitext(root.fname)
temp = '_out'
outputname = splitname[0] + temp + splitname[1]
print(outputname)

#%%
soundIn = Sound(root.fname)
data = soundIn.data
fs = soundIn.rate
nData = len(data)
duration = nData / fs

if len(data.shape) == 2:
    data = 0.5 * (data[:, 0] + data[:, 1])
else:
    data = 1 * data

count, ind = freq_counter(data)
count2, ind2 = freq_counter(data)

time = np.linspace(0,duration,nData)
plot(time, data)

#%% log the data - this only makes the intensity smaller, hence you can not hear it well
dat = data
for i in range(len(dat)):
    if dat[i] != 0:
        dat[i] = np.log(dat[i])
        
plot(time, dat)

#%% apply gammatonefilter to dat






