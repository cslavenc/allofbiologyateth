# -*- coding: utf-8 -*-
"""
Created on Sat Mar 24 18:26:55 2018

@author: made_
"""

#%% learning tkinter
import os
import tkinter as tk


filePath = os.path.abspath(__file__)
pathDir = os.path.dirname(filePath)
os.chdir(pathDir) # change directory to where this file is opened
root = tk.Tk()
root.fname = tk.filedialog.askopenfilename(
        initialdir=os.curdir, title="Select file", filetypes=
        (("sound files", ("*.wav", "*.mp3")), ("all files", "*.*")))
root.destroy()
soundname = os.path.basename(root.fname)
splitname = os.path.splitext(root.fname)
temp = '_out'
outputPath = splitname[0] + temp + splitname[1]
outputname = os.path.basename(outputPath)
print(outputname)
#return root.fname

