function [subID, name, sex, age] = tinputdialog
% get basic subinfo
    prompt = {'被试序号','姓名','性别[1=男,2=女]','年龄','利手[1=右利手,2=左利手]'};
    dlg_title = '被试信息';
    num_lines = 1;
    defaultanswer = {'','','1','20','1'};
    subinfo = inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    subID = str2num([subinfo{1}]);
    name= [subinfo{2}];
    sex = str2num([subinfo{3}]);
    age = str2num([subinfo{4}]);
end