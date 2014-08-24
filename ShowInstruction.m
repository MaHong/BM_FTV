function ShowInstruction(w,instructimg0,instructimg1,pos,checkcondition)
%show the instruction which is different by subID 

%@ checkcondition = mod(subID,2)==1
%@ instructimg0 = inssetup.start
%@ instructimg1 = inssetup.base

%@ checkcondition = ( experimenttype==trialtype&&(mod(subID,2)==1) )||...
%                   ( experimenttype==experimenttype&&(xor(mod(subID,2)==1, trial==144)) ) 
%@ instructimg0 = inssetup.basetwo
%@ instructimg1 = inssetup.starttwo



 if(checkcondition)  %��������
        Screen('TextSize', w, 40);
        Screen('DrawTexture', w,instructimg0, [], pos);
        Screen('Flip',w);
        KbWait;
        Screen('Flip',w);
        WaitSecs(2);
        
    else              %ż������
        Screen('TextSize', w, 40);
        Screen('DrawTexture', w,instructimg1,[], pos);
        Screen('Flip',w);
        KbWait;
        Screen('Flip',w);
        WaitSecs(2);
    end

end