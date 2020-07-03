import numpy as np
import matplotlib.pyplot as plt
import skinematics as skin

skin.rotmat.R(1,45)
# define approximate sensor orientation
x = [1,0,0]
y = [0,0,1]
z = [-1,0,0] # points to right

R_approx = np.column_stack ( (x,y,z))
print(R_approx)