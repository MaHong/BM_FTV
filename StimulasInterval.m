function StimulasInterval (w,intervalsecs,frame_duration)
% Show a blank screen between stimulas
start_time=GetSecs;
while GetSecs - start_time<intervalsecs-frame_duration
end
Screen('Flip',w);
end