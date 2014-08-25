function [rtimevalue,response_codevalue,flag] =  GetBaseResponse(w,trial,ftvparas,act,MovieFrames,InputNameIndex,a,b,keysetup)

flag = 0;
start_time = GetSecs;
while GetSecs - start_time < 3
    if str2num(ftvparas.condition{trial}(2))==0 || str2num(ftvparas.condition{trial}(2))==1 %无论记忆项是否变化
        for np=1:3
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
                if keycode(keysetup.confirm)
                    flag=1;
                    rtimevalue = GetSecs - start_time;
                    response_codevalue = 4;
                    break
                end
                rtimevalue = GetSecs - start_time;
                response_codevalue = 3;%被试没有按键
            end %end for
        end % end np
    end %end if
end %end while
end