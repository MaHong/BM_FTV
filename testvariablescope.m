function testvariablescope(flag)
    for i=1:3
        if flag==1
            break;
        end
        for j=1:4
            if j==3
                flag = 1;
                break;
            end
            
            j
        end
            
    end
end