# -*- coding: utf-8 -*-
"""
Created on Sat Mar 24 09:43:58 2018

@author: made_

IDEAS:
    PCA
    Feature extraction
    Remove certain frequencies: make histogram/any plot to see if it made sense
    to remove certain frequencies (cutoff)
    Nyquist frequency?
    Increase efficiency for computation: fft(data) should be a multiple of 2**N
    
"""

# Preprocessing step: Try to use MVS tools to better process data.
# Perhaps PCA methods might help.

from numpy import *
from matplotlib.pyplot import *
from sksound.sounds import Sound
from numpy.fft import *
import os, ffmpeg
from tkinter import filedialog
from tkinter import *

def get_file():
    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    os.chdir(dname)
    root = Tk()
    root.filename = filedialog.askopenfilename(
        initialdir=os.curdir, title="Select file", filetypes=
        (("sound files", ("*.wav", "*.mp3")), ("all files", "*.*")))
    return root.filename

def scale_data(data):
    m = max(abs(data))
    scaled_data = data / m
    scaled_data *= 32767 # if dtype=int16 of data (2**15 - 1 = 32767)
    scaled_data = scaled_data.astype(int16)
    return scaled_data
    

# gather data - here I used tiger.wav
inFile = get_file()
inSound = Sound(inFile)
data = inSound.data
rate = inSound.rate
nData = len(data)
duration = nData / rate

#%%
inSound.play()

#%%
# Stereo to mono if applicable
if len(data.shape) == 2:
    in_sound = 0.5 * (data[:, 0] + data[:, 1])
else: # this step really necessary?
    in_sound = 1 * data


# look at the data: time vs amplitude
# => maybe remove very low amplitudes for better processing later on?
time = linspace(0, duration, nData)
fourier = fft(in_sound)
amplitude = abs(fourier)
intensity = amplitude**2
freq = fftfreq(nData, d=0.005) # d = 5ms


show()
plot(time, log(amplitude))
title('time vs amplitude')
xlabel('time in sec')
ylabel('amplitude')

show()
plot(time, log(intensity))
title('time vs intensity')


show()
plot(time, freq)
title('time vs frequency')
close()

show()
plot(freq, amplitude)
close()


#%% Check out scaled data
scdata = scale_data(in_sound)
scfourier = fft(scdata)
scfreq = fftfreq(nData, d=0.005)
scamp = abs(scfourier)
scint = scamp**2

show()
plot(time, scamp)
title('time vs scaled amplitude')
xlabel('time in sec')
ylabel('amplitude')

show()
plot(time, scint)
title('time vs scaled intensity')

# maybe remove all zeros at the beginning and end?
# then work with log-data? (better basilar membrane simulation)
# Remove noise



# perform PCA: explained variance should be 80% for starters


# hear the PCA'ed sound in normal hearing and CI hearing

