function InstructionSet = tinstructionsetup(w)
     %instruction setup
    start_img = imread('pic\start.jpg');
    starttwo_img = imread('pic\start2.jpg');
    rest_img = imread('pic\wait.jpg');
    over_img = imread('pic\over.jpg');
    miss_img = imread('pic\miss.jpg');
    practiceOver_img = imread('pic\prac_over.jpg');
    practiceStart_img = imread('pic\prac_start.jpg');
    answer_img = imread('pic\answer.jpg');
    FTV_img = imread('pic\tutorial_FTV.jpg');
    FW_img = imread('pic\tutorial_FW.jpg');
    base_img = imread('pic\base.jpg');
    basetwo_img = imread('pic\base2.jpg');
    
    InstructionSet.starttwo = Screen('MakeTexture',w,starttwo_img);
    InstructionSet.start = Screen('MakeTexture',w,start_img);
    InstructionSet.rest = Screen('MakeTexture',w,rest_img);
    InstructionSet.over = Screen('MakeTexture',w,over_img);
    InstructionSet.miss = Screen('MakeTexture',w,miss_img);
    InstructionSet.practiceOver = Screen('MakeTexture',w, practiceOver_img);
    InstructionSet.practiceStart = Screen('MakeTexture',w, practiceStart_img);
    InstructionSet.answer = Screen('MakeTexture',w,answer_img);
    InstructionSet.FTV = Screen('MakeTexture',w,FTV_img);
    InstructionSet.FW = Screen('MakeTexture',w,FW_img);
    InstructionSet.base = Screen('MakeTexture',w,base_img);
    InstructionSet.basetwo = Screen('MakeTexture',w,basetwo_img);
    
    InstructionSet.startRect = Screen('Rect', InstructionSet.start);
    InstructionSet.restRect = Screen('Rect', InstructionSet.rest);
    InstructionSet.missRect = Screen('Rect', InstructionSet.miss);
    
 
end