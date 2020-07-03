'''
Demo of how to apply radius-dependent filter to an image.
A couple of Python-specific coding problems took quite some time to figure out:

* a division of two integers always yields an integer
* an overflow of a uint8 makes the value start at 0 again, it does not saturate
* if you want "sum" from numpy, you have to explicitly state so - otherwise the
    "sum" from the standard library is used.

'''

'''
Author: Thomas Haslwanter
Date:   May 2013
Ver:    1.0

'''

import matplotlib.pylab as mpl
import numpy as np
import cv2
import math
import os
import matplotlib.image as mimg
import skinematics.misc as skin

class MyImages:
    ''' Reading, writing, and filtering of images '''
    
    def __init__(self, inFile = None):
        ''' get the image-name, -data and -size '''
        
        if inFile == None:
            (inFile, inPath) = skin.get_file(DialogTitle='Select input image: ')
            self.fileName = os.path.join(inPath, inFile)
        else:
            self.fileName = inFile
        rawData = mpl.imread(self.fileName)
        if len(np.shape(rawData))==3: # convert to grayscale
            rawData = rawData.dot([0.2125, 0.7154, 0.0721]).astype(rawData.dtype)

        self.size = np.shape(rawData)
        print (self.size)
        
        if len(np.shape(rawData))==3: # flip the image upside down, assuming it is an RGB-image
            flippedIndex = range(self.size[0])
            flippedIndex.sort(reverse=True)
            self.data = rawData[flippedIndex,:]
        else:
            self.data = rawData
        
        # show the image, and get the focus point for the subsequent calculations
        mpl.imshow(self.data, 'gray')        
        selectedFocus = mpl.ginput(1)
        mpl.close()
        self.focus = np.rint(selectedFocus)[0].tolist() # ginput returns a list with one selection element, take the first element in this list
        self.focus.reverse()    # for working with the data x/y's
        print (self.focus)
        
    def applyFilters(self, Zones, Filters):
        ''' Applying the filters to the different image zones '''
        
        imOut = np.zeros(np.shape(self.data))
        filteredImgs = list()
        
        # For each zone, take the corresponding areas from the corresponding filtered data   
        for ii in range(len(Filters)):        
            ''' There are different ways to apply 2D filters: you can use
            scipy, openCV, or other options. I have found that openCV is
            pretty fast.'''
            # filtered = scipy.ndimage.convolve(self.data.astype(float), Filters[ii])
            filtered = cv2.filter2D(self.data, cv2.CV_32F, Filters[ii])            

            # To improve visibility, here I normalize the filtered images
            # filtered = np.clip(filtered,0,2**8-1)
            filtered = filtered - np.min(filtered)
            filtered = np.uint8(filtered*(255./np.max(filtered)))
            filteredImgs.append(filtered)
            imOut[Zones==ii] = filtered[Zones==ii]

        return imOut, filteredImgs
        
    def save(self, outData):
        ''' Save the resulting image '''
        
        inStem = self.fileName.find('.')
        outFile = self.fileName[:inStem] + '_out.png'
        try:
            mimg.imsave(outFile, outData, cmap='gray', format='png')
            print ('Result saved to %s.' % outFile)
        except IOError:
            print ('Could not save %s.' % outFile)

def makeZones(myImg):
    ''' Break up the image in "numZones" different circular regions about
    the chosen focus '''

    numZones = 10
    imSize = np.array(myImg.size)
    corners = np.array([[1., 1.], [1., imSize[1]], [imSize[0], 1.], imSize[0:2]])
    radii = np.sqrt(np.sum((corners - myImg.focus)**2,1))
    rMax = max(radii)
    
    X,Y = np.meshgrid(np.arange(myImg.size[0])+1, np.arange(myImg.size[1])+1)
    RadFromFocus = np.sqrt((X.transpose()-myImg.focus[0])**2 + (Y.transpose()-myImg.focus[1])**2)
    
    # Assign each value to a Zone, based on its distance from the "focus"
    Zones = np.floor(RadFromFocus/rMax * (numZones)).astype(np.int16)
    Zones[Zones == numZones] = numZones-1 # eliminate the few maximum radii
    
    # Generate numZones filters, and save them to the list "Filters"
    Filters = list()
    
    for ii in range(numZones):                   
        zoneRad = rMax/numZones * (ii+0.5)  # eccentricity = average radius in a zone, in pixel
        
        filterLength = 2 * np.rint(zoneRad/8)     # must be even
        filterLength = min(81, filterLength)    # for Reasons of memory efficiency, limit filter size

        print ('filterLength %d: %g' % (ii, filterLength))
        curFilter = np.ones((int(filterLength), int(filterLength)))/filterLength**2
        Filters.append(curFilter)
    
    return (Zones, Filters)
          
def main(inFile = None):
    ''' Simulation of a retinal implant. The image can be selected, and the
    fixation point is chosen interactively by the user. '''

    # Select the image, and perform the calculations    
    myImg = MyImages(inFile)
    Zones, Filters = makeZones(myImg)
    filteredImg, filtImgs = myImg.applyFilters(Zones, Filters)
    
    # Show the results
    mpl.imshow(filteredImg, 'gray')
    mpl.show()
    myImg.save(filteredImg)
    print ('Done!')
    
    return myImg.data, filteredImg, filtImgs, Filters

def gabor_fn(sigma, theta, g_lambda, psi, gamma):
    # Calculates the Gabor function with the given parameters
        
    sigma_x = sigma
    sigma_y = sigma/gamma
    
    # Boundingbox:
    nstds = 3
    xmax = max( abs(nstds*sigma_x * np.cos(theta)), abs(nstds*sigma_y * np.sin(theta)) )
    ymax = max( abs(nstds*sigma_x * np.sin(theta)), abs(nstds*sigma_y * np.cos(theta)) )
    
    xmax = np.ceil(max(1,xmax))
    ymax = np.ceil(max(1,ymax))
    
    xmin = -xmax
    ymin = -ymax
    
    numPts = 201    
    (x,y) = np.meshgrid(np.linspace(xmin, xmax, numPts), np.linspace(ymin, ymax, numPts) ) 
    
    # Rotation
    x_theta =  x * np.cos(theta) + y * np.sin(theta)
    y_theta = -x * np.sin(theta) + y * np.cos(theta)
    gb = np.exp( -0.5* (x_theta**2/sigma_x**2 + y_theta**2/sigma_y**2) ) * \
         np.cos( 2*np.pi/g_lambda*x_theta + psi )
    
    return gb

if __name__ == '__main__':
    (imgIn, imgOut, filtered, Filters) = main()    
    # Main function: calculate Gabor function for default parameters and show it
    gaborValues = gabor_fn(1,1,4,2,1)
    mpl.imshow(gaborValues)
    mpl.colorbar()
    mpl.show()
    mpl.close()