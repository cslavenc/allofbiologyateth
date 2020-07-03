'''
Import linear acceleration and angular velocity from data recordes with an
XSens system.
'''
'''
Author: Thomas Haslwanter
Date:   March-2014
Ver:    1.0
'''

import numpy as np
import pandas as pd 

def getXSensData(inFile, paramList):
    '''Read in Rate and stored 3D parameters from XSens IMUs
    
    Parameters:
    -----------
    inFile : string
        Path and name of input file
    paramList: list of strings
        Starting names of stored parameters
        
    Returns:
    --------
    List, containing
    rate : float
        Sampling rate
    [List of x/y/z Parameter Values]
    
    Examples:
    ---------
    >>> data = getXSensData(fullInFile, ['Acc', 'Gyr'])
    >>> rate = data[0]
    >>> accValues = data[1]
    >>> Omega = data[2]
    
    '''
    
    # Get the sampling rate from the second line in the file
    try:
        fh = open(inFile)
        fh.readline()
        line = fh.readline()
        rate = np.float(line.split(':')[1].split('H')[0])
        fh.close()
        returnValues = [rate]
        
    except FileNotFoundError:
        print('{0} does not exist!'.format(inFile))
        return -1
    
    # Read the data
    data = pd.read_csv(inFile,
                       sep='\t',
                       skiprows=4, 
                       index_col=False)
    
    # Extract the columns that you want, by name
    for param in paramList:
        Expression = param + '*'
        returnValues.append(data.filter(regex=Expression).values)
        
    return returnValues

if __name__ == '__main__':
    inDir = r'C:\Users\p20529\Coding\Python\th\CSS\Vestibular_Implants\data'    
    inFile = 'Walking_02_woQuat.txt'    
    
    import os
    fullInFile = os.path.join(inDir, inFile)    
    data = getXSensData(fullInFile, ['Counter', 'Acc', 'Gyr'])    
    print(data[0])    
    print(data[1][:5])
    print(data[2][:5])
    print(data[3][:5])
    input('Done')
