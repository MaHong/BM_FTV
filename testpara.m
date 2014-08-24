%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test return value assignment

% case 1 assigned in the function
% function [trial0,trial1]=ttesttrial()
% trial0 = 1;
% trial1 = 2;
% end

% case 2 not assigned in the function will cause a not assignment runtime
% error
% function [trial0,trial1]=ttesttrial()

% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test function parameter using reference

function testpara( parstructinput )
    parstructinput.x;
    parstructinput.y = 10;
    parstructinput.z = 11;
    parstructinput
end




