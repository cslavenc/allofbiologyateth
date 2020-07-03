'''
Miscellaneous user interface utilities for

    - selecting files or directories.
      If nothing or a non-existing file/direcoty is selected, the return is "0". 
      Otherwise the file/directory is returned.
    - Selection from a list.
    - waitbar
    - listbox

'''

'''
ThH, Nov 2015
Ver 5.5
'''

import matplotlib.pyplot as plt
import os
import sys

if sys.version_info.major == 3:
    # Python 3.x
    import tkinter as tk
    import tkinter.filedialog as tkf
else:
    # Python 2.x
    import Tkinter as tk
    import tkFileDialog as tkf
    

def getfile(FilterSpec='*', DialogTitle='Select File: ', DefaultName=''):
    '''
    Selecting an existing file.
    
    Parameters
    ----------
    FilterSpec : query-string
        File filters
    DialogTitle : string
        Window title
    DefaultName : string
        Can be a directory AND filename
    
    Returns
    -------
    filename :  string
        selected existing file, or empty string if nothing is selected
    pathname:   string
        selected path, or empty string if nothing is selected
    
    Examples
    --------
    >>> (myFile, myPath) = thLib.ui.getfile('*.py', 'Testing file-selection', 'c:\\temp\\test.py')
    
    '''
    
    root = tk.Tk()
    root.withdraw()
    fullInFile = tkf.askopenfilename(initialfile=DefaultName,
            title=DialogTitle, filetypes=[('all files','*'), ('Select',
                FilterSpec)])
    
    # Close the Tk-window manager again
    root.destroy()
    
    if not os.path.exists(fullInFile):
        return (0, 0)
    else:
        print('Selection: ' + fullInFile)
        dirName = os.path.dirname(fullInFile)
        fileName = os.path.basename(fullInFile)
        return (fileName, dirName)
        
def savefile(FilterSpec='*',DialogTitle='Save File: ', DefaultName=''):
    '''
    Selecting an existing or new file:
    
    Parameters
    ----------
    FilterSpec : string
        File filters.
    DialogTitle : string
        Window title.
    DefaultName : string
        Can be a directory AND filename.
    

    Returns
    -------
    filename : string
        Selected file.
    pathname : string
        Selecte path.
    

    Examples
    --------
    >>> (myFile, myPath) = thLib.ui.savefile('*.py', 'Testing file-selection', 'c:\\temp\\test.py')

    '''
    
    root = tk.Tk()
    root.withdraw()
    outFile = tkf.asksaveasfile(mode='w', title=DialogTitle, initialfile=DefaultName, filetypes=[('Save as', FilterSpec)])
    
    # Close the Tk-window manager again
    root.destroy()
    
    if outFile == None:
        (fileName, dirName) = ('','')
    else:
        fullOutFile = outFile.name
        print('Selection: ' + fullOutFile)
        dirName = os.path.dirname(fullOutFile)
        fileName = os.path.basename(fullOutFile)
        
    return (fileName, dirName)

def getdir(DialogTitle='Select Directory', DefaultName='.'):
    ''' Select a directory
    
    Parameters
    ----------
    DialogTitle : string
        Window title
    DefaultName : string
        Can be a directory AND filename

    
    Returns
    -------
    directory : string
        Selected directory, or empty string if nothing is selected.

    
    Examples
    --------
    >>> myDir = thLib.ui.getdir('c:\\temp', 'Pick your directory')
    
    '''
    
    root = tk.Tk()
    root.withdraw()
    fullDir = tkf.askdirectory(initialdir=DefaultName, title=DialogTitle)
    
    # Close the Tk-window manager again
    root.destroy()
    
    if not os.path.exists(fullDir):
        return ''
    else:
        print('Selection: ' + fullDir)
        return fullDir
        

def progressbar(it, prefix = "", size = 60):
    '''
    Shows a progress-bar on the commandline.
    This has the advantage that you don't need to bother with windows
    managers. Nifty coding!
    
    Parameters
    ----------
    it : integer array
        index variable
    prefix : string
        Text preceding the progress-bar
    size : integer
        Length of progress-bar

    Examples
    --------
    >>> import time
    >>> for ii in progressbar(range(50), 'Computing ', 25):
    >>>    #print(ii)
    >>>    time.sleep(0.05)
    
    '''

    count = len(it)
    def _show(_i):
        # Helper function to print the desired information line.

        x = int(size*_i/count)
        sys.stdout.write("%s[%s%s] %i/%i\r" % (prefix, "#"*x, "."*(size-x), _i, count))
#        sys.stdout.flush()
    
    _show(0)
    for i, item in enumerate(it):
        yield item
        _show(i+1)
    sys.stdout.write("\n")
    sys.stdout.flush()
        
def listbox(items):
    '''GUI for a listbox selection
    
    Parameters
    ----------
    items : list
        Items for selection.
    frame : tkinter Frame
        If provided, the list is put in the given frame. Otherwise, a new frame is created.
        
    Returns
    -------
    selected : string
        Selected item.
        If no selection is made, and empty string ('') is returned.
    
    Examples
    --------
    >>> (selData, selName) = thLib.ui.listbox(['Peter', 'Paul', 'Mary'])
    
    '''
    
    class Variables():
        """Class for the GUI-display of the items provided"""

        def __init__(self, master, items):
            self.master = master
            self.frame = tk.Frame(master)
            #tk.Frame.__init__(self, frame)
            self.frame.grid()
            self.createWidgets(items)
            
        def selectAndQuit(self):
            '''Grab the selected item, and close the GUI'''
            try:
                self.selected = self.items[int(self.listbox.curselection()[0])]
            except IndexError:
                # No selection made
                self.selected = ''
            self.master.destroy()
    
        def quitFun(self):
            self.selected = ''
            self.master.destroy()
    
        def createWidgets(self, items):
            '''Create the List, and the Quit-button'''
            
            self.listbox = tk.Listbox(self.frame, name='varSelection', font=('times',13))
            
            # Populate the list with the items provided
            self.items = items
            for item in items:
                self.listbox.insert(tk.END,item)
                
            # Place it on the grid
            self.listbox.grid(row=0, columnspan=2)
    
            # Create and place the Quit-button
            self.quitButton = tk.Button(self.frame, text='Select', command=self.selectAndQuit)
            self.quitButton.grid(row=1, column=0)
            self.quitButton = tk.Button(self.frame, text='Quit', command=self.quitFun)
            self.quitButton.grid(row=1, column=1)
            
    # Run the GUI:
    root = tk.Tk()
    app = Variables(root, items)
    root.mainloop()  
        
    # Grab the selected value
    returnVal = app.selected
    
    return returnVal
    
if __name__ == "__main__":   
    # Test functions
    '''
    import time
    for ii in progressbar(range(50), 'Computing ', 25):
        #print(ii)
        time.sleep(0.05)
        

    (myFile, myPath) = getfile('*.eps', 'Testing file-selection', r'c:\temp\test.eps')
    if myFile == 0:          
        print(0)
    else:
        print('File: %s, Path: %s' % (myFile, myPath))
    (myFile, myPath) = savefile('*.txt', 'Testing saving-selection', r'c:\temp\test.txt')
        
    myDir = getdir()
    print(myDir)

    '''
    
    items = ['Peter', 'Paul', 'Mary']    
    selected = listbox(items*4)
    if selected == '':
        print('No selection made.')
    else:
        print('You have selected {0}'.format(selected))
    
    '''
    import numpy as np
    import pandas as pd
    x = np.arange(5)
    y = np.random.randn(5,3)
    s = pd.Series(x)
    df = pd.DataFrame(y)
    z = 'abc'
    
    selVal, selName = selectPlotVar(sys._getframe())
    #selected = selectPlotVar()
    curFrame = sys._getframe()
    varList = curFrame.f_locals.keys()
    ndList = [var for var in varList if type(curFrame.f_locals[var])==np.ndarray]
    dfList = [var for var in varList if type(curFrame.f_locals[var])==pd.core.frame.DataFrame]
    seriesList = [var for var in varList if type(curFrame.f_locals[var])==pd.core.series.Series]
    fullList = ndList+dfList+seriesList
    
    selected = listbox(fullList)
    
    print(selName)
    print(selVal)
    
    root = tk.Tk()
    app = Demo1(root, sys._getframe())
    root.mainloop()

    '''
