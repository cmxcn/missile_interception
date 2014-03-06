function controlOut = PIDCalc(P,I,D, controlIn)
persistent sumterm;
persistent lastCin;
if isempty(sumterm)
    sumterm = 0;
end
if isempty(lastCin)
    lastCin = 0;
end
sumterm = sumterm+controlIn;
controlOut = P*controlIn+I*sumterm+D*(controlIn-lastCin);
end