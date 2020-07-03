-------------------------------------------------------------------------------
Computer Simulations of Sensory Systems: Exercise 1 (Auditory System)
-------------------------------------------------------------------------------

Run the file by pressing the run button after opening it.

Alternatively, you can also open the cmd in the file folder and type:
    python ex1_auditory.py

The script makes use of a number of libriaries:
    ffmpeg           - Conversion of non-WAV files to WAV files
    scipy.io.wavfile - Mainly used to write float array to a WAV file
    sksound.sounds   - For handling sound files and for gathering the relevant parameters
    tkinter          - Choosing files
    GammaTones       - Used for creating the gammatone filterbank