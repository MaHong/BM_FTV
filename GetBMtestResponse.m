function [rtimevalue,response_codevalue] = GetBMtestResponse(w,flag,start_time,MovieFrames,act,InputNameIndex,a,b,...
    keysetup)
% get the keyresponse of BM test array

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
            rtimevalue = GetSecs - start_time;
            response_codevalue = 3;%被试按键退出
            break
        end
        if keycode(keysetup.F)
            flag=1;
            rtimevalue = GetSecs - start_time;
            response_codevalue = 2;
            break
        end
        if keycode(keysetup.J)
            flag=1;
            rtimevalue = GetSecs - start_time;
            response_codevalue = 1;
            break
        end
        rtimevalue = GetSecs - start_time;
        response_codevalue = 3;%被试没有按键
    end
end
end