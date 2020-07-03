'''Simple example of calculation of Powerspectrum.

ThH
March 2013
Ver 1.0

'''

import numpy as np
import matplotlib.pyplot as plt

def pSpect(data, rate):
    '''Calculation of power spectrum and corresponding frequencies'''
    nData = len(data)
    fftData = np.fft.fft(data)
    PowerSpect = fftData * fftData.conj() / nData
    freq = np.arange(nData) * float(rate) / nData
    return (np.real(PowerSpect), freq)

if __name__ == '__main__':
    sampleRate = 1000
    freq = [50, 120]
    amp = [1, 0.4]
    
    t = np.arange(0,10,1./sampleRate)
    signal =  amp[0]*np.sin(2*np.pi*freq[0]*t) + amp[1]*np.sin(2*np.pi*freq[1]*t) + np.random.randn(len(t))
    
    # Calculate the powerspectrum
    Pxx, freq = pSpect(signal, sampleRate)
    
    # Show the powerspectrum
    plt.plot(freq, Pxx)
    plt.show()

