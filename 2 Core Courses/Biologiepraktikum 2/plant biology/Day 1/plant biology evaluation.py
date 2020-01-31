# -*- coding: utf-8 -*-
"""
Created on Sat Feb 24 09:17:04 2018

@author: made_ - Slaven Cvijetic
"""

# Plant biology practical result evaluation

from numpy import *
from matplotlib.pyplot import *
from sklearn.linear_model import LinearRegression
from pandas import DataFrame

# Data import
# Exp. 4, C4
def f(w_init, w_final):
    return (abs(w_final-w_init))/w_init *100

w_init = array([2.01, 2.04, 2.01, 2.09, 2.02, 1.97])
w_final = array([2.41, 2.43, 2.35, 2.15, 1.89, 1.67])
y = zeros_like(w_init)
y = f(w_init, w_final)
x = array([0, 0.1, 0.2, 0.3, 0.4, 0.5])

# y = mx + q - coeff obtained in R. m is not significant
# aliter: (m,q)=polyfit(x ,y)
m = -0.44571
q = 0.38143
eq = 'y = -0.44571*x + 0.38143'

#%%
# Exp. 1, E15
# Enzymatic acitivity
def ext_coeff(ext,c):
    c = c[1:-1]
    ext = ext[1:-1]
    eps = zeros_like(c)
    l = 1 # in cm
    eps = ext/(l*c)
    return eps

start_ext = array([0.095, 0.064, 0.067, 0.077, 0.096, 0.051])
end_ext = array([0.240, 0.115, 0.114, 0.250, 0.257, 0.305])
ext = abs(start_ext - end_ext)
t = array([0, 5, 10, 15, 20, 30]) # in mins

#Calibration curve
start_ext2 = array([0.07, 0.045, 0.046, 0.051, 0.045, 0.044])
end_ext2 = array([0.048, 0.219, 0.387, 1.399, 1.704, 2.290])
ext2 = abs(start_ext2 - end_ext2)
gluc_sol = array([0, 5, 10, 20, 30, 40])
eps = ext_coeff(ext2, gluc_sol)
# since eps has different values for the extinction coefficient it is useful to
# fit a linear regression. Values were obtained in R.
m_cal = 0.058547 # significance: 10**-4
q_cal = -0.059579 # not significant. Will be treated as 0 in the calibration graph.
#sd_cal = 0.9136292

#%%
# plots
# Exp. 4
plot(x,w_final)
xlabel("concentration in [M] of sucrose")
ylabel("in %")
title("Relative change of weight after sucrose exposure")
#text(1,1,...)
show()

# Exp. 1, E15
# Enzymatic activity
plot(t, ext)
xlabel("t in mins")
ylabel("difference extinction")
title("WT plant")
show()

#%%
# Calibration curve
gluc_sol = array([0, 5, 10, 20, 30, 40])
plot(gluc_sol, ext2, label='measured data')
xlabel("Glucose solution (5nmol/microliter)")
ylabel("difference extinction")
title("Calibration curve")

#dummy data set, for the linear regression
x_cal = linspace(0,40,1000,retstep=False)
y_cal = lambda x_cal: m_cal * x_cal
plot(x_cal, m_cal*x_cal, label='linear regression', linestyle='--')
#errorbar(gluc_sol, ext2, yerr=sd_cal)
legend()
show()