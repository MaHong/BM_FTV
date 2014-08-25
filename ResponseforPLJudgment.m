function ResponseforPLJudgment(rightkey)
% give the right response for the  FA/FTV judgement
%%FA
%@rightkey = keysetup.back
%%FTV
%@rightkey = keysetup.forward

while(1)
    [keyisdown,secs,keycode] = KbCheck;
    if keycode(rightkey)
        break
    end
end

end