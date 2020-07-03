# Standard packages
import os
# skssound only 1 module: sounds
from sksound.sounds import Sound
import numpy as np
import matplotlib.pyplot as mpl

# Special imports
from scipy.io.wavfile import read
import GammaTones as gt
from tkinter import filedialog
from tkinter import *

def get_file():
    root = Tk()
    current = os.path.abspath(os.curdir)
    root.filename =  filedialog.askopenfilename(initialdir = current,title = "Select file",filetypes = (("sound files", ("*.wav", "*.mp3")),("all files","*.*")))
    print(root.filename)

def main():

    audioDir = '/home/padraigh/Dokumente/Uni/NSC/SensorySystems/ex01_auditory/samples/data/sounds'
    wav_file = os.path.join(audioDir, 'a1.wav')
    mp3_file = os.path.join(audioDir, 'Mond_short.mp3')
    
    wav_sound = Sound(wav_file)
    # wav_sound.summary()
    #wav_sound.play()
    x = wav_sound.data
    (source, rate, numChannels, totalSamples, duration, bitsPerSample) = wav_sound.get_info()
    
    # source (name of inFile)
    # rate (sampleRate)
    # numChannels (number of channels)
    # totalSamples (number of total samples)
    # duration (duration [sec])
    # bitsPerSample (bits per sample)
    
    (forward,feedback,fc,ERB,B) = gt.GammaToneMake(rate, 20, 200, 5000, 'moore')
    
    y = gt.GammaToneApply(x,forward,feedback)
    
    mpl.figure(1)
    ax = mpl.subplot(121)
    # Show all frequencies, and label a selection of centre frequencies
    gt.BMMplot(y, fc, rate, [0, 4, 8, 12, 16, 19])
    mpl.figure(1)
    ax = mpl.subplot(122)
    # For better visibility, plot selected center-frequencies in a second plot.
    # Dont plot the centre frequencies on the ordinate.
    gt.BMMplot(y[[0, 4, 8, 12, 16, 16],:], fc, rate, '')
    mpl.show()
    mpl.close()

# ----------------------------------------------------------------------------    

if __name__ == '__main__':
    get_file()