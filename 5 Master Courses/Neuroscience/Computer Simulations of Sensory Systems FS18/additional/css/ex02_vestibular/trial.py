import numpy as np
import matplotlib.pyplot as plt
import skinematics as skin

import scipy.signal as ss
import matplotlib.pylab as mp

skin.rotmat.R(1,45)
# define approximate sensor orientation
x = [1,0,0] # forward
y = [0,0,-1] # upward
z = [0,1,0] # points to right

R_approx = np.column_stack ( (x,y,z))
print(R_approx)

# functions for working with vectors:
# x points forwrad
vector = [1,1,0]
q_short = (skin.vector.q_shortest_rotation(x, vector))
np.sin(np.deg2rad(22.5))

# default  quat.convert(quat, to='rotmat' => rotation matrix
R_short = skin.quat.convert(q_short)
print(skin.rotmat.convert(R_short)) # convert back to rot

#3) find orientation of right SCC
n_anatomical = [0.32, -0.04, -9.45] # orientation wrt anatomical landmarks
# how to get to orientation in the beginning of the recording? => it is a rotation about the y-axis
Ry_15 = skin.rotmat.R(1,15)
init_anat_rot = Ry_15 @ n_anatomical
print(init_anat_rot)

#4) Using q 0 , ~ n 0 and ω(t) sensor , calculate stim, the stimulation of the right SCC

# Canals are described as a vector (init_anat_rot), we know as well the orientation of the sensor
# sensors measures data wrt to sensor!
# transfer function gives us deflection of cupula

# example in wikibook: 

# simulate response of lowpass filter for step input
# Define transfer function
num = [1]
tau = 7
den = [tau, 1]
mySystem = ss.lti(num, den)

# Generate inSignal
t = np.arange(0,30,0.1)
inSignal = np.zeros(t.size)
inSignal[t>=1] = 1 
#inSignal[10] = 1 small transient response

# Simulate and plot outSignal
tout, outSignal, xout = ss.lsim(mySystem, inSignal, t)
mp.plot(t, inSignal, tout, outSignal)
#mp.show()

#lti = linear time invariant system
# This step gives us the deflection in radians! Thus, multiply delta with radius uf sscanal (3.2mm)

## Head orientation: Go from one to next positoin
#pos = pos0
#vel
#dt
#pos[t+1] = pos_0 * dt * vel

# [from acceleration to position]: work with quaternions
# quaternion multiplication: skin.quat.q_mult(p, q) => remember the right sequence!
# get orientation as function of time. 
# velocity wrt to sensor: another sequence!!
#skin.quat.q_mult()
#skind.quat.calc_quat(omega, q0, rate, CStype)
'''
omaga = angular velocity
q0 = starting orientation # 15 deg nose up
rate = sample rate
CStype = wrt to space or sensor!
'''

# 8. Calculate the stimulation of the otolith hair cell

nose = [1,0,0]
q = [0, 0.1, 0.2]
qinv = skin.quat.q_inv(q)
print(skin.vector.rotate_vector(nose, q))
# a find rot matrix
# convert quaternion to corresp. rotation matrix

acc = [ 0,0,9.81]
R2 - skin.rotmat.R(1,10)
R2 @ acc
R2.T @ acc # express gravity wrt head