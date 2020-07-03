"""
Sample program showing a simple way to sum up sine waves with different amplitudes.
"""

"""
Ver 1.1
ThH, June 2012
"""

from numpy import matrix, shape, pi, sin, array, r_

def toRow(inData):
    data= matrix(inData) 
    if shape(data)[0] > shape(data)[1]:
        data = data.T
    return data

def toCol(inData):
    data= matrix(inData) 
    if shape(data)[0] < shape(data)[1]:
        data = data.T
    return data

def sumSines(Amplitudes, Frequencies, Time):
    '''Turn the input into the right format.'''

    Amplitudes = toRow(Amplitudes) 
    Frequencies = toCol(Frequencies)
    Time = toRow(Time)

    summed = Amplitudes * sin(2*pi*Frequencies*Time)
    return summed

def main():
    amps = array([3., 1.])
    freq = matrix([800., 3000.])
    time = r_[0:1:0.0001]
    
    out = sumSines(amps, freq, time)
    print('Done')
    
if __name__ == '__main__':
    main()    
