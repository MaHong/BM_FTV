
function ParamStruct = tinputparameterfun(ftvfilename)
    % ftvfilename = 'walking.txt'
    % ����FTV�����˶�����
    %InputIndex=randperm(240); %���� 1~240 ������һ���������
    trackFile=fopen(ftvfilename); %����Ӧ���ļ�
    fileContent = textscan(trackFile, '%s');%��������ʽ��������   %3.1f ��ʾ3���ַ���С�����һλ
    %C = textscan(fid, '%s%s%f32%d8%u%f%f%s%f');���ٸ��ͱ�ʾ���ٸ�һ��
    movie= fileContent{1};%�����ű�ʾԪ�����飬�����ڽṹ
    fclose(trackFile);
    % ��������
    maxdist=163.0;
    factor=4.0;
    distance=0;
    square_width2=5; %�˶�������ش�С
    % zoomIndex=5; %ԭ�������������ǱȽ�С�ģ��Ŵ󼸱������֣����Է����ڲ�ͬ��ʵ������
    dotsPerFrame=13;%ÿһ֡һ����13����
    totalFrames=str2double(movie());
    dimver=1118;% һ������������
    dimhor=3; %��ά������
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