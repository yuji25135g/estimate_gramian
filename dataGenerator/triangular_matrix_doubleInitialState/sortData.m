%{
testデータとしてtrainingデータを並べ替えたものを作る
%}
function [A, U, D] = sortData(preA, preU, preD, numOfData, numOfSampling)
    queue = zeros(1,numOfData);
    sort = zeros(1, numOfData); 
    U = [];
    D = [];
    A = [];

    for i= 1:numOfData
        q = randi(numOfData);
        if queue(1,q) == 0
            U = [U, preU(:,numOfSampling*q-(numOfSampling-1):numOfSampling*q)];
            D = [D, preD(:, numOfSampling*q-(numOfSampling-1):numOfSampling*q)];
            A(:,:,i) = preA(:,:,q);
            queue(1,q) = 1;
            sort(1,i) = q;
        else
            while queue(1,q) == 1
                q = randi(numOfData);
            end
            U = [U, preU(:,numOfSampling*q-(numOfSampling-1):numOfSampling*q)];
            D = [D, preD(:,numOfSampling*q-(numOfSampling-1):numOfSampling*q)];
            A(:,:,i) = preA(:,:,q);
            queue(1,q) = 1;
            sort(1,i) = q;
        end
    end
end