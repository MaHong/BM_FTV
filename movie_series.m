function output = movie_series
    %1-Ç÷½ü´Ì¼¤ÀàĞÍ 1,2,3
    %2-change 0,1
    code_series = {'10','11','20','21','30','31'};
    code_series = repmat(code_series,1,32);
    output = GenerateSequence(code_series,48);
end