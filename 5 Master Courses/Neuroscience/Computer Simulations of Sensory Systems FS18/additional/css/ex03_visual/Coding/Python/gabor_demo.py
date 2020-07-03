'''
Applies a Gabor-filter to an image, and lets you interactively adjust
the different parameters of a Gabor function. The results are shown in
real-time on the screen.
This is also a good example of the power of Opencv2.
Based on a function originally written by Eiichiro Momma.
'''

'''
Thomas Haslwanter
Ver 2.1
July 2012
'''

import numpy as np
# for easier readability of the code, I import some functions directly
from numpy import sin, cos, exp, pi
import os.path
import cv2
import thLib.ui as ui

def makeKernel():
    '''Definition of the Gabor function.'''

    # Get the parameters
    sigma  = cv2.getTrackbarPos('Sigma*100', 'Filtered')/100.   # Value in percent
    Lambda = cv2.getTrackbarPos('Lambda*100','Filtered')/100.
    theta  = cv2.getTrackbarPos('Theta', 'Filtered') * pi/180.
    psi    = cv2.getTrackbarPos('Psi',   'Filtered') * pi/180.
    kernel_size  = cv2.getTrackbarPos('KernelSize', 'Filtered')
    
    # make a grid
    xs=np.linspace(-1., 1., kernel_size)
    ys=np.linspace(-1., 1., kernel_size)
    x,y = np.meshgrid(xs,ys)

    x_theta =  x*cos(theta) + y*sin(theta)
    y_theta = -x*sin(theta) + y*cos(theta)

    Gabor_values = np.array(exp(-0.5*(x_theta**2+y_theta**2)/sigma**2)*cos(2.*pi*x_theta/Lambda + psi),dtype=np.float32)
    return Gabor_values

def update():
    ''' Apply the filters, and show the images '''

    # Calculate the Gabor-filter
    kernel = makeKernel()
    kernel_image = kernel/2.+0.5   # Adjust the kernel image, for better visibility

    # Filter the image
    dest = cv2.filter2D(src, cv2.CV_32F,kernel)

    # Show the filtered data
    cv2.imshow('Filtered',  dest)
    cv2.imshow('Magnitude', np.abs(dest))
    
    kernel_size  = cv2.getTrackbarPos('KernelSize', 'Filtered')
    cv2.imshow('Kernel',    cv2.resize(kernel_image, (kernel_size*20,kernel_size*20)))
    
# -----------------------------------------------------------------
def main(inFile = None):
    ''' Main module '''
    
    # starting parameters
    sigma = 20
    Lambda = 50
    theta = 0 
    psi = 90     

    kernel_size = 21
    if not kernel_size%2:   # Checke if kernel size is odd
        kernel_size += 1
    
    # Callbacks for the sliders: just update the image    
    def cb_sigma(pos):
        # to avoid division by zero
        if pos==0:
            pos = 1;
            cv2.setTrackbarPos('Sigma*100', 'Filtered', np.int(pos))
            
        update()    
    def cb_lambda(pos):
        # to avoid division by zero
        if pos==0:
            pos = 1;
            cv2.setTrackbarPos('Lambda*100', 'Filtered', np.int(pos))
            
        update()    
    def cb_theta(pos):
        update()    
    def cb_psi(pos):
        update()
        
    def cb_kernel(pos):
        kernel_size = 2 * np.round(pos/2.) + 1   # Make sure that it is odd
        cv2.setTrackbarPos('KernelSize', 'Filtered', np.int(kernel_size))
        update()
    
    # Set up the Windows, including the sliders
    cv2.namedWindow('Filtered',1)
    cv2.createTrackbar('Sigma*100', 'Filtered', sigma,  100, cb_sigma)
    cv2.createTrackbar('Lambda*100','Filtered', Lambda, 100, cb_lambda)
    cv2.createTrackbar('Theta',     'Filtered', theta,  180, cb_theta)
    cv2.createTrackbar('Psi',       'Filtered', psi,    360, cb_psi)
    cv2.createTrackbar('KernelSize','Filtered', kernel_size, 40, cb_kernel)
    
    # Apply the gabor filter, and show the images
    update()

    cv2.waitKey(0)
    cv2.destroyAllWindows()
    
if __name__ == '__main__':
    '''
    The original image data must be available to the
    function "update", so it is read in here.
    '''
        
    # Read in and show the original image
    (inFile, inPath) = ui.getfile(DialogTitle = 'Select input image: ',
                                  DefaultName = "data\cat.jpg")
    if inFile > 0:            # Exit of no file has been chosen
        fileName = os.path.join(inPath, inFile)
            
        src = cv2.imread(fileName,cv2.IMREAD_GRAYSCALE)/255.
        cv2.imshow('Src',src)
        cv2.waitKey(0)
            
        main()
