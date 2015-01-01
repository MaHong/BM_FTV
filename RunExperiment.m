function [answer_code,rtime,response_code,tasktype]= RunExperiment(w,wRect,tiralnum,frame_duration,...
    NumTotalMoivePool,NumSelectedMovie,MovieCntre,act,ftvparas,inssetup,pos,keysetup,...
    subID,MovieFrames,a,b,resttrial,experimenttype,image)
% practice
%@tiralnum = 24
%@resttrial = 12
%@experimenttype = 1
trialtype = 1;
%@image = inssetup.practiceOver

% formal
%@tiralnum = length(ftvparas.condition)
%@resttrial = 48
%@experimenttype = 2
experimenttype = 2;
%@image = inssetup.over

tasktype = zeros(tiralnum);
for trial = 1:tiralnum
    InitializeMatlabOpenGL;
    
    % fixation300ms
    Screen('FillRect', w, [0,0,0]);
    Screen('DrawText',w, '+',a ,b,[255,0,0]);
    Screen('Flip',w);
    StimulasInterval (w,0.3,frame_duration);
    
    % define the position of the memory display
    position_index = randperm(NumSelectedMovie);% Randomized the positions
    position_presentation = zeros(NumSelectedMovie,2);% 5*2 zero vector
    for i=1:NumSelectedMovie
        position_presentation(i,1) = MovieCntre(position_index(i),1);
        position_presentation(i,2) = MovieCntre(position_index(i),2);
    end
    
    %display the memory array
    InputNameIndex = randperm(NumTotalMoivePool); % the number of the file is 8
    PostionShuffleIndex = randperm(NumSelectedMovie);

    actionreapettimes = 3;
    for rp=1:actionreapettimes
        for i=1:MovieFrames
            for np=1:NumSelectedMovie
                Screen('DrawTexture',w,act{InputNameIndex(np)}{i},[],...
                    [position_presentation(PostionShuffleIndex(np),1)-110 ...
                    position_presentation(PostionShuffleIndex(np),2)-90 ...
                    position_presentation(PostionShuffleIndex(np),1)+110 ...
                    position_presentation(PostionShuffleIndex(np),2)+90]);
            end
            Screen('Flip',w);
        end
    end
    
    StimulasInterval (w,0.3,frame_duration);
    
    clearinputkeyqueue;
    % show the distance judgement part 
    DisplayPLWalker(w,wRect,ftvparas,ftvparas.distanceArray(ftvparas.TrialType(str2num(ftvparas.condition{trial}(1)))), 3000)
    % get the FTV/W judgement
    [answer_codeval] = GetFTVJudgementResponse(w,inssetup,pos,keysetup);
    answer_code(trial) = answer_codeval;
    
    clearinputkeyqueue;
    % show the bm memory test array
    start_time=GetSecs;
        if(     ( experimenttype==trialtype&&(xor(mod(subID,2)==1,trial>=resttrial)) )||...
            ( experimenttype==experimenttype&&(xor(mod(subID,2)==1,(trial>resttrial&&trial<=resttrial*3)  )) ) )
        while GetSecs - start_time < 3
            if str2num(ftvparas.condition{trial}(2))==0     %% bm no change
                [rtimeval,response_codeval,terminateflag] = GetBMtestResponse(w,MovieFrames,act,InputNameIndex,a,b,keysetup,1);
                rtime(trial) = rtimeval;
                response_code(trial)=response_codeval;
                if terminateflag==1
                    break;
                end
            else                                   %% bm change
                [rtimeval,response_codeval,terminateflag] = GetBMtestResponse(w,MovieFrames,act,InputNameIndex,a,b,keysetup,(NumSelectedMovie+1) );
                rtime(trial) = rtimeval;
                response_code(trial) = response_codeval;
                if terminateflag==1
                    break;
                end
            end  %end if
        end %end -while
        tasktype(trial) = 1;%记忆任务
    else   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%unload 条件  基线水平
        while GetSecs - start_time < 3
            [rtimeval,response_codeval,terminateflag] =  GetBaseResponse(w,trial,ftvparas,act,MovieFrames,InputNameIndex,a,b,keysetup);
            rtime(trial) = rtimeval;
            response_code(trial)=response_codeval;
            if terminateflag==1
                break;
            end
        end
         tasktype(trial) = 0;%控制条件
    end
    
    [keyisdown,secs,keycode] = KbCheck;
    if keycode(keysetup.escapekey)
        rtime(trial) = GetSecs - start_time;
        response_code(trial) = 3;
        break
    end
    
    if ~(  (response_code(trial)==str2num(ftvparas.condition{trial}(2))+1)|| (response_code(trial) == 4)  )
        PushImages(w,pos,inssetup.miss);
        WaitSecs(0.2);
    end
    Screen('Flip',w);
    
    clearinputkeyqueue;
    StimulasInterval (w,1,frame_duration)
    
    %rest
    if (mod(trial,resttrial)==0 && trial~=tiralnum)
        PushImages(w,pos,inssetup.rest);
        clearinputkeyqueue;
        KbWait;
        WaitSecs(2);
        Screen('Flip',w);
        
        % begin the instructionimg for the other block
        checkcondition = ( experimenttype==trialtype&&(mod(subID,2)==1) )||...
            ( experimenttype==experimenttype&&(xor(mod(subID,2)==1, trial==144)) ) ;
        ShowInstruction(w,inssetup.basetwo,inssetup.starttwo,pos,checkcondition );
 
    end
end

clearinputkeyqueue;
PushImages(w,pos,image)
KbWait;
Screen('Flip',w);
WaitSecs(2);
end