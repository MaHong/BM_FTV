function BmFTV
% Test whether the memory load will influence FTA/FA judgement
try
    % get basic subinfo
    [subID, name, sex, age] = tinputdialog;
            
    %Screen setup %
    clear InputName MovieData
    AssertOpenGL;
    InitializeMatlabOpenGL;
    PsychImaging('PrepareConfiguration');
    Screen('Preference', 'SkipSyncTests', 1);
    screenNumber=max(Screen('Screens'));
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0);
    %[w, wRect]=Screen('OpenWindow',screenNumber, 0,[],32,2);
    frame_duration = Screen('GetFlipInterval',w);
    %frame = round(1/frame_duration);
    Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    MovieFrames =60;
    [a,b]=WindowCenter(w);
    
    %3D set up
    threedparametersetupfun(w,wRect);
        
    % Screen priority
    priorityLevel=MaxPriority(w);
    Priority(priorityLevel);
    
    % coordinates
    cm2pixel = 30; %convert centimeter to pixel
    % Rcircle=6 * cm2pixel; %the visual degress of the radius of the circle is 4 degree, which equal to 4.88 cm (distance to  the screen 70 cm)
    spaceofstimulus = 9;
    Rcircle=spaceofstimulus * cm2pixel;
    % positions
    n=1;
    NumSelectedMovie=5;
    NumTotalMoivePool = 10;
    PerDegree= (360/NumSelectedMovie)/180 * pi;%Convert to Pi
    for i=1:NumSelectedMovie
        MovieCntre(n,:) = [a+Rcircle*cos(i*PerDegree)   b+Rcircle*sin(i*PerDegree)];
        n=n+1;
    end
    keysetup = tkeyboardsetup;
    inssetup = tinstructionsetup(w);
    
    %input file==================================
    whitepath = 'movie\white\';
    imgformatsuffix = '*.jpg';
    folderlist = {'leg','jump','run','turn','wave','geo','shotting','boxing','blue','green'};
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
            
    % make sprites
    act=whiteactionlist;
    
    % 读入FTV生物运动数据
    ftvparas = tinputparameterfun('walking.txt');
    %End input file================================== 
    
    % Run experiment==================================
    HideCursor;
    pos = [(a-inssetup.startRect(3)/2) b-inssetup.startRect(4)/2 a+inssetup.startRect(3)/2 b+inssetup.startRect(4)/2];
    
    %练习阶段指导语
    ShowInstruction(w,inssetup.start,inssetup.base,pos, mod(subID,2)==1);
    
    %学习FTV/FA
    DisplayPLWalker(w,wRect,ftvparas,1,3000);
    PushImages(w,pos,inssetup.FW);
    ResponseforPLJudgment(keysetup.back);
    DisplayPLWalker(w,wRect,ftvparas,20,4000);
    PushImages(w,pos,inssetup.FTV);
    ResponseforPLJudgment(keysetup.forward);
    
    %练习阶段
    PushImages(w,pos,inssetup.practiceStart);
    WaitSecs(1.5);
    StimulasInterval (w,1,frame_duration);
    RunExperiment(w,wRect,24,frame_duration,...
    NumTotalMoivePool,NumSelectedMovie,MovieCntre,act,ftvparas,inssetup,pos,...
    keysetup,subID,MovieFrames,a,b,12,1,inssetup.practiceOver);

    %正式实验
    ShowInstruction(w,inssetup.start,inssetup.base,pos, mod(subID,2)==1);
    [answer_code,rtime,response_code,tasktype] = RunExperiment(w,wRect,length(ftvparas.condition),frame_duration,...
    NumTotalMoivePool,NumSelectedMovie,MovieCntre,act,ftvparas,inssetup,pos,...
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
    for j = 1:length(response_code)
        fprintf(fid,'%s\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%4.4f\t%3.0f\t%3.0f\t%3.0f\n',...
        name,subID,sex,age,j,str2num(ftvparas.condition{j}(2)),response_code(j)==str2num(ftvparas.condition{j}(2))+1,...
        rtime(j),ftvparas.TrialType(str2num(ftvparas.condition{j}(1))),answer_code(j),tasktype(j));
    end
    fclose(fid);
    clear all
catch
    
    Screen('Closeall')
    rethrow(lasterror)
    clear all
end





