'''Example of working with sound, independent from the operating system.
Note that this requires the installation of "pygame"
(http://www.pygame.org)

'''

'''
Author:  Thomas Haslwanter
Version: 1.0
Date:    March-2013
'''

from pygame import mixer, sndarray
from scipy.signal import chirp
import numpy as np

def main():
    # Generate the data, here a chirp from 300 to 1500 Hz, in 2 sec
    sampleRate = 22050
    t = np.arange(2*sampleRate)/float(sampleRate)
    mysnd = chirp(t, 300, 2, 1500)
    
    # Convert the signal to uint8. Note that this is important! If you
    # stick to float, you have to use another encoding
    sndSignal = np.uint8((mysnd+1)*100)
    
    # Initialize the mixer: 8-bit encoding, mono, and buffer length 4096
    # To hear the data correctly, it is important that these values are
    # properly set!
    mixer.init(sampleRate, 8, 1, 4096)
    
    # Convert it into a pygame-sound, and play it
    playsnd = sndarray.make_sound(sndSignal)
    playsnd.play()
    
    # Without the "get_busy()", I don't hear anything (not sure why)
    while mixer.get_busy():
        pass
    
    # Cleanup
    mixer.quit()

if __name__ == '__main__':
    main()