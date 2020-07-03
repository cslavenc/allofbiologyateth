# -*- coding: utf-8 -*-
"""
Created on Wed Mar 14 14:49:53 2018

@author: made_

OPTIMIZATION:
    def libs with abbreviations like np, plt etc.
    define wavfile module uniquely, so it looks nicer.
    dont forget to delete variables that you dont need anymore, since they can be quite huge:
        del var # to clear space
    Will need to work with log data, as this simulates the basilar membrane better.
    Check if mono or stereo: remove 2nd row vec if stereo.
    Since data is in int16 from sound, maybe normalize to [-1,1]? or rescale?:
    m = max(nData); nData_ = nData/ m; nData_ = nData_ * 32767 (or something like that)
    Maybe try splitting first and then do the gammatones machinery on the subarrays?
    Increase efficiency for computation: fft(data) should be a multiple of 2**N
"""

# CSSS: Learning how to simulate .wav files in the cochlear.
import scipy, os, ffmpeg
from numpy import *
from matplotlib.pyplot import *
from numpy.fft import *
from sksound.sounds import Sound
from scipy.io.wavfile import read, write

# find_sound() # will need to later adapt var like inFile, since this function
# should feed these var.
# Then, check if mono or stereo and discard 2nd row if stereo.

# Set directory and import file
dataDir = 'SoundData'
inFile = 'tiger.wav' # is only 2sec = 2000ms long
filePath = os.path.abspath(os.path.join(dataDir, inFile))

# Get parameters of inFile
# int16	Integer (-32768 to 32767) - maybe normalize this?
sample1 = Sound(filePath)
sample1.read_sound(filePath)
info_sample1 = sample1.get_info()
source, rate, numChannels, totalSamples, duration, bitsPerSample = info_sample1
rate = rate * 1000 # rate is converted in ms
sample1.play()

# Transform sound into floats that can be used for further analysis
a = read(filePath)
data1 = array(a[1],dtype=float)
N = len(data1) # check: N is the same as totalSamples. N is redundant.
if len(data1.shape) == 2:
    data1 = 0.5 * (data1[:, 0] + data1[:, 1])
else:
    data1 = 1 * data1


#%%Plot data to have a look at the short sound
# There seems to be a problem, probably should change rate1 to rate again
def powspec(data,sRate):
    nData = len(data)
    
    coef = fft(data)
    powerspec = coef**2 / nData
    freq = arange(nData) * sRate / nData
    return powerspec, freq

def showData(samplingRate, x, titleText):
    '''Show data in time domain, and corresponding powerspectrum'''
    
    t = arange(len(x)) / samplingRate
        
    fig, axs = subplots(2,1)
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
    
    show()   # if run interactively, from ipython
    close()

showData(rate, data1, 'input sound')

# Start simple data modification and listen to the changes
# Clip data
y = data1
y[0:6500] = 0
#y[-5000:-1] = 0
showData(rate, y, 'removed first few data points')
rate1 = rate
#write('testt.wav', data=y, rate=11025000) # 11025000 = rate1

#%% Test the new wave file
dataDir = 'SoundData'
inFile2 = 'testt.wav'
filePath2 = os.path.abspath(os.path.join(dataDir, inFile2))
test1 = Sound(filePath2)
test1.read_sound(filePath2)
test1.play()

# Apply hamming() on y
z = y
window = hamming(15571)
z[6500:-5000] = z[6500:-5000]*window
showData(rate1, z, 'hamming window on data=y')

# Apply hamming() on data1
w = data1
w[6500:-5000] = w[6500:-5000]*window
showData(rate1, w, 'hamming window on data=data1')

write('testt2.wav', data=z, rate=11025000) # 11025000 = rate1
inFile3 = 'testt2.wav'
filePath3 = os.path.abspath(os.path.join(dataDir, inFile3))
test2 = Sound(filePath3)
test2.read_sound(filePath3)
test2.play() # The sound is extremely short...


#%% Try a first simulation of the cochlear
# Note: a1.wav is a very short sound and complexity is not overwhelming.
# In a further step, try the same on more complex sounds.
# nData or totalSamples is the same
# try first segmenting and then applying the gammatone filter
from GammaTones import GammaToneMake, GammaToneApply, BMMplot

fs = 1000 # this might be needed to adapt to 44100
Fmin = 200 
Fmax = 5000 
numElectrodes = 6
StepSize = 5 # in ms

forward,feedback,cf,ERB,B = GammaToneMake(fs,numElectrodes,Fmin,Fmax,method='moore') # fs,numChannels,loFreq,hiFreq,method
g = GammaToneApply(w,forward,feedback) # g.shape = (numElectrodes,27071)
showData(fs, g[0,:], 'GammaTone applied')

# make slices of the waveform
segTime = 10**-2                                                                 # duration of a segment
segSize = int(floor(segTime * fs))                                               # the segment size in the sample data
nSegments = int(ceil(totalSamples / segSize))                                           # number of all segments created
splitSites = arange(nSegments) * segSize                                         # location of the splitting sites for the original sample
splitFiltered = split(g, splitSites, axis=1)

# Computes intensity for every electrode and bin. Also computes output.
t = linspace(0, duration, totalSamples)
output = zeros_like(w, dtype=float)
for i in range(nElectrodes):
    for j in range(nSegments):
        temp = splitFiltered[j][i,:]
        I = sqrt(sum(square(temp)))    # check if this formula is correct, should be since orignally it was fft'ed
        ind1 = segSize * j
        ind2 = segSize * (j + 1)
        output[ind1:ind2] = output[ind1:ind2] + I * sin(2 * pi * cf[i] * t[ind1:ind2])
        
outFile = Sound(inData=output, inRate=fs)



#%% Testing ground
#dataDir = 'SoundData'
#inGamma = 'test_gammatone_2.wav'
#pathGamma = os.path.abspath(os.path.join(dataDir, inGamma))
#gtest1 = Sound(pathGamma)
#gtest1.read_sound(pathGamma)
#gtest1.play() # sounds like some spooky ass shit

#%% Main function to use in the final submission file
def main():
    inFile = select_file()
    soundIn, soundOut, rate = cochlea_sim() # maybe also return output from above?
    print('Playing input file: ')
    soundIn.play()
    
    #nameOutput = pass # find a good way to write outName
    write(nameOutput, rate, soundOut)
    #print('Successfully wrote output to subfolder sounds')
    print('Playing output file: ')
    soundOut.play()

#%% trying to log the data correctly
import scipy, os, ffmpeg, appdirs, easygui
from numpy import *
from matplotlib.pyplot import *
from numpy.fft import *
from sksound.sounds import Sound

def get_file():
    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    os.chdir(dname)
    root = Tk()
    root.filename = filedialog.askopenfilename(
        initialdir=os.curdir, title="Select file", filetypes=
        (("sound files", ("*.wav", "*.mp3")), ("all files", "*.*")))
    return root.filename

soundfile = get_file()
obj_sound_in = Sound(soundfile)
data = obj_sound_in.data
rate = obj_sound_in.rate
nData = len(data)
duration = nData / rate

#%% stereo to mono
if len(data.shape) == 2:
    in_sound = 0.5 * (data[:, 0] + data[:, 1])
else:
    in_sound = 1 * data


