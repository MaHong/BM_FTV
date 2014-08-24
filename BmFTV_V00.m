function BmFTV
% function to test whether the memory load can influence the willness to
% remember(distance judgement) or not



% define cosntant variable


try
    % get basic subinfo
    prompt = {'�������','����','�Ա�[1=��,2=Ů]','����','����[1=������,2=������]'};
    dlg_title = '������Ϣ';
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
    
    %3D����
    Screen('BeginOpenGL',w);
    ar=RectHeight(wRect)/RectWidth(wRect);%��Ļ�߿��
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
    gluPerspective(30, 1/ar, 0.1, 3000);%0.1��1000Ӱ����������õĹ�ϵ�����������1000�Ķ������ᱻ�ų���
    % Setup modelview matrix: This defines the position, orientation and
    % looking direction of the virtual camera:
    glMatrixMode(GL.MODELVIEW);
    glLoadIdentity;
    % Our point lightsource is at position (x,y,z) == (1,2,3)...
    glLightfv(GL.LIGHT0,GL.POSITION,[ 1 2 3 0 ]);%��Դ
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
    % read movie data of real BM
    %leg
    fileform = 'movie\white\leg\*.jpg';
    filepathsrc = 'movie\white\leg\';
    [whiteleg,legFilmwhite]=tinputimgs(w,fileform,filepathsrc);
%     file = dir(fileform);
%     for i = 1:length(file)
%         moviedata{i} = imread([filepathsrc, file(i).name]);
%     end
%     for i=1:60
%         whiteleg{i}=Screen('MakeTexture',w, moviedata{i});
%         legFilmwhite{i}=Screen('Rect', whiteleg{i});
%     end
    
    %jump
    fileform = 'movie\white\jump\*.jpg';
    filepathsrc = 'movie\white\jump\';
    file = dir(fileform);
    for i = 1:length(file)
        moviedata{i} = imread([filepathsrc, file(i).name]);
    end
    for i=1:60
        whitejump{i}=Screen('MakeTexture',w, moviedata{i});
        jumpFilmwhite{i}=Screen('Rect',  whitejump{i});
    end
    
    %run
    fileform = 'movie\white\run\*.jpg';
    filepathsrc = 'movie\white\run\';
    file = dir(fileform);
    for i = 1:length(file)
        moviedata{i} = imread([filepathsrc, file(i).name]);
    end
    for i=1:60
        whiterun{i}=Screen('MakeTexture',w, moviedata{i});
        runFilmwhite{i}=Screen('Rect', whiterun{i});
    end
    
    %turn
    fileform = 'movie\white\turn\*.jpg';
    filepathsrc = 'movie\white\turn\';
    file = dir(fileform);
    for i = 1:length(file)
        moviedata{i} = imread([filepathsrc, file(i).name]);
    end
    for i=1:60
        whiteturn{i}=Screen('MakeTexture',w, moviedata{i});
        turnFilmwhite{i}=Screen('Rect',  whiteturn{i});
    end
    
    %wave
    fileform = 'movie\white\wave\*.jpg';
    filepathsrc = 'movie\white\wave\';
    file = dir(fileform);
    for i = 1:length(file)
        moviedata{i} = imread([filepathsrc, file(i).name]);
    end
    for i=1:60
        whitewave{i}=Screen('MakeTexture',w, moviedata{i});
        waveFilmwhite{i}=Screen('Rect', whitewave{i});
    end
    
     %geo
    fileform = 'movie\white\geo\*.jpg';
    filepathsrc = 'movie\white\geo\';
    file = dir(fileform);
    for i = 1:length(file)
        moviedata{i} = imread([filepathsrc, file(i).name]);
    end
    for i=1:60
        whitegeo{i}=Screen('MakeTexture',w, moviedata{i});
        geoFilmwhite{i}=Screen('Rect', whitegeo{i});
    end
    
    %% make sprites
    act={whiteleg,whitejump,whiterun,whiteturn,whitewave,whitegeo;};
    
    % ����FTV�����˶�����
    %InputIndex=randperm(240); %���� 1~240 ������һ���������
    trackFile=fopen('walking.txt'); %����Ӧ���ļ�
    fileContent = textscan(trackFile, '%s');%��������ʽ��������   %3.1f ��ʾ3���ַ���С�����һλ
    %C = textscan(fid, '%s%s%f32%d8%u%f%f%s%f');���ٸ��ͱ�ʾ���ٸ�һ��
    movie= fileContent{1};%�����ű�ʾԪ�����飬�����ڽṹ
    fclose(trackFile);
    % ��������
    maxdist=163.0;
    factor=4.0;
    distance=0;
    square_width2=5; %�˶�������ش�С
    zoomIndex=5; %ԭ�������������ǱȽ�С�ģ��Ŵ󼸱������֣����Է����ڲ�ͬ��ʵ������
    dotsPerFrame=13;%ÿһ֡һ����13����
    totalFrames=str2double(movie());
    dimver=1118;% һ������������
    dimhor=3; %��ά������
    framesPerCycle=dimver/dotsPerFrame;
    cyclePerTrial=2;
    coordinate=zeros(dimver,dimhor);
    counterSize=1;
    for ver_counter=1:dimver
        for hor_counter=1:dimhor
            coordinate(ver_counter,hor_counter)=totalFrames(counterSize);
            counterSize=counterSize+1;
        end;
    end;
    
    condition = movie_series;
    distanceArray=[7.1 3.5 2.1];
    TrialType=zeros(length(condition));
    for i=1:length(condition)
        TrialType(i)=mod(i-1,3)+1;
    end
    
    %========================================
    % keyboard setup %
    KbName('UnifyKeyNames');
    F = KbName('RIGHTARROW');
    J = KbName('LEFTARROW');
    back = KbName('UPARROW');
    forward = KbName('DOWNARROW');
    confirm =  KbName('Space');
    escapekey = KbName('escape');
    
    %Stimuli setup
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
    overRect = Screen('Rect', over);
    missRect = Screen('Rect', miss);
    practiceRect=Screen('Rect',practiceOver);
    practiceStartRect=Screen('Rect',practiceStart);
    answerRect = Screen('Rect',answer);
    FTVRect = Screen('Rect',FTV);
    FWRect = Screen('Rect',FW);
    baseRect = Screen('Rect',base);
    
    %=====================================================
    % Run experiment
    %=====================================================
    
    HideCursor;
    pos = [a-startRect(3)/2 b-startRect(4)/2 a+startRect(3)/2 b+startRect(4)/2];
    
    %��ϰ�׶�ָ����
    if(mod(subID,2)==1)  %��������
        Screen('TextSize', w, 40);
        Screen('DrawTexture', w,start, [], pos);
        Screen('Flip',w);
        KbWait;
        Screen('Flip',w);
        WaitSecs(2);
        
    else              %ż������
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
    
    % ѧϰ�׶� Զ��
    distance_pra_FA=-maxdist;
    angle_FA=(2.0*atan(factor*maxdist/(2.0*abs(distance_pra_FA))))*180.0/pi;
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
        for i=1:framesPerCycle
            for j=1:dotsPerFrame
                moglDrawDots3D(w,[coordinate((i-1)*dotsPerFrame+j,2) coordinate((i-1)*dotsPerFrame+j,3) coordinate((i-1)*dotsPerFrame+j,1)], square_width2, [255 255 255 255],[],1);
            end
            Screen('Flip',w);
        end
    end
    
    Screen('DrawTexture', w, FW, [], pos);
    Screen('Flip',w);
    KbWait;
    
    % ѧϰ�׶� ����
    distance_pra_FTV=-maxdist*20;
    angle_FTV=(2.0*atan(factor*maxdist/(2.0*abs(distance_pra_FTV))))*180.0/pi;
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
        for i=1:framesPerCycle
            for j=1:dotsPerFrame
                moglDrawDots3D(w,[coordinate((i-1)*dotsPerFrame+j,2) coordinate((i-1)*dotsPerFrame+j,3) coordinate((i-1)*dotsPerFrame+j,1)], square_width2, [255 255 255 255],[],1);
            end
            Screen('Flip',w);
        end
    end
    Screen('DrawTexture', w, FTV, [], pos);
    Screen('Flip',w);
    KbWait;
    
    %��ϰ�׶�
    for trial = 1:24  %24����ϰ
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
        distance=-maxdist*distanceArray(TrialType(str2num(condition{trial}(1))));
        angle=(2.0*atan(factor*maxdist/(2.0*abs(distance))))*180.0/pi;
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
        gluLookAt(0,0,-distance,0,0,0,0,1,0);
        %
        glClearColor(0,0,0,0);
        glClear;
        Screen('EndOpenGL',w);
        for repeat1 = 1:3
            for i=1:framesPerCycle
                for j=1:dotsPerFrame
                    moglDrawDots3D(w,[coordinate((i-1)*dotsPerFrame+j,2) coordinate((i-1)*dotsPerFrame+j,3) coordinate((i-1)*dotsPerFrame+j,1)], square_width2, [255 255 255 255],[],1);
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
            if keycode(back)
                answer_code(trial) = 0;
                break
            end
            if keycode(forward)
                answer_code(trial) = 1;
                break
            end
        end
        if GetSecs - start_time >=2
            answer_code(trial) = 3;%����û�а���
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
        if (xor(mod(subID,2)==1,trial>=12))   %%%%%%%%%%%%%%%%%%%%%%%% ������   �������� ���� tiral������12 �������������е�һ��
            while GetSecs - start_time < 3
                if str2num(condition{trial}(1))==0     %% bm no change 
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
                                if keycode(escapekey)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 3;%���԰����˳�
                                    break
                                end
                                if keycode(F)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 2;
                                    break
                                end
                                if keycode(J)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 1;
                                    break
                                end
                                rtime(trial) = GetSecs - start_time;
                                response_code(trial) = 3;%����û�а���
                               
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
                                if keycode(escapekey)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 3;%���԰����˳�
                                    break
                                end
                                if keycode(F)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 2;
                                    break
                                end
                                if keycode(J)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 1;
                                    break
                                end
                                rtime(trial) = GetSecs - start_time;
                                response_code(trial) = 3;%����û�а���                             
                           end  % end for
                       end % end np
                   end  %end if 
            end %end -while
        else   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%unload ����  ����ˮƽ
             while GetSecs - start_time < 3
                  if str2num(condition{trial}(1))==0 || str2num(condition{trial}(1))==1 %���ۼ������Ƿ�仯
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
                                if keycode(confirm)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 4;
                                    break
                                end
                                rtime(trial) = GetSecs - start_time;
                                response_code(trial) = 3;%����û�а���
                            end %end for  
                        end % end np
                    end %end if
             end %end while
        end % end ��ż���
                    
%                 if keyisdown==1
%                     break
%                 end

        if keycode(escapekey)
            rtime(trial) = GetSecs - start_time;
            response_code(trial) = 3;
            break
        end
        
        if ~((response_code(trial)==str2num(condition{trial}(2))+1)|| (response_code(trial) == 4))
            Screen('DrawTexture', w, miss, [], [a-missRect(3)/2 b-missRect(4)/2 a+missRect(3)/2 b+missRect(4)/2]);  %%�жϷ���
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
        
        %��ϰ�׶���Ϣ--����������Ҫ��ϰ��˳������ʽʵ����ͬ-------------------------------------------------------
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
    
    
    %��ʽʵ��ָ����
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
    
    
    %��ʽʵ��
    task = zeros(192);
    for trial = 1:length(condition)
        
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
        distance=-maxdist*distanceArray(TrialType(str2num(condition{trial}(1))));
        angle=(2.0*atan(factor*maxdist/(2.0*abs(distance))))*180.0/pi;
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
        gluLookAt(0,0,-distance,0,0,0,0,1,0);
        %
        glClearColor(0,0,0,0);
        glClear;
        Screen('EndOpenGL',w);
        for repeat1 = 1:3
            for i=1:framesPerCycle
                for j=1:dotsPerFrame
                    moglDrawDots3D(w,[coordinate((i-1)*dotsPerFrame+j,2) coordinate((i-1)*dotsPerFrame+j,3) coordinate((i-1)*dotsPerFrame+j,1)], square_width2, [255 255 255 255],[],1);
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
            if keycode(back)
                answer_code(trial) = 0;
                break
            end
            if keycode(forward)
                answer_code(trial) = 1;
                break
            end
        end
        if GetSecs - start_time >=2
            answer_code(trial) = 3;%����û�а���
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
        if (xor(mod(subID,2)==1,trial>=12))   %%%%%%%%%%%%%%%%%%%%%%%% ������   �������� ���� tiral������12 �������������е�һ��
            while GetSecs - start_time < 3
                if str2num(condition{trial}(1))==0     %% bm no change 
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
                                if keycode(escapekey)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 3;%���԰����˳�
                                    break
                                end
                                if keycode(F)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 2;
                                    break
                                end
                                if keycode(J)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 1;
                                    break
                                end
                                rtime(trial) = GetSecs - start_time;
                                response_code(trial) = 3;%����û�а���
                               
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
                                if keycode(escapekey)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 3;%���԰����˳�
                                    break
                                end
                                if keycode(F)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 2;
                                    break
                                end
                                if keycode(J)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 1;
                                    break
                                end
                                rtime(trial) = GetSecs - start_time;
                                response_code(trial) = 3;%����û�а���                             
                           end  % end for
                       end % end np
                   end  %end if 
            end %end -while
        else   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%unload ����  ����ˮƽ
             while GetSecs - start_time < 3
                  if str2num(condition{trial}(1))==0 || str2num(condition{trial}(1))==1 %���ۼ������Ƿ�仯
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
                                if keycode(confirm)
                                    flag=1;
                                    rtime(trial) = GetSecs - start_time;
                                    response_code(trial) = 4;
                                    break
                                end
                                rtime(trial) = GetSecs - start_time;
                                response_code(trial) = 3;%����û�а���
                            end %end for  
                        end % end np
                    end %end if
             end %end while
        end % end ��ż���
                    
%                 if keyisdown==1
%                     break
%                 end

        if keycode(escapekey)
            rtime(trial) = GetSecs - start_time;
            response_code(trial) = 3;
            break
        end
        
        if ~((response_code(trial)==str2num(condition{trial}(2))+1)|| (response_code(trial) == 4))
            Screen('DrawTexture', w, miss, [], [a-missRect(3)/2 b-missRect(4)/2 a+missRect(3)/2 b+missRect(4)/2]);  %%�жϷ���
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
        
        %��Ϣ-------------------------------------------------------
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
        fprintf(fid,'%s\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%4.3f\t%3.3f\t%4.0f\t%3.0f\t%3.0f\n', name,subID,sex,age,j,str2num(condition{j}(1)),str2num(condition{j}(3)),response_code(j)==str2num(condition{j}(3))+1,rtime(j),TrialType(str2num(condition{j}(2))),answer_code(j),task(j));
    end
    fclose(fid);
    clear all
catch
    
    Screen('Closeall')
    rethrow(lasterror)
    clear all
end

function output = movie_series
    %1-setsize 4 ɾ��
    %2-�����̼����� 1,2,3
    %3-change 0,1
    code_series = {'10','11','20','21','30','31'};
    code_series = repmat(code_series,1,32);
    output = GenerateSequence(code_series,48);
end

function ReturnArray = GenerateSequence(DataArray,ranBlock)
Num = length(DataArray);
for i = 0:(Num / ranBlock - 1)
    nFlag = 0;
    while nFlag == 0
        DataArray = Shuffle(DataArray,(i * ranBlock + 1),((i + 1) * ranBlock));
        if i==0
            for j = 1:(ranBlock - 3)
                if (strcmp(DataArray{i * ranBlock + j}(1), DataArray{i * ranBlock + j + 1}(1))& ...
                        strcmp(DataArray{i * ranBlock + j + 1}(1), DataArray{i * ranBlock + j + 2}(1)) & ...
                        strcmp(DataArray{i * ranBlock + j + 2}(1), DataArray{i * ranBlock + j + 3}(1))) |...
                        (strcmp(DataArray{i * ranBlock + j}(2), DataArray{i * ranBlock + j + 1}(2))& ...
                        strcmp(DataArray{i * ranBlock + j + 1}(2), DataArray{i * ranBlock + j + 2}(2)) & ...
                        strcmp(DataArray{i * ranBlock + j + 2}(2), DataArray{i * ranBlock + j + 3}(2)))
                    nFlag = 0;
                    break;
                else
                    nFlag = 1;
                end % end if
            end % j loop
        end % end if
        if i>0
            for j = -2:(ranBlock - 3)
                if (strcmp(DataArray{i * ranBlock + j}(1), DataArray{i * ranBlock + j + 1}(1))& ...
                        strcmp(DataArray{i * ranBlock + j + 1}(1), DataArray{i * ranBlock + j + 2}(1)) & ...
                        strcmp(DataArray{i * ranBlock + j + 2}(1), DataArray{i * ranBlock + j + 3}(1))) |...
                        (strcmp(DataArray{i * ranBlock + j}(2), DataArray{i * ranBlock + j + 1}(2))& ...
                        strcmp(DataArray{i * ranBlock + j + 1}(2), DataArray{i * ranBlock + j + 2}(2)) & ...
                        strcmp(DataArray{i * ranBlock + j + 2}(2), DataArray{i * ranBlock + j + 3}(2)))
                    nFlag = 0;
                    break;
                else
                    nFlag = 1;
                end % end if
            end % j loop
        end % end if
    end % end while
end % i loop

ReturnArray = DataArray;
%%

function ReturnArray = Shuffle(DataArray,FirstIndex,LastIndex)
Num = LastIndex - FirstIndex + 1;
ReturnArray = DataArray;
Order = randperm(Num)-1;
for i = 0:(Num-1)
    ReturnArray(FirstIndex+i) = DataArray(FirstIndex+Order(i+1));
end
%---------------------------------------------------------------

