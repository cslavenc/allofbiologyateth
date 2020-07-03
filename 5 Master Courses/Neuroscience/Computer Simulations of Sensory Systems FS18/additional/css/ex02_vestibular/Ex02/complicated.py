    trial = skin.vector.rotate_vector(data,q_total)
    # calculate axis of rotation
    axis_of_rotation = np.cross(sensor_reference,ideal_gravity)
    # calculate unit quaternion n = q_vec / |q_vec|
    n = axis_of_rotation / np.linalg.norm(axis_of_rotation)
    # calculate angle of rotation
    sin_value=np.linalg.norm(axis_of_rotation)/(np.linalg.norm(sensor_reference)*9.8)
    angle=np.arcsin(sin_value)
    # calculate corresponding quaternion
    quaternion = skin.quat.Quaternion(
        np.array([np.cos(angle/2),n[0]*np.sin(angle/2),n[1]*np.sin(angle/2),n[2]*np.sin(angle/2)]))
    # convert quaternion to rotation matrix
    rot1 = skin.quat.convert(quaternion.values, to='rotmat')
    # calculate rotation matrix for 90 degree rotation around x-axis
    rot2 = skin.rotmat.R(0,90)
    # memory allocation
    updated_data=[]
    length = len(data)
    # for each data point ...
    for i in range(length):
        # apply 1st rotation
        data_1 = np.matmul(rot1,data[i])
        # apply 2nd rotation
        data_2 = np.matmul(rot2,data_1)
        updated_data.append(data_2)