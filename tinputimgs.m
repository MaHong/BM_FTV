function [actiontexture, actionfile] = tinputimgs( w, flieregx, filesdir )
    file = dir(flieregx);
    for i = 1:length(file)
        moviedata{i} = imread([filesdir, file(i).name]);
    end
    for i=1:60
        actiontexture{i}=Screen('MakeTexture',w, moviedata{i});
        actionfile{i}=Screen('Rect', actiontexture{i});
    end
end


