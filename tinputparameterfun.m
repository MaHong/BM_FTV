
function ParamStruct = tinputparameterfun(ftvfilename)
    % ftvfilename = 'walking.txt'
    % 读入FTV生物运动数据
    %InputIndex=randperm(240); %返回 1~240 整数的一个随机排列
    trackFile=fopen(ftvfilename); %打开相应的文件
    fileContent = textscan(trackFile, '%s');%以数组形式读入数据   %3.1f 表示3个字符宽，小数点后一位
    %C = textscan(fid, '%s%s%f32%d8%u%f%f%s%f');多少个就表示多少个一列
    movie= fileContent{1};%大括号表示元胞数组，类似于结构
    fclose(trackFile);
    % 参数设置
    maxdist=163.0;
    factor=4.0;
    distance=0;
    square_width2=5; %运动点的像素大小
    % zoomIndex=5; %原来点的坐标可能是比较小的，放大几倍来呈现，可以方便在不同的实验中用
    dotsPerFrame=13;%每一帧一共有13个点
    totalFrames=str2double(movie());
    dimver=1118;% 一共多少行数据
    dimhor=3; %三维的坐标
    framesPerCycle=dimver/dotsPerFrame;

    coordinate=zeros(dimver,dimhor);
    counterSize=1;
    for ver_counter=1:dimver
        for hor_counter=1:dimhor
            coordinate(ver_counter,hor_counter)=totalFrames(counterSize);
            counterSize=counterSize+1;
        end;
    end;
    
    condition = movie_series;
    distanceArray=[7.1 3.5 2.1];
    TrialType=zeros(length(condition));
    for i=1:length(condition)
        TrialType(i)=mod(i-1,3)+1;
    end

    ParamStruct.maxdist = maxdist;
    ParamStruct.factor = factor;
    ParamStruct.distance = distance;
    ParamStruct.square_width2 = square_width2;

    ParamStruct.dotsPerFrame = dotsPerFrame;
    ParamStruct.totalFrames = totalFrames;
    ParamStruct.dimver = dimver;
    ParamStruct.framesPerCycle = framesPerCycle;
    ParamStruct.coordinate = coordinate;

    ParamStruct.condition = condition;
    ParamStruct.distanceArray =distanceArray;
    ParamStruct.TrialType = TrialType;
end