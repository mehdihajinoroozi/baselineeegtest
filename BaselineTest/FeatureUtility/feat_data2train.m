function [ train_x, train_y, test_x, test_y ] = feat_data2train.m( fold, ...
                                    featDataA, featDataB)

step = 1;
testSub = (fold-1)*step+1:fold*step;
trainSub = 1:15;
trainSub(testSub) = [];

train_x = [];
train_y = [];
test_x = [];
test_y = [];
% get all train data
for idx = 1:length(trainSub)
    subID = trainSub(idx);
        
    currentSubfeatDataA = featDataA{subID};
    [epoch, freq, chan, time] = size(currentSubfeatDataA);
    currentSubDataA = reshape(currentSubfeatDataA, ...
        [epoch, freq*chan*time]);
    
    
    currentSubfeatDataB = featDataB{subID};
    [epoch, freq, chan, time] = size(currentSubfeatDataB);
    currentSubDataB = reshape(currentSubfeatDataB, ...
        [epoch, freq*chan*time]);
        
                
    train_x = cat(1, train_x, currentSubDataA);
    train_y = cat(1, train_y, ones([size(currentSubDataA, 1), 1]));   
    train_x = cat(1, train_x, currentSubDataB);
    train_y = cat(1, train_y, 2*ones([size(currentSubDataB, 1), 1]));         
                
end

kk = randperm(size(train_x, 1));
train_x = train_x(kk, :);
train_y = train_y(kk, :);

for idx = 1:length(testSub)
    subID = testSub(idx);
        
    currentSubfeatDataA = featDataA{subID};
    [epoch, freq, chan, time] = size(currentSubfeatDataA);
    currentSubDataA = reshape(currentSubfeatDataA, ...
        [epoch, freq*chan*time]);
    
    
    currentSubfeatDataB = featDataB{subID};
    [epoch, freq, chan, time] = size(currentSubfeatDataB);
    currentSubDataB = reshape(currentSubfeatDataB, ...
        [epoch, freq*chan*time]);    
                
    test_x = cat(1, test_x, currentSubDataA);
    test_y = cat(1, test_y, ones([size(currentSubDataA, 1), 1]));   
    test_x = cat(1, test_x, currentSubDataB);
    test_y = cat(1, test_y, 2*ones([size(currentSubDataB, 1), 1]));         
                
end

end



