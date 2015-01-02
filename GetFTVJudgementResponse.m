function [answer_codevalue,rtime_FTV_value] = GetFTVJudgementResponse(w,inssetup,pos,keysetup)
% get the subject's response of the FTV distance judgement part
start_time=GetSecs;
while GetSecs - start_time < 2
    %Screen('TextSize', w, 40); %set the font size, here mainly for the size of the question mark
    Screen('DrawTexture', w, inssetup.answer, [], pos);
    Screen('Flip',w);
    [keyisdown,secs,keycode] = KbCheck;
    WaitSecs(0.001); % delay to prevent CPU hogging
    if keycode(keysetup.back)
        rtime_FTV_value = GetSecs - start_time;
        answer_codevalue = 0;
        break
    end
    if keycode(keysetup.forward)
        rtime_FTV_value = GetSecs - start_time;
        answer_codevalue = 1;
        break
    end
end
if GetSecs - start_time >=2
    answer_codevalue = 3;%����û�а���
    rtime_FTV_value = GetSecs - start_time;
end;

end