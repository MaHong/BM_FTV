function threedparametersetupfun(w,wRect)
% set the screen to display 3d stimulus
 InitializeMatlabOpenGL;
Screen('BeginOpenGL',w);
ar=RectHeight(wRect)/RectWidth(wRect);%屏幕高宽比
% Set viewport properly:
glViewport(0, 0, RectWidth(wRect), RectHeight(wRect));
glColor3f(1,1,0);
glEnable(GL.LIGHT0);
glEnable(GL.BLEND);
glBlendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
glMatrixMode(GL.PROJECTION);
glLoadIdentity;
% Field of view is 25 degrees from line of sight. Objects closer than
% 0.1 distance units or farther away than 100 distance units get clipped
% away, aspect ratio is adapted to the monitors aspect ratio:
gluPerspective(30, 1/ar, 0.1, 3000);%0.1和1000影响了相机设置的关系，离相机超过1000的东西都会被排除掉
% Setup modelview matrix: This defines the position, orientation and
% looking direction of the virtual camera:
glMatrixMode(GL.MODELVIEW);
glLoadIdentity;
% Our point lightsource is at position (x,y,z) == (1,2,3)...
glLightfv(GL.LIGHT0,GL.POSITION,[ 1 2 3 0 ]);%光源
% Cam is located at 3D position (3,3,5), points upright (0,1,0) and fixates
% at the origin (0,0,0) of the worlds coordinate system:
% The OpenGL coordinate system is a right-handed system as follows:
% Default origin is in the center of the display.
% Positive x-Axis points horizontally to the right.
% Positive y-Axis points vertically upwards.
% Positive z-Axis points to the observer, perpendicular to the display
% screens surface.
gluLookAt(0,0,-1200,0,0,0,0,1,0);
% Set background clear color to 'black' (R,G,B,A)=(0,0,0,0):
glClearColor(0,0,0,0);
% Clear out the backbuffer: This also cleans the depth-buffer for
% proper occlusion handling: You need to glClear the depth buffer whenever
% you redraw your scene, e.g., in an animation loop. Otherwise occlusion
% handling will screw up in funny ways...
glClear;
Screen('EndOpenGL', w);
end