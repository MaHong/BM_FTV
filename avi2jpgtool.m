a = 10;

inputvediopath = 'C:\Users\Administrator\Desktop\cheer.avi';
currentvideo = mmreader(inputvediopath);

numframes = currentvideo.NumberOfFrames;
vidHeight = 240; 
vidWidth = 320;
outputfolder = 'E:\03-ÊµÑé³ÌÐò\Mine\github\BM_FTV.V5\movie\white\cheer\';

currentframe = struct('cdata', zeros(vidHeight, vidWidth, 3, 'double'),...
           'colormap', []);

numframes = currentvideo.NumberOfFrames;

for k=1:numframes
    currentframe.cdata = read(currentvideo,k);
    jpgfilename = '';
    if k<10
        jpgfilename =  strcat(outputfolder,'0',num2str(k),'.jpg');
        
    else
        jpgfilename =  strcat(outputfolder,num2str(k),'.jpg');
    end
    
    imwrite(  currentframe.cdata,jpgfilename,'jpg');
end




