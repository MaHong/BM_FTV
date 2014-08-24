myvideo=mmreader('m11.avi');
get(myvideo);
nFrames = myvideo.NumberOfFrames;
vidHeight = 240;
vidWidth = 320;
% Preallocate movie structure.
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'double'),...
           'colormap', []);
% Read one frame at a time.
for k = 1 : nFrames
    mov(k).cdata = read(myvideo, k);
    J=mov(k).cdata;
    switch k
        case 1
    imwrite(J,strcat('C:\Users\dingding\Desktop\movie\','01','.jpg'),'jpg');
        case 2
    imwrite(J,strcat('C:\Users\dingding\Desktop\movie\','02','.jpg'),'jpg');
        case 3
    imwrite(J,strcat('C:\Users\dingding\Desktop\movie\','03','.jpg'),'jpg');
        case 4
    imwrite(J,strcat('C:\Users\dingding\Desktop\movie\','04','.jpg'),'jpg');
        case 5
    imwrite(J,strcat('C:\Users\dingding\Desktop\movie\','05','.jpg'),'jpg');
        case 6
    imwrite(J,strcat('C:\Users\dingding\Desktop\movie\','06','.jpg'),'jpg');
        case 7
    imwrite(J,strcat('C:\Users\dingding\Desktop\movie\','07','.jpg'),'jpg');
        case 8
    imwrite(J,strcat('C:\Users\dingding\Desktop\movie\','08','.jpg'),'jpg');
        case 9
    imwrite(J,strcat('C:\Users\dingding\Desktop\movie\','09','.jpg'),'jpg');
        otherwise
    imwrite(J,strcat('C:\Users\dingding\Desktop\movie\',int2str(k),'.jpg'),'jpg');   
    end
end

% Size a figure based on the video's width and height.

% Play back the movie once at the video's frame rate.