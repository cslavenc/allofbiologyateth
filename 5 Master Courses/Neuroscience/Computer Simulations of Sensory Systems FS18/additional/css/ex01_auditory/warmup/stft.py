'''
Short Time Fourier Transform
Shows the effects of windows on short time Fourier transformations.
'''
from __future__ import division     # for Python 2.x compatability
    
'''
author: Thomas Haslwanter
date:   Nov-2014
Ver:    1.3
'''

from numpy import fft, real, arange, pi, cos, hamming
import matplotlib.pyplot as plt

def powerSpect(data, sampleRate):
    '''Powerspectrum, calculated via Fourier Transfrom'''
    
    nData = len(data)
    fftData = fft.fft(data)
    
    Pxx = real(fftData * fftData.conj()) / nData
    freq = arange(nData)*sampleRate / nData
    
    return (Pxx, freq)
    
def showData(samplingRate, x, titleText):
    '''Show data in time domain, and corresponding powerspectrum'''
    
    t = arange(len(x)) / samplingRate
        
    fig, axs = plt.subplots(2,1)
    axs[0].plot(t,x)
    axs[0].set_xlabel('Time [s]')
    axs[0].set_ylabel('Signal')
    axs[0].set_title(titleText)
    
    # Calculate the powerspectrum
    (Pxx, freq) = powerSpect(x, samplingRate)
    
    axs[1].plot(freq, Pxx)
    axs[1].set_xlim(1, 5000)
    axs[1].set_xlabel('Frequency [Hz]')
    axs[1].set_ylabel('Power')
    
    plt.show()   # if run interactively, from ipython
    plt.close()

if __name__ == '__main__':
    ''' Show the effect of clipping and windowing on a cosine wave. '''
    
    # Set the parameters
    sampleRate = 100000
    dt = 1./sampleRate
    f = 1000
    tMax = 0.01
    
    # Calculate the data
    t = arange(0, tMax, dt)
    x = cos(2*pi*f*t)
    showData(sampleRate, x, 'Cosine wave')
    
    # Clip the data
    y = x
    y[1:199] = 0
    y[400:1001] = 0
    showData(sampleRate, y, 'Clipped Signal')
    
    # Window the clipped data
    z = y;
    window = hamming(201)
    z[199:400] = z[199:400]*window
    showData(sampleRate, z, 'Clipped & Windowed Signal')
    
