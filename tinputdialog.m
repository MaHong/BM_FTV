function [subID, name, sex, age] = tinputdialog
% get basic subinfo
    prompt = {'�������','����','�Ա�[1=��,2=Ů]','����','����[1=������,2=������]'};
    dlg_title = '������Ϣ';
    num_lines = 1;
    defaultanswer = {'','','1','20','1'};
    subinfo = inputdlg(prompt,dlg_title,num_lines,defaultanswer);
    subID = str2num([subinfo{1}]);
    name= [subinfo{2}];
    sex = str2num([subinfo{3}]);
    age = str2num([subinfo{4}]);
end