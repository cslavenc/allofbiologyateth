# -*- coding: utf-8 -*-
"""
Created on Thu Jun 22 17:32:56 2017

@author: user
"""
# -*- coding: utf-8 -*-
"""
@author: Taehoon Kim, Elle Macartney, Lara Riparip
version: 0.5
Exercise 3(vestibular) for the computer simulation of sensory systems.

Execution method: IDLE execution
                   
                     

Program description: The program takes the text file(xsens data) as an input and calculates: 
                      1) Displacement of the right semicircular canal
                      2) Maximum/Minimum acceleration in Y-direction
                      3) Final nose orientation

                     
Program structure:
                    1) Read in text file 
                    2) Declaration of necessary functions
                    3) Matching alignment and rotations between sensor coordinate and spatial coordinate    
                    4) Calculates displacement of right semicircular canal
                    5) Calculates the maximum/minimum acceleration in Y-direction
                    6) Calculates final nose orientation

"""

import getXsens
import numpy as np
import skinematics as k
import scipy.signal as signal



#The function below aligns 3d sensor data(Nx3)(applicable for both gyroscope and accelerometer data) with the given space coordinate.
def Calc_true_align(true_align, data, sensor_alignment):
    #calculate I vector
    #extract the x,y,z accelerations on Cartesean coordinate in Time 0.
    axis=np.cross(sensor_alignment,true_align)
    axis_unit_vector=axis/np.linalg.norm(axis)
    
    
    #calculate the angle in between
    sin_value=np.linalg.norm(axis)/(np.linalg.norm(sensor_alignment)*9.8)
    
    #degree in radians
    degree_rad=np.arcsin(sin_value)
    
    #declare aligning quarternion
    quarternion_align=k.quat.Quaternion(np.array([np.cos(degree_rad/2),axis_unit_vector[0]*np.sin(degree_rad/2),axis_unit_vector[1]*np.sin(degree_rad/2),axis_unit_vector[2]*np.sin(degree_rad/2)]))
    
    
    #rotation matrix from alignment quarternion
    rotation_matrix_align=k.quat.convert(quarternion_align.values, to='rotmat')

    #rotating the coordinate to move Y axis to Z (+) axis    
    rotating_90degrees=k.rotmat.R1(90)
    
    
    #placeholder for new_data
    new_data=[]
    
    #total number of entries (number of counter)
    list_num=data.shape[0]

    for ii in range(list_num):
        middle_product=np.matmul(rotation_matrix_align,data[ii])
        middle_product2=np.matmul(rotating_90degrees,middle_product)
        new_data.append(middle_product2)
    

    return np.array(new_data)





# Calculates stimulation /displacement of the right canal in the horizontal direction and writes the text file.
# Must take in deg/s angular velocity array(Nx3)
# Also returns array with displacement values.
def Calc_canal_stimulation(new_data, counter):
    
    #calculating the stimulation amplitude
    #using the value from the ipython notebook, we calculate only the right side.
    # SCC dynamics from ipython notebook
    T1 = 0.01
    T2 = 5
    num = [T1*T2, 0]
    den = [T1*T2, T1+T2, 1]
    scc = signal.lti(num, den)
    time=np.reshape((counter-counter[0])/50, (len(counter),)) #sampling frequency is 50
     

    
    
    Canals = {'info': 'The matrix rows describe horizontal, anterior, and posterior canal orientation',
     'right': np.array(
            [[0.365,  0.158, -0.905], 
             [0.652,  0.753, -0.017],
             [0.757, -0.561,  0.320]]),
     'left': np.array(
            [[-0.365,  0.158,  0.905],
             [-0.652,  0.753,  0.017],
             [-0.757, -0.561, -0.320]])}
    
    # Normalize these vectors
    for side in ['right', 'left']:
        Canals[side] = (Canals[side].T / np.sqrt(np.sum(Canals[side]**2, axis=1))).T
    
    #number of entries
    list_num=new_data.shape[0]

    
    #calculate the dot product to find 
    stim_right = np.dot(new_data,Canals['right'][0])
    _, ang_acc_right, _ = signal.lsim(scc, stim_right, time)
    perimeter_of_human_semicircular_canal=3.2*2*np.pi
    
    #placeholder for displacement values.
    mm_vec_R=[]
    for jj in range(list_num):
        mm_accel_R=perimeter_of_human_semicircular_canal*ang_acc_right[jj]/360
        mm_vec_R.append(mm_accel_R)
        
    
    #Max left way right ear displacement
    max_accel_R=np.max(mm_vec_R)
    
    #Max right way right ear displacement
    min_accel_R=np.min(mm_vec_R)

    #declaring both values as one array.
    displacement=np.array([max_accel_R, min_accel_R])
    print(displacement)

    #saving/writing the value
    np.savetxt("CupularDisplacement.txt",displacement, fmt='%10.5f')

    return mm_vec_R


#calculates Max, Min acceleration along y axis and writes/saves both values. Also returns array with acceleration values for each time point. 

def get_y_axis_acceleration(new_data_xyz_coordinate):
    list_num=new_data_xyz_coordinate.shape[0]
    #placeholder
    y_col=[]
    #simply taking y component out to y_column
    for ii in range(list_num):
        y_column_element=new_data_xyz_coordinate[ii][1]
        y_col.append(y_column_element)

    #get max/min values
    maxacceleration=np.array([np.max(y_col),np.min(y_col)])
    np.savetxt("MaxAcceleration.txt",maxacceleration,fmt='%10.5f')
    
    return maxacceleration

#nose position calculation
def Nose_orientation(new_data):

    #calculate head tilt
    #15 degrees to radian
    rotation_head_tilt=k.rotmat.R2(15)
    
    #total number of entries
    list_num=new_data.shape[0]
    
    #placeholder 
    gyrosignal_nose=[]
    
    
    #apply 
    for ii in range(list_num):
        placehold=np.matmul(rotation_head_tilt,new_data[ii])
        gyrosignal_nose.append(placehold)



    #preparing quaternions from angular velocities
    orientation=k.quat.calc_quat(gyrosignal_nose,[0,0,0],rate=50,CStype="bf")
    #calculates nose orientation
    nose_rotmat=k.quat.quat2rotmat(orientation[-1])
    nose=np.matmul(nose_rotmat,np.array([1,0,0]))
    print("Final nose orientation:", nose)

    return nose


if __name__ == "__main__":
    #ideal gravity alignment vector
    true_align=[0,9.8,0]
    
    # reading in the file(Walking_02.txt) with getXsens.py
    data=getXsens.getXSensData('Walking_02.txt', ['Counter', 'Acc', 'Gyr'])
    
    #get counter column
    counter=data[1]

    #get the gyroscope data
    gyro_data=data[3]
    
    #get the accelerometer data
    xyz_acceleration=data[2]

    #sensor alignment
    sensor_alignment=xyz_acceleration[0]
    
    
    #task 1.
    #converting everything into the new coordinate
    aligned_gyro_data=Calc_true_align(true_align, gyro_data, sensor_alignment) 
    #since we will be calculating the displacement we need to transform radians into degrees.
    aligned_gyro_data_deg=np.rad2deg(aligned_gyro_data)
    #calculate displacement
    dis=Calc_canal_stimulation(aligned_gyro_data_deg, counter)
    
    #task2.
    #converting everything into the new coordinate
    aligned_acc_data=Calc_true_align(true_align,xyz_acceleration, sensor_alignment)
    #get Max,Min value along the Y axis
    y=get_y_axis_acceleration(aligned_acc_data)
    
    #task3.
    #calculate nose orientation.
    nose=Nose_orientation(aligned_gyro_data)
