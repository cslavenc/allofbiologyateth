# -*- coding: utf-8 -*-
"""
Created on Sat Mar  3 09:53:00 2018

@author: made_
"""

# CSSS: Mock exercise
import numpy as np
import scipy, os, ffmpeg
import matplotlib.pyplot as plt
from sksound.sounds import Sound
from numpy.fft import *

# Generate sound
rate = 22050
dt = 1./rate
freq = 440
t = np.arange(0,0.5,dt)
x = np.sin(2*np.pi*freq * t)
amp = 2**13
sounddata = np.int16(x*amp)
mySound3 = Sound(inData=sounddata, inRate=rate)

#%% Import .wav file
dataDir = 'SoundData'
inFile = 'a1.wav'
    
fullFile = os.path.join(dataDir, inFile)

sample1 = Sound(fullFile)
sample1.read_sound(inFile=fullFile)
sample1.play()
#rate1, data1 = wav.read('a1.wav')

#%% Import .mp3 file
inFile2 = 'Mond_short.mp3'
fullFile2 = os.path.join(dataDir, inFile2)
sample2 = Sound(fullFile2)
sample2.read_sound(inFile=fullFile2)
info = sample2.get_info()
sample2.play()
(source, rate, numChannels, totalSamples, duration, bitsPerSample) = sample2.get_info()

#%% make .wav into floats
from scipy.io.wavfile import read
a = read('SoundData\peas.wav')
b = np.array(a[1],dtype=float)

#%% Power spectrum calculation
def powspec(data,sRate):
    nData = len(data)
    
    coef = fft(data)
    powerspec = coef**2 / nData
    freq = np.arange(nData) * sRate / nData
    return powerspec, freq

def showData(samplingRate, x, titleText):
    '''Show data in time domain, and corresponding powerspectrum'''
    
    t = np.arange(len(x)) / samplingRate
        
    fig, axs = plt.subplots(2,1)
    axs[0].plot(t,x)
    axs[0].set_xlabel('Time [s]')
    axs[0].set_ylabel('Signal')
    axs[0].set_title(titleText)
    
    # Calculate the powerspectrum
    Pxx, freq = powspec(x, samplingRate)
    
    axs[1].plot(freq, Pxx)
    axs[1].set_xlim(1, 5000)
    axs[1].set_xlabel('Frequency [Hz]')
    axs[1].set_ylabel('Power')
    
    plt.show()   # if run interactively, from ipython
    plt.close()

# Set the parameters
sampleRate = 100000
dt = 1./sampleRate
f = 1000
tMax = 0.01
    
# Calculate the data
t = np.arange(0, tMax, dt)
x = np.cos(2*np.pi*f*t)
showData(sampleRate, x, 'Cosine wave')
    
# Clip the data
y = x
y[1:199] = 0
y[400:1001] = 0
showData(sampleRate, y, 'Clipped Signal')
    
# Window the clipped data
z = y;
window = np.hamming(201)
z[199:400] = z[199:400]*window
showData(sampleRate, z, 'Clipped & Windowed Signal')
