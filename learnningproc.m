function learnningproc(w,wRect,ftvparas, scale, perspectdis)
    % away 
    % @scale = 1
    % @perspectdis= 3000
   
    
    % towards
    % @scale = 20
    % @perspectdis= 4000    
  
    
    % FTV/FA test part
    % @scale = ftvparas.distanceArray(ftvparas.TrialType(str2num(ftvparas.condition{trial}(1))))
    % @perspectdis= 3000
    
    InitializeMatlabOpenGL;
    ftvparas.distance=-ftvparas.maxdist*scale;
    angle=(2.0*atan(ftvparas.factor*ftvparas.maxdist/(2.0*abs(ftvparas.distance))))*180.0/pi;
    Screen('BeginOpenGL',w);
    ar=RectHeight(wRect)/RectWidth(wRect);
    glViewport(0, 0, RectWidth(wRect), RectHeight(wRect));
    glColor3f(1,1,0);
    glEnable(GL.LIGHT0);
    glEnable(GL.BLEND);
    glBlendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
    glMatrixMode(GL.PROJECTION);
    glLoadIdentity;
    %
    gluPerspective(angle, 1/ar, 0.1, perspectdis);
    %
    glMatrixMode(GL.MODELVIEW);
    glLoadIdentity;
    glLightfv(GL.LIGHT0,GL.POSITION,[ 1 2 3 0 ]);
    %
    gluLookAt(0,0,-ftvparas.distance,0,0,0,0,1,0);
    %
    glClearColor(0,0,0,0);
    glClear;
    Screen('EndOpenGL',w);
    for repeat1=1:3
        for i=1:ftvparas.framesPerCycle
            for j=1:ftvparas.dotsPerFrame
                moglDrawDots3D(w,[ftvparas.coordinate((i-1)*ftvparas.dotsPerFrame+j,2) ftvparas.coordinate((i-1)*ftvparas.dotsPerFrame+j,3) ftvparas.coordinate((i-1)*ftvparas.dotsPerFrame+j,1)], ftvparas.square_width2, [255 255 255 255],[],1);
            end
            Screen('Flip',w);
        end
    end
    
    
end