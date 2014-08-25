function BmFTV
% function to test whether the memory load can influence the willness to
% remember(distance judgement) or not



try
    % get basic subinfo
    [subID, name, sex, age] = tinputdialog;
    
    %====================================================
    %  Setup the experiment
    %=====================================================
    clear InputName MovieData
        
    %Screen setup %
    AssertOpenGL;
    InitializeMatlabOpenGL;
    PsychImaging('PrepareConfiguration');
    
    Screen('Preference', 'SkipSyncTests', 1);
    screenNumber=max(Screen('Screens'));
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0);
    %[w, wRect]=Screen('OpenWindow',screenNumber, 0,[],32,2);
    frame_duration = Screen('GetFlipInterval',w);
    frame = round(1/frame_duration);
    Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    MovieFrames =60;
    [a,b]=WindowCenter(w);
    
    %3D设置
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
    
    
    
    % Screen priority
    priorityLevel=MaxPriority(w);
    Priority(priorityLevel);
    
    % coordinates
    cm2pixel = 30; %convert centimeter to pixel
    % Rcircle=6 * cm2pixel; %the visual degress of the radius of the circle is 4 degree, which equal to 4.88 cm (distance to  the screen 70 cm)
    spaceofstimulus = 8;
    Rcircle=spaceofstimulus * cm2pixel;
    % positions
    n=1;
    NumSplit=6;
    PerDegree= (360/NumSplit)/180 * pi;%Convert to Pi
    for i=1:NumSplit
        MovieCntre(n,:) = [a+Rcircle*cos(i*PerDegree)   b+Rcircle*sin(i*PerDegree)];
        n=n+1;
    end
    
    
    
    %input file==================================
    whitepath = 'movie\white\';
    imgformatsuffix = '*.jpg';
    
    folderlist = {'leg','jump','run','turn','wave','geo'};
    whitefilereglist = {};
    whitefolderlist = {};
    inputimgpath = '';
    for i=1:length(folderlist)
        inputimgpath = strcat( whitepath, folderlist{i}, '\' );
        whitefolderlist{i} = inputimgpath;
        inputimgpath = strcat( inputimgpath,imgformatsuffix );
        whitefilereglist{i} = inputimgpath;
    end

    whiteactionlist = {};
    whiteactionfilm = {};
    
    for i=1:length(whitefolderlist)
        [whiteactionlist{i},whiteactionfilm{i}]...
            =tinputimgs(w,whitefilereglist{i},whitefolderlist{i});
    end
    %End input file==================================  
    
    
    %% make sprites
    act=whiteactionlist;
    
    % 读入FTV生物运动数据
    ftvparas = tinputparameterfun('walking.txt');

    %========================================
    % keyboard setup %
    keysetup = tkeyboardsetup;
    
    %instruction setup
    inssetup = tinstructionsetup(w);
    
    %=====================================================
    % Run experiment
    %=====================================================
    
    HideCursor;
    pos = [(a-inssetup.startRect(3)/2) b-inssetup.startRect(4)/2 a+inssetup.startRect(3)/2 b+inssetup.startRect(4)/2];
    
    %练习阶段指导语
    ShowInstruction(w,inssetup.start,inssetup.base,pos, mod(subID,2)==1);
    
    % 学习阶段
    learnningproc(w,wRect,ftvparas,1,3000);
    PushImages(w,pos,inssetup.FW);
    KbWait;
    learnningproc(w,wRect,ftvparas,20,4000);
    PushImages(w,pos,inssetup.FTV);
    KbWait;
    
    % Practice instructions
    PushImages(w,pos,inssetup.practiceStart);
    WaitSecs(1.5);
    
    StimulasInterval (w,1,frame_duration);
    
    %练习阶段
    RunExperiment(w,wRect,24,frame_duration,...
    NumSplit,MovieCntre,act,ftvparas,inssetup,pos,...
    keysetup,subID,MovieFrames,a,b,12,1,inssetup.practiceOver);

    
    %正式实验指导语
    ShowInstruction(w,inssetup.start,inssetup.base,pos, mod(subID,2)==1);
    
    %正式实验
   
    [answer_code,rtime,response_code,tasktype] = RunExperiment(w,wRect,length(ftvparas.condition),frame_duration,...
    NumSplit,MovieCntre,act,ftvparas,inssetup,pos,...
    keysetup,subID,MovieFrames,a,b,48,2,inssetup.over);

    %结束实验
    Screen('Flip',w);
    WaitSecs(1.5);
    Priority(0);
    Screen('Close',w);
    ShowCursor;
    
    %输出结果
    fid = fopen(['results/' name '_BM_FTV_formal.txt'],'w');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',...
        'Name','subID','Sex','Age','Trial','Change','Acc',...
        'RT','distance','FTV','Tasktype');
    for j = 1:length(ftvparas.condition)
        fprintf(fid,'%s\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%4.3f\t%3.3f\t%4.0f\t%3.0f\t%3.0f\n',...
        name,subID,sex,age,j,str2num(ftvparas.condition{j}(3)),response_code(j)==str2num(ftvparas.condition{j}(3))+1,...
        rtime(j),ftvparas.TrialType(str2num(ftvparas.condition{j}(1))),answer_code(j),tasktype(j));
    end
    fclose(fid);
    clear all
catch
    
    Screen('Closeall')
    rethrow(lasterror)
    clear all
end





