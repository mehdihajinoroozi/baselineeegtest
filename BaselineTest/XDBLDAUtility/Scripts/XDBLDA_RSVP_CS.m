function [AUC] = XDBLDA_CrossSubject(train_x, train_y, test_x, test_y)

	[channel, time, epoch] = size(train_x);
	
	downample_ratio = time/32;
	% downsample the train and test dataset
	if downample_ratio > 1 && isinteger(downample_ratio)
		permute_matrix = [2, 1, 3];
		tmp = downsample(permute(train_x, permute_matrix), downample_ratio);
		train_x = permute(tmp, permute_matrix);
		tmp = downsample(permute(test_x, permute_matrix), downample_ratio);
		test_x = permute(tmp, permute_matrix);
		time = time/downample_ratio;
	end
	
	s = reshape(train_x, [channel, time*epoch]);
	s = double(s');
	idx.blockLength = time;
	idx.indexStimulus = 1:time:epoch*time;

	nontarget = find(train_y == 0);
	idx.indexStimulus(nontarget) = [];

	[enhancedResponse, DTarget, D] = mxdawn(s,idx, 0);

	data = s*enhancedResponse.spatialFilter;
	data = data';
	train = reshape(data, [channel, time, epoch]);


	test_tmp = reshape(test_x, [channel, time*size(test_x, 3)]);
	data_test = test_tmp'*enhancedResponse.spatialFilter;
	data_test = data_test';
	test = reshape(data_test, [channel, time, size(data_test, 2)/time]);

	% train_xx = reshape(train_x, [channel*time, size(train_x,3)]);

	train_xx = [];

	for i = 1:8
		train_xx = [train_xx; squeeze(double(train(i, :, :)))];    
	end


	train_yy = (train_y-0.5)*2;

	%     LDAModel = fitcdiscr(train_xx', train_yy);
	BLDA = bayeslda(1);
	BLDA.verbose = 0;
	BLDA = train_BLDA(BLDA, train_xx, train_yy');

	weights = BLDA;
	score = classify_BLDA(weights, train_xx )';


	%     test_xx = reshape(test_x, [channel*time, size(test_x,3)]);

	test_xx = [];
	for i = 1:8
		test_xx = [test_xx; squeeze(double(test(i, :, :)))];
	end

	score_test = classify_BLDA(weights, test_xx )';

	%     [~, score_test] = predict(LDAModel, test_xx');
	test_yy = (test_y-0.5)*2;
	[~, ~, ~, auc(subjectID)] = perfcurve(test_yy, score_test(:, 1),1);

end