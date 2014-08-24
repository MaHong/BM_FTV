function BmFTV
% function to test whether the memory load can influence the willness to
% remember(distance judgement) or not



try
    % get basic subinfo
    prompt = {'被试序号','姓名','性别[1=男,2=女]','年龄','利手[1=右利手,2=左利手]'};
    dlg_title = '被试信息';
    num_lines = 1;
    defaultanswer = {'','','1','20','1'};
    subinfo = inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    subID = str2num([subinfo{1}]);
    name= [subinfo{2}];
    sex = str2num([subinfo{3}]);
    age = str2num([subinfo{4}]);
    
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
    Rcircle=6 * cm2pixel; %the visual degress of the radius of the circle is 4 degree, which equal to 4.88 cm (distance to  the screen 70 cm)
    % positions
    n=1;
    NumSplit=5;
    PerDegree= (360/NumSplit)/180 * pi;%Convert to Pi
    for i=1:NumSplit
        MovieCntre(n,:) = [a+Rcircle*cos(i*PerDegree)   b+Rcircle*sin(i*PerDegree)];
        n=n+1;
    end
    
    
    
    %input file==================================
    whitepath = 'movie\white\';
    imgformatsuffix = '*.jpg';
    
    folderlist = {'leg','jump','run','turn','wave'};
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
    start_img = imread('pic\start.jpg');
    starttwo_img = imread('pic\start2.jpg');
    rest_img = imread('pic\wait.jpg');
    over_img = imread('pic\over.jpg');
    miss_img = imread('pic\miss.jpg');
    practiceOver_img = imread('pic\prac_over.jpg');
    practiceStart_img = imread('pic\prac_start.jpg');
    answer_img = imread('pic\answer.jpg');
    FTV_img = imread('pic\tutorial_FTV.jpg');
    FW_img = imread('pic\tutorial_FW.jpg');
    base_img = imread('pic\base.jpg');
    basetwo_img = imread('pic\base2.jpg');
    
    starttwo = Screen('MakeTexture',w,starttwo_img);
    start = Screen('MakeTexture',w,start_img);
    rest = Screen('MakeTexture',w,rest_img);
    over = Screen('MakeTexture',w,over_img);
    miss = Screen('MakeTexture',w,miss_img);
    practiceOver = Screen('MakeTexture',w, practiceOver_img);
    practiceStart = Screen('MakeTexture',w, practiceStart_img);
    answer = Screen('MakeTexture',w,answer_img);
    FTV = Screen('MakeTexture',w,FTV_img);
    FW = Screen('MakeTexture',w,FW_img);
    base = Screen('MakeTexture',w,base_img);
    basetwo = Screen('MakeTexture',w,basetwo_img);
    
    startRect = Screen('Rect', start);
    restRect = Screen('Rect', rest);
    missRect = Screen('Rect', miss);

    
    %=====================================================
    % Run experiment
    %=====================================================
    
    HideCursor;
    pos = [a-startRect(3)/2 b-startRect(4)/2 a+startRect(3)/2 b+startRect(4)/2];
    
    %练习阶段指导语
    if(mod(subID,2)==1)  %奇数被试
        Screen('TextSize', w, 40);
        Screen('DrawTexture', w,start, [], pos);
        Screen('Flip',w);
        KbWait;
        Screen('Flip',w);
        WaitSecs(2);
        
    else              %偶数被试
        Screen('TextSize', w, 40);
        Screen('DrawTexture', w,base,[], pos);
        Screen('Flip',w);
        KbWait;
        Screen('Flip',w);
        WaitSecs(2);
    end
    
    % Practice instructions
    Screen('DrawTexture', w, practiceStart, [], pos);
    Screen('Flip',w);
    WaitSecs(1.5);
    
    % Blank screen 1000ms
    Screen('Flip',w);
    start_time = GetSecs;
    while GetSecs - start_time<1-frame_duration
    end
    
    % 学习阶段 远离
    distance_pra_FA=-ftvparas.maxdist;
    angle_FA=(2.0*atan(ftvparas.factor*ftvparas.maxdist/(2.0*abs(distance_pra_FA))))*180.0/pi;
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
    gluPerspective(angle_FA, 1/ar, 0.1, 3000);
    %
    glMatrixMode(GL.MODELVIEW);
    glLoadIdentity;
    glLightfv(GL.LIGHT0,GL.POSITION,[ 1 2 3 0 ]);
    %
    gluLookAt(0,0,-distance_pra_FA,0,0,0,0,1,0);
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
    
    Screen('DrawTexture', w, FW, [], pos);
    Screen('Flip',w);
    KbWait;
    
    % 学习阶段 趋近
    distance_pra_FTV=-ftvparas.maxdist*20;
    angle_FTV=(2.0*atan(ftvparas.factor*ftvparas.maxdist/(2.0*abs(distance_pra_FTV))))*180.0/pi;
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
    gluPerspective(angle_FTV, 1/ar, 0.1, 4000);
    %
    glMatrixMode(GL.MODELVIEW);
    glLoadIdentity;
    glLightfv(GL.LIGHT0,GL.POSITION,[ 1 2 3 0 ]);
    %
    gluLookAt(0,0,-distance_pra_FTV,0,0,0,0,1,0);
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
    Screen('DrawTexture', w, FTV, [], pos);
    Screen('Flip',w);
    KbWait;
    
    %练习阶段
    for trial = 1:24  %24次练习
        % fixation300ms
        Screen('FillRect', w, [0,0,0]);
        Screen('DrawText',w, '+',a ,b,[255,0,0]);
        Screen('Flip',w);
        start_time=GetSecs;
        while GetSecs - start_time<0.3-frame_duration 
        end
        Screen('Flip',w);
        
        % blank interval 200ms
        Screen('Flip',w);
        start_time = GetSecs;
        while GetSecs - start_time<0.2-frame_duration 
        end
        
        % begin the visual display
        position_index = randperm(NumSplit);% Randomized the positions
        position_presentation = zeros(NumSplit,2);% 5*2 zero vector
        for i=1:5
            position_presentation(i,1) = MovieCntre(position_index(i),1);
            position_presentation(i,2) = MovieCntre(position_index(i),2);
        end
        
        %display the memory array
        InputNameIndex = randperm(5); %random the stimuli
        NumMovie=4;
        for rp=1:NumMovie
            for i=1:MovieFrames
                for np=1:NumMovie
                    Screen('DrawTexture',w,act{InputNameIndex(np)}{i},[],[position_presentation(InputNameIndex(np),1)-110 position_presentation(InputNameIndex(np),2)-90 position_presentation(InputNameIndex(np),1)+110 position_presentation(InputNameIndex(np),2)+90]);
                end
                Screen('Flip',w);
            end
        end
        
        % Show the blank interval between memory and test array
        Screen('Flip',w);
        start_time=GetSecs;
        while GetSecs - start_time<0.3-frame_duration 
        end
        
        keyisdown = 1;
        while(keyisdown) % first wait until all keys are released
            [keyisdown,secs,keycode] = KbCheck;
            WaitSecs(0.001); % delay to prevent CPU hogging
        end
        
        %%% the distance judgement part  abc %%%
        ftvparas.distance=-ftvparas.maxdist*ftvparas.distanceArray(ftvparas.TrialType(str2num(ftvparas.condition{trial}(1))));
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
        gluPerspective(angle, 1/ar, 0.1, 3000);
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
        for repeat1 = 1:3
            for i=1:ftvparas.framesPerCycle
                for j=1:ftvparas.dotsPerFrame
                    moglDrawDots3D(w,[ftvparas.coordinate((i-1)*ftvparas.dotsPerFrame+j,2) ftvparas.coordinate((i-1)*ftvparas.dotsPerFrame+j,3) ftvparas.coordinate((i-1)*ftvparas.dotsPerFrame+j,1)], ftvparas.square_width2, [255 255 255 255],[],1);
                end
                Screen('Flip',w);
            end
        end
        
        % FTV/W judgement
        start_time=GetSecs;
        
        while GetSecs - start_time < 2
            Screen('TextSize', w, 40); %set the font size, here mainly for the size of the question mark
            Screen('DrawTexture', w, answer, [], pos);
            Screen('Flip',w);
            [keyisdown,secs,keycode] = KbCheck;
            WaitSecs(0.001); % delay to prevent CPU hogging
            if keycode(keysetup.back)
                answer_code(trial) = 0;
                break
            end
            if keycode(keysetup.forward)
                answer_code(trial) = 1;
                break
            end
        end
        if GetSecs - start_time >=2
            answer_code(trial) = 3;%被试没有按键
        end;
        
        % Get keypress response
        keyisdown = 1;
        while(keyisdown) % first wait until all keys are released
            [keyisdown,secs,keycode] = KbCheck;
            WaitSecs(0.001); % delay to prevent CPU hogging
        end
        
        % show the bm memory test array
        start_time=GetSecs;
        flag=0;
        if (xor(mod(subID,2)==1,trial>=12))   %%%%%%%%%%%%%%%%%%%%%%%% 记忆检测   奇数被试 或者 tiral数大于12 满足两个条件中的一个
            while GetSecs - start_time < 3
                if str2num(ftvparas.condition{trial}(1))==0     %% bm no change 
                        for np=1:4
                            if flag==1;
                            	break;
                            end
                            for i=1:MovieFrames
                                if flag==1;
                                    break;
                                end
                                Screen('DrawTexture',w,act{InputNameIndex(1)}{i},[],[a-110 b-90 a+110 b+90]);
                                Screen('Flip',w);
                                [keyisdown,secs,keycode] = KbCheck;
                                WaitSecs(0.001); % delay to prevent CPU hogging
                                if keycode(keysetup.escapekey)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 3;%被试按键退出
                                    break
                                end
                                if keycode(keysetup.F)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 2;
                                    break
                                end
                                if keycode(keysetup.J)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 1;
                                    break
                                end
                                rtime(trial) = GetSecs - start_time;
                                response_code(trial) = 3;%被试没有按键
                               
                            end % for i =movies
                        end % end np
                   else                                   %% bm change
                       for np=1:4
                           if flag==1;
                               break;
                           end
                           for i=1:MovieFrames
                               if flag==1;
                                   break;
                               end
                               Screen('DrawTexture',w,act{InputNameIndex(1)}{i},[],[a-110 b-90 a+110 b+90]);
                               Screen('Flip',w);
                               [keyisdown,secs,keycode] = KbCheck;
                                WaitSecs(0.001); % delay to prevent CPU hogging
                                if keycode(keysetup.escapekey)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 3;%被试按键退出
                                    break
                                end
                                if keycode(keysetup.F)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 2;
                                    break
                                end
                                if keycode(keysetup.J)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 1;
                                    break
                                end
                                rtime(trial) = GetSecs - start_time;
                                response_code(trial) = 3;%被试没有按键                             
                           end  % end for
                       end % end np
                   end  %end if 
            end %end -while
        else   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%unload 条件  基线水平
             while GetSecs - start_time < 3
                  if str2num(ftvparas.condition{trial}(1))==0 || str2num(ftvparas.condition{trial}(1))==1 %无论记忆项是否变化
                        for np=1:4
                            if flag==1;
                                break;
                            end
                            for i=1:MovieFrames
                                if flag==1;
                                    break;
                                end
                                Screen('DrawTexture',w,act{InputNameIndex(1)}{i},[],[a-110 b-90 a+110 b+90]);
                                Screen('Flip',w);
                                if keycode(keysetup.confirm)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 4;
                                    break
                                end
                                rtime(trial) = GetSecs - start_time;
                                response_code(trial) = 3;%被试没有按键
                            end %end for  
                        end % end np
                    end %end if
             end %end while
        end % end 奇偶检测
                    
%                 if keyisdown==1
%                     break
%                 end

        if keycode(keysetup.escapekey)
            rtime(trial) = GetSecs - start_time;
            response_code(trial) = 3;
            break
        end
        
        if ~((response_code(trial)==str2num(ftvparas.condition{trial}(2))+1)|| (response_code(trial) == 4))
            Screen('DrawTexture', w, miss, [], [a-missRect(3)/2 b-missRect(4)/2 a+missRect(3)/2 b+missRect(4)/2]);  %%判断反馈
            Screen('Flip',w);
            WaitSecs(0.2);
        end
        Screen('Flip',w);
        
        %%
        keyisdown = 1;
        while(keyisdown) % first wait until all keys are released
            [keyisdown,secs,keycode] = KbCheck;
            WaitSecs(0.001); % delay to prevent CPU hogging
        end
        
        %%  blank interval between tirals -------------------
        Screen('Flip',w);
        start_time=GetSecs;
        while GetSecs - start_time<1-frame_duration %blank,duration is 1sec
        end
        
        %练习阶段休息--两种条件均要练习，顺序与正式实验相同-------------------------------------------------------
        if (mod(trial,12)==0 && trial~=24)
            Screen('DrawTexture', w, rest, [], [a-restRect(3)/2 b-restRect(4)/2 a+restRect(3)/2 b+restRect(4)/2]);
            Screen('Flip',w);
            keyisdown = 1;
            while(keyisdown) % first wait until all keys are released
                [keyisdown,secs,keycode] = KbCheck;
                WaitSecs(0.001); % delay to prevent CPU hogging
            end
            KbWait;
            WaitSecs(2);
            Screen('Flip',w);
            %the second block task
            if(mod(subID,2)==1)
                Screen('TextSize', w, 40);
                Screen('DrawTexture', w,basetwo, [], pos);
                Screen('Flip',w);
                KbWait;
                Screen('Flip',w);
                WaitSecs(2);
            else
                Screen('TextSize', w, 40);
                Screen('DrawTexture', w,starttwo, [], pos);
                Screen('Flip',w);
                KbWait;
                Screen('Flip',w);
                WaitSecs(2);
            end
        end
        
        
    end %endpractice
    
    
    Screen('TextSize', w, 40);
    Screen('DrawTexture', w, practiceOver, [], pos);
    Screen('Flip',w);
    KbWait;
    Screen('Flip',w);
    WaitSecs(2);
    
    
    %正式实验指导语
    if(mod(subID,2)==1)
        Screen('TextSize', w, 40);
        Screen('DrawTexture', w,start, [], pos);
        Screen('Flip',w);
        KbWait;
        Screen('Flip',w);
        WaitSecs(2);
        
    else
        Screen('TextSize', w, 40);
        Screen('DrawTexture', w,base,[], pos);
        Screen('Flip',w);
        KbWait;
        Screen('Flip',w);
        WaitSecs(2);
    end
    
    
    %正式实验
    task = zeros(192);
    for trial = 1:length(ftvparas.condition)
        
        % fixation300ms
        Screen('FillRect', w, [0,0,0]);
        Screen('DrawText',w, '+',a ,b,[255,0,0]);
        Screen('Flip',w);
        start_time=GetSecs;
        while GetSecs - start_time<0.3-frame_duration %number,duration is0.5sec
        end
        Screen('Flip',w);
        
        % blank interval 200ms
        Screen('Flip',w);
        start_time = GetSecs;
        while GetSecs - start_time<0.2-frame_duration %blank,duration is1.0sec
        end
        
        % begin the visual display
        %SetSize = str2num(condition{trial}(1));
        position_index = randperm(NumSplit);% Randomized the positions
        position_presentation = zeros(NumSplit,2);% 5*2 zero vector
        for i=1:5
            position_presentation(i,1) = MovieCntre(position_index(i),1);
            position_presentation(i,2) = MovieCntre(position_index(i),2);
        end
        
        %display the memory array
        InputNameIndex = randperm(5); %random the stimuli
        NumMovie=4;
        for rp=1:NumMovie
            for i=1:MovieFrames
                for np=1:NumMovie
                    Screen('DrawTexture',w,act{InputNameIndex(np)}{i},[],[position_presentation(InputNameIndex(np),1)-110 position_presentation(InputNameIndex(np),2)-90 position_presentation(InputNameIndex(np),1)+110 position_presentation(InputNameIndex(np),2)+90]);
                end
                Screen('Flip',w);
            end
        end
        
        % Show the blank interval between memory and test array  300ms
        Screen('Flip',w);
        start_time=GetSecs;
        while GetSecs - start_time<0.3-frame_duration 
        end 
        keyisdown = 1;
        while(keyisdown) % first wait until all keys are released
            [keyisdown,secs,keycode] = KbCheck;
            WaitSecs(0.001); % delay to prevent CPU hogging
        end
        
        
        %%% the distance judgement part  abc %%%
        ftvparas.distance=-ftvparas.maxdist*ftvparas.distanceArray(ftvparas.TrialType(str2num(ftvparas.condition{trial}(1))));
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
        gluPerspective(angle, 1/ar, 0.1, 3000);
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
        for repeat1 = 1:3
            for i=1:ftvparas.framesPerCycle
                for j=1:ftvparas.dotsPerFrame
                    moglDrawDots3D(w,[ftvparas.coordinate((i-1)*ftvparas.dotsPerFrame+j,2) ftvparas.coordinate((i-1)*ftvparas.dotsPerFrame+j,3) ftvparas.coordinate((i-1)*ftvparas.dotsPerFrame+j,1)], ftvparas.square_width2, [255 255 255 255],[],1);
                end
                Screen('Flip',w);
            end
        end
        
        % FTV/W judgement
        start_time=GetSecs;
        while GetSecs - start_time < 2
            Screen('TextSize', w, 40); %set the font size, here mainly for the size of the question mark
            Screen('DrawTexture', w, answer, [], pos);
            Screen('Flip',w);
            [keyisdown,secs,keycode] = KbCheck;
            WaitSecs(0.001); % delay to prevent CPU hogging
            if keycode(keysetup.back)
                answer_code(trial) = 0;
                break
            end
            if keycode(keysetup.forward)
                answer_code(trial) = 1;
                break
            end
        end
        if GetSecs - start_time >=2
            answer_code(trial) = 3;%被试没有按键
        end;
        
        % Get keypress response
        keyisdown = 1;
        while(keyisdown) % first wait until all keys are released
            [keyisdown,secs,keycode] = KbCheck;
            WaitSecs(0.001); % delay to prevent CPU hogging
        end
        
        % show the bm memory test array
        start_time=GetSecs;
        flag=0;
        if (xor(mod(subID,2)==1,trial>=12))   %%%%%%%%%%%%%%%%%%%%%%%% 记忆检测   奇数被试 或者 tiral数大于12 满足两个条件中的一个
            while GetSecs - start_time < 3
                if str2num(ftvparas.condition{trial}(1))==0     %% bm no change 
                        for np=1:4
                            if flag==1;
                            	break;
                            end
                            for i=1:MovieFrames
                                if flag==1;
                                    break;
                                end
                                Screen('DrawTexture',w,act{InputNameIndex(1)}{i},[],[a-110 b-90 a+110 b+90]);
                                Screen('Flip',w);
                                [keyisdown,secs,keycode] = KbCheck;
                                WaitSecs(0.001); % delay to prevent CPU hogging
                                if keycode(keysetup.escapekey)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 3;%被试按键退出
                                    break
                                end
                                if keycode(keysetup.F)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 2;
                                    break
                                end
                                if keycode(keysetup.J)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 1;
                                    break
                                end
                                rtime(trial) = GetSecs - start_time;
                                response_code(trial) = 3;%被试没有按键
                               
                            end % for i =movies
                        end % end np
                   else                                   %% bm change
                       for np=1:4
                           if flag==1;
                               break;
                           end
                           for i=1:MovieFrames
                               if flag==1;
                                   break;
                               end
                               Screen('DrawTexture',w,act{InputNameIndex(1)}{i},[],[a-110 b-90 a+110 b+90]);
                               Screen('Flip',w);
                               [keyisdown,secs,keycode] = KbCheck;
                                WaitSecs(0.001); % delay to prevent CPU hogging
                                if keycode(keysetup.escapekey)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 3;%被试按键退出
                                    break
                                end
                                if keycode(keysetup.F)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 2;
                                    break
                                end
                                if keycode(keysetup.J)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 1;
                                    break
                                end
                                rtime(trial) = GetSecs - start_time;
                                response_code(trial) = 3;%被试没有按键                             
                           end  % end for
                       end % end np
                   end  %end if 
            end %end -while
        else   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%unload 条件  基线水平
             while GetSecs - start_time < 3
                  if str2num(ftvparas.condition{trial}(1))==0 || str2num(ftvparas.condition{trial}(1))==1 %无论记忆项是否变化
                        for np=1:4
                            if flag==1;
                                break;
                            end
                            for i=1:MovieFrames
                                if flag==1;
                                    break;
                                end
                                Screen('DrawTexture',w,act{InputNameIndex(1)}{i},[],[a-110 b-90 a+110 b+90]);
                                Screen('Flip',w);
                                if keycode(keysetup.confirm)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 4;
                                    break
                                end
                                rtime(trial) = GetSecs - start_time;
                                response_code(trial) = 3;%被试没有按键
                            end %end for  
                        end % end np
                    end %end if
             end %end while
        end % end 奇偶检测
                    
%                 if keyisdown==1
%                     break
%                 end

        if keycode(keysetup.escapekey)
            rtime(trial) = GetSecs - start_time;
            response_code(trial) = 3;
            break
        end
        
        if ~((response_code(trial)==str2num(ftvparas.condition{trial}(2))+1)|| (response_code(trial) == 4))
            Screen('DrawTexture', w, miss, [], [a-missRect(3)/2 b-missRect(4)/2 a+missRect(3)/2 b+missRect(4)/2]);  %%判断反馈
            Screen('Flip',w);
            WaitSecs(0.2);
        end
        Screen('Flip',w);
        
        
        %%
        keyisdown = 1;
        while(keyisdown) % first wait until all keys are released
            [keyisdown,secs,keycode] = KbCheck;
            WaitSecs(0.001); % delay to prevent CPU hogging
        end
        %% 100 ms blank interval-------------------
        Screen('Flip',w);
        start_time=GetSecs;
        while GetSecs - start_time<1 -frame_duration %blank,duration is0.2sec
        end
        
        %休息-------------------------------------------------------
        if (mod(trial,48)==0 && trial~=192)
            Screen('DrawTexture', w, rest, [], [a-restRect(3)/2 b-restRect(4)/2 a+restRect(3)/2 b+restRect(4)/2]);
            Screen('Flip',w);
            keyisdown = 1;
            while(keyisdown) % first wait until all keys are released
                [keyisdown,secs,keycode] = KbCheck;
                WaitSecs(0.001); % delay to prevent CPU hogging
            end
            KbWait;
            WaitSecs(2);
            Screen('Flip',w);
            %the second block task
            if (xor(mod(subID,2)==1, trial==144))
                Screen('TextSize', w, 40);
                Screen('DrawTexture', w,basetwo, [], pos);
                Screen('Flip',w);
                KbWait;
                Screen('Flip',w);
                WaitSecs(2);
            else
                Screen('TextSize', w, 40);
                Screen('DrawTexture', w,starttwo, [], pos);
                Screen('Flip',w);
                KbWait;
                Screen('Flip',w);
                WaitSecs(2);
            end
        end
        
        %start_time=GetSecs;
        %while GetSecs - start_time<1.5+rand*0.5 %duration is 1.5~2sec
        %end
    end
    
    %Screen('TextSize', w, 40);
    Screen('DrawTexture', w, over, [], pos);
    Screen('Flip',w);
    KbWait;
    
    Screen('Flip',w);
    WaitSecs(1.5);
    Priority(0);
    Screen('Close',w);
    ShowCursor;
    
    
    fid = fopen(['results/' name '_BM_FTV_formal.txt'],'w');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','Name','Id','Sex','Age','Trial','Setsize','Change','Acc','RT','distance','FTV','Condition');
    for j = 1:trial
        fprintf(fid,'%s\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%4.3f\t%3.3f\t%4.0f\t%3.0f\t%3.0f\n', name,subID,sex,age,j,str2num(ftvparas.condition{j}(1)),str2num(ftvparas.condition{j}(3)),response_code(j)==str2num(ftvparas.condition{j}(3))+1,rtime(j),ftvparas.TrialType(str2num(ftvparas.condition{j}(2))),answer_code(j),task(j));
    end
    fclose(fid);
    clear all
catch
    
    Screen('Closeall')
    rethrow(lasterror)
    clear all
end





