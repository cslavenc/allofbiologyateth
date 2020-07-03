# Web supplements, J Wang, Physics, UMass Dartmouth
# Cature images and make movies of a bouncing ball
# If no FFmpeg program is found, only images will be generated
from vpython import *        # get VPython modules
from PIL import ImageGrab   # PIL
from subprocess import call # for issuing commands

def canvas(scene):  # return canvas bounding box, excluding frames
    bar, d = 30, 8  # title bar and frame thickness for Windows
    return (int(scene.x+d), int(scene.y+bar), 
            int(scene.width-d), int(scene.height-d))
            
scene = display(title='Bouncing ball')
ball = sphere(pos=(0,5,0), radius=1, color=color.yellow)    # ball
floor = box(pos=(0,-5,0), length=8, height=0.2, width=4)    # floor

dt = 0.01           # time step size
v = 0.0             # initial velocity
ic, fnum = 0, 0     # counter, and file number

while True:         # loop forever
    rate(400)       # limit animation rate to 400 loops/sec
    ball.pos.y = ball.pos.y + v*dt      # update y position
    if ball.pos.y > floor.y + ball.radius:  
        v = v - 9.8*dt      # above floor, update velocity
    else:                               
        v = - v             # below floor, reverse velocity
# capture images, for 200 frames
    if (fnum >= 200): 
        break
    elif (ic%20 == 0):      # grab every 20 iterations, may need adjustment
        im = ImageGrab.grab(canvas(scene))
        num = '00'+repr(fnum)           # sequence num 000-00999, trunc. below
        im.save('img-'+num[-3:]+'.png') # save to png file, 000-999, 3 digits
        fnum += 1
    ic += 1

# if the program cannot find "ffmpeg", check its path. can also replace it with "movie.bat"
call("ffmpeg -r 20 -i img-%3d.png -vcodec libx264 -vf format=yuv420p,scale=412:412 -y movie.mp4")
print ("\n Movie made: movie.mp4")
