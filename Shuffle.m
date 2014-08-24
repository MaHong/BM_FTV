function ReturnArray = Shuffle(DataArray,FirstIndex,LastIndex)
Num = LastIndex - FirstIndex + 1;
ReturnArray = DataArray;
Order = randperm(Num)-1;
for i = 0:(Num-1)
    ReturnArray(FirstIndex+i) = DataArray(FirstIndex+Order(i+1));
end
%---------------------------------------------------------------
end