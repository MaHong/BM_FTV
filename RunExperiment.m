function [answer_code,rtime,response_code]= RunExperiment(w,wRect,tiralnum,frame_duration,...
    NumSplit,MovieCntre,act,ftvparas,inssetup,pos,keysetup,...
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

for trial = 1:tiralnum
    InitializeMatlabOpenGL;
    
    % fixation300ms
    % showfocuscross
    Screen('FillRect', w, [0,0,0]);
    Screen('DrawText',w, '+',a ,b,[255,0,0]);
    Screen('Flip',w);
    % waitperiod( frame_duration )
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
    position_presentation = zeros(NumSplit,2);% 6*2 zero vector
    for i=1:NumSplit
        position_presentation(i,1) = MovieCntre(position_index(i),1);
        position_presentation(i,2) = MovieCntre(position_index(i),2);
    end
    
    %display the memory array
    InputNameIndex = randperm(NumSplit); %random the stimuli
    NumMovie=4;
    actionreapettimes = 4;
    for rp=1:actionreapettimes
        for i=1:MovieFrames
            for np=1:NumMovie                
                Screen('DrawTexture',w,act{InputNameIndex(np)}{i},[],...
                    [position_presentation(InputNameIndex(np),1)-110 ...
                     position_presentation(InputNameIndex(np),2)-90 ...
                     position_presentation(InputNameIndex(np),1)+110 ...
                     position_presentation(InputNameIndex(np),2)+90]);
            end
            Screen('Flip',w);
        end
    end
    
    % Show the blank interval between memory and test array
    % TODO wrap the code into a showblackscreen( seconds )
    Screen('Flip',w);
    start_time=GetSecs;
    while GetSecs - start_time<0.3-frame_duration
    end
    
    clearinputkeyqueue;
    
    %%% show the distance judgement part  abc %%%
    learnningproc(w,wRect,ftvparas,ftvparas.distanceArray(ftvparas.TrialType(str2num(ftvparas.condition{trial}(1)))), 3000)
    
    
    % get the FTV/W judgement
    [answer_codeval] = GetFTVJudgementResponse(w,inssetup,pos,keysetup);
    answer_code(trial) = answer_codeval;
    
    %
    clearinputkeyqueue
    
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
                [rtimeval,response_codeval] = GetBMtestResponse(w,MovieFrames,act,InputNameIndex,a,b,keysetup,(NumMovie+1) );
                rtime(trial) = rtimeval;
                response_code(trial)=response_codeval;
                if terminateflag==1
                    break;
                end
            end  %end if
        end %end -while
    else   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%unload 条件  基线水平
        [rtimeval,response_codeval,terminateflag] =  GetBaseResponse(w,trial,ftvparas,act,MovieFrames,InputNameIndex,a,b,keysetup);
        rtime(trial) = rtimeval;
        response_code(trial)=response_codeval;
        if terminateflag==1
            break;
        end
    end
    
    
    %clearinputkeyqueue;
    [keyisdown,secs,keycode] = KbCheck;
    if keycode(keysetup.escapekey)
        rtime(trial) = GetSecs - start_time;
        response_code(trial) = 3;
        break
    end
    
    if ~((response_code(trial)==str2num(ftvparas.condition{trial}(2))+1)|| (response_code(trial) == 4))
        Screen('DrawTexture', w, inssetup.miss, [], [a-inssetup.missRect(3)/2 b-inssetup.missRect(4)/2 a+inssetup.missRect(3)/2 b+inssetup.missRect(4)/2]);  %%判断反馈
        Screen('Flip',w);
        WaitSecs(0.2);
    end
    Screen('Flip',w);
    
    keyisdown = 1;
    while(keyisdown) % first wait until all keys are released
        [keyisdown,secs,keycode] = KbCheck;
        WaitSecs(0.001); % delay to prevent CPU hogging
    end
    Screen('Flip',w);
    start_time=GetSecs;
    while GetSecs - start_time<1-frame_duration
    end
    
    %rest
    if (mod(trial,resttrial)==0 && trial~=tiralnum)
        Screen('DrawTexture', w, inssetup.rest, [], [a-inssetup.restRect(3)/2 b-inssetup.restRect(4)/2 a+inssetup.restRect(3)/2 b+inssetup.restRect(4)/2]);
        Screen('Flip',w);
        keyisdown = 1;
        while(keyisdown) % first wait until all keys are released
            [keyisdown,secs,keycode] = KbCheck;
            WaitSecs(0.001); % delay to prevent CPU hogging
        end
        KbWait;
        WaitSecs(2);
        Screen('Flip',w);
        
        % begin the instructionimg for the other block
        checkcondition = ( experimenttype==trialtype&&(mod(subID,2)==1) )||...
            ( experimenttype==experimenttype&&(xor(mod(subID,2)==1, trial==144)) ) ;
        ShowInstruction(w,inssetup.basetwo,inssetup.starttwo,pos,checkcondition );
        
        
    end
end

Screen('TextSize', w, 40);
Screen('DrawTexture', w, image, [], pos);
Screen('Flip',w);
KbWait;
Screen('Flip',w);
WaitSecs(2);
end