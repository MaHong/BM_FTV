function ShowInstruction(w,instructimg0,instructimg1,pos,checkcondition)
%show the instruction which is different by subID 

%@ checkcondition = mod(subID,2)==1
%@ instructimg0 = inssetup.start
%@ instructimg1 = inssetup.base

%@ checkcondition = ( experimenttype==trialtype&&(mod(subID,2)==1) )||...
%                   ( experimenttype==experimenttype&&(xor(mod(subID,2)==1, trial==144)) ) 
%@ instructimg0 = inssetup.basetwo
%@ instructimg1 = inssetup.starttwo



 if(checkcondition)  %奇数被试
        %Screen('TextSize', w, 40);
        PushImages(w,pos,instructimg0)
        KbWait;
        Screen('Flip',w);
        WaitSecs(2);
        
    else              %偶数被试
        %Screen('TextSize', w, 40);
        PushImages(w,pos,instructimg1)
        KbWait;
        Screen('Flip',w);
        WaitSecs(2);
    end

end