'''
Python module to read, play, and write sound data.
For flexibility, FFMPEG is used for non-WAV files. Note that FFMPEG must be installed externally!
Compatible with Python 2.x and 3.x
The configuration data are saved to "CSS.json".
'''

'''
Date:   07-Mar-2016
Ver:    1.6
Author: thomas haslwanter

Changes: 1.2 replaced Qt with wxpython, because of timer problems
Changes: 1.3 put ui into thLib; allow "cancel" for "writeWav"
Changes: 1.4 Use FFMPEG for conversion from miscellaneous inputs to ".wav", and FFPLAY to play files
             non-Windows platforms
Changes: 1.5 replace ui with a version that only uses Tkinter, make it
             compatible with Python 3.x
Changes: 1.6 make selection of FFMPEG installation interactive;
             write config-file (only required on Windows)
             tested on Windows & Linux
'''

import os
import sys
from scipy.io.wavfile import read, write
import tempfile
from subprocess import call
import ui as ui
import json

if sys.platform=='win32':
    import winsound
    
# "ffmpeg" has to be installed externally, into the location listed below
# You can obtain it for free from http://ffmpeg.org

    config_file = 'CSS.json'
    try:
        # Get the configuration from the default config file
        with open(config_file, 'r') as inFile:
            info = json.load(inFile)
            ffmpeg = info['ffmpeg']
            ffplay = info['ffplay']
            
    except FileNotFoundError:
        # If the file does not exist, get the data interactively
        ffmpeg, path = ui.getfile(FilterSpec='*.exe', DialogTitle='Select "ffmpeg.exe": ', 
                                 DefaultName=r'C:\ffmpeg\bin\ffmpeg.exe')
        ffplay, path = ui.getfile(FilterSpec='*.exe', DialogTitle='Select "ffplay.exe"',
                                  DefaultName= r'C:\ffmpeg\bin\ffplay.exe')
        
        # Set the variables
        ffmpeg = os.path.join(path, ffmpeg)
        ffplay = os.path.join(path, ffplay)
        
        # Save them to the default config file
        info = {'ffmpeg':ffmpeg, 'ffplay': ffplay}
        with open(config_file, 'w') as outFile:
            json.dump(info, outFile)
            print('Config information written to {0}'.format(config_file))
else:
    ffmpeg = 'ffmpeg'
    ffplay = 'ffplay'

def module_exists(module_name):
    if globals().get(module_name, False):
        return True
    return False

class Sound:
    """Class for working with sound in Python.
    It implements the following methods:
    readSound
    play
    setData
    writeWav
    _selectInput
    """
    
    def __init__(self, inFile = None, inData = None, inRate = None):
        # Write the input data to an object, or select and get data from a file.

        if not inData == None:
            self.setData(inData, inRate)
        else: 
            if inFile == None:
                inFile = self._selectInput()
            if os.path.exists(inFile):    
                self.source = inFile
                self.readSound(self.source)
            else:
                print(inFile + ' does NOT exist!')
        
    def readSound(self, inFile):
        ''' Read data from a WAV-file. '''
        
        # Python can natively only read "wav" files. To be flexible, use "ffmpeg" for conversion for other formats
        (root, ext) = os.path.splitext(inFile)
        conversionFlag = False
        if ext[1:].lower() != 'wav':
            outFile = root + '.wav'
            cmd = ffmpeg + ' -i ' + inFile + ' ' + outFile
            call(cmd, shell=True)
            print('Infile converted from ' + ext + ' to ".wav"')
            conversionFlag = True
            
            inFile = outFile

        try:
            self.rate, self.data = read(inFile)
            if len(self.data.shape)==2:     # for stereo, take the first channel
                self.data = self.data[:,0]
            print('data read in!')
        except IOError:
            print('Could not read ' + inFile)
    
    def play(self):
        ''' Play data. '''
        try:
            if self.source == None:
                tmpFile = tempfile.TemporaryFile(suffix='.wav')
                self.writeWav(tmpFile)
                if sys.platform=='win32':
                    winsound.PlaySound(tmpFile, winsound.SND_FILENAME)
                else:
                    cmd = [ffplay, '-autoexit', '-nodisp', '-i', tmpFile]
                    call(cmd)
            elif os.path.exists(self.source):
                print('Playing ' + self.source)
                if sys.platform=='win32':
                    winsound.PlaySound(str(self.source), winsound.SND_FILENAME)
                else:
                    cmd = [ffplay, '-autoexit', '-nodisp', '-i', self.source]
                    call(cmd)
        except SystemError:
            print('If you don''t have FFMPEG available, you can e.g. use installed audio-files. E.g.:')
            print('import subprocess')
            print('subprocess.call([r"C:\Program Files (x86)\VideoLAN\VLC\vlc.exe", r"C:\Music\14_Streets_of_Philadelphia.mp3"])')
            
    def setData(self, data, rate):
        ''' Set the properties of a Sound-object. '''

        self.data = data
        self.rate = rate
        self.source = None

    def writeWav(self, fullOutFile = None):            
        '''Write a data to a WAV-file. '''

        if fullOutFile == None:
            (outFile , outDir) = ui.savefile('Write sound to ...', '*.wav')            
            if outFile == 0:
                print('Output discarded.')
                return 0
            else:
                fullOutFile = os.path.join(outDir, outFile)
        else:
            outDir = os.path.abspath(os.path.dirname(fullOutFile))
            outFile = os.path.basename(fullOutFile)
        #        fullOutFile = tkFileDialog.asksaveasfilename()

        write(str(fullOutFile), int(self.rate), self.data)
        print('Sounddata written to ' + outFile + ', with a sample rate of ' + str(self.rate))
        print('OutDir: ' + outDir)

        return fullOutFile

    def _selectInput(self):
        '''GUI for the selection of an in-file. '''

        (inFile, inPath) = ui.getfile('*.wav', 'Select WAV-input: ')
        fullInFile = os.path.join(inPath, inFile)
        print('Selection: ' + fullInFile)
        return fullInFile


def main():
    # Main function, to test the module
    inSound = Sound()
    inSound.play()
    inSound.writeWav()
    
if __name__ == '__main__':
    main()
    
