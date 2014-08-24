function ReturnArray = GenerateSequence(DataArray,ranBlock)
Num = length(DataArray);
for i = 0:(Num / ranBlock - 1)
    nFlag = 0;
    while nFlag == 0
        DataArray = Shuffle(DataArray,(i * ranBlock + 1),((i + 1) * ranBlock));
        if i==0
            for j = 1:(ranBlock - 3)
                if (strcmp(DataArray{i * ranBlock + j}(1), DataArray{i * ranBlock + j + 1}(1))& ...
                        strcmp(DataArray{i * ranBlock + j + 1}(1), DataArray{i * ranBlock + j + 2}(1)) & ...
                        strcmp(DataArray{i * ranBlock + j + 2}(1), DataArray{i * ranBlock + j + 3}(1))) |...
                        (strcmp(DataArray{i * ranBlock + j}(2), DataArray{i * ranBlock + j + 1}(2))& ...
                        strcmp(DataArray{i * ranBlock + j + 1}(2), DataArray{i * ranBlock + j + 2}(2)) & ...
                        strcmp(DataArray{i * ranBlock + j + 2}(2), DataArray{i * ranBlock + j + 3}(2)))
                    nFlag = 0;
                    break;
                else
                    nFlag = 1;
                end % end if
            end % j loop
        end % end if
        if i>0
            for j = -2:(ranBlock - 3)
                if (strcmp(DataArray{i * ranBlock + j}(1), DataArray{i * ranBlock + j + 1}(1))& ...
                        strcmp(DataArray{i * ranBlock + j + 1}(1), DataArray{i * ranBlock + j + 2}(1)) & ...
                        strcmp(DataArray{i * ranBlock + j + 2}(1), DataArray{i * ranBlock + j + 3}(1))) |...
                        (strcmp(DataArray{i * ranBlock + j}(2), DataArray{i * ranBlock + j + 1}(2))& ...
                        strcmp(DataArray{i * ranBlock + j + 1}(2), DataArray{i * ranBlock + j + 2}(2)) & ...
                        strcmp(DataArray{i * ranBlock + j + 2}(2), DataArray{i * ranBlock + j + 3}(2)))
                    nFlag = 0;
                    break;
                else
                    nFlag = 1;
                end % end if
            end % j loop
        end % end if
    end % end while
end % i loop

ReturnArray = DataArray;
%%

end