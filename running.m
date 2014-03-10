clear all;
clc;
gaodu1 = [];
i1 = [];
j1 = [];
k1 = [];
maxDelay = 16;
for i = 40:1:55
    i1 = [i1 i];
    minH = 15000;
    startT = maxDelay - 2;
    if (startT < 0 )
        startT = 0;
    end
  for j= startT:1:20
    [jiaodu, gaodu] = missile1(4, 0.1, 0, j,20000, i);
  
    if (jiaodu > 40) 
        break;
    else 
          maxDelay = j;
        if minH > gaodu
            minH = gaodu;
        end
    end
  end
  j1 = [j1 minH];
  k1 = [k1 maxDelay];
end