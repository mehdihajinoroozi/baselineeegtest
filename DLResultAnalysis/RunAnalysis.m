
%%

DLPATH = ['C:\Users\EEGLab\Dropbox\UTSA Research\Collaboration' ...
    '\EEGRoomPC\Reports\MultiLayerAnalysis'];

result_folder = 'RSVP_X2_S01_RAW_CH128_FOLD2';

folderIdx = 7;

[ testAUCAll, trainAUCAll, validAUCAll, testAUCMax, testAUCIdx, ...
    currMaxIdx, setFilesList] = get_one_fold_result...
    ( DLPATH, result_folder, folderIdx );

[i,j]=find(validAUCAll == max(max(validAUCAll)));
testAUCAll(i,j);
max(max(validAUCAll))

[i,j]=find(testAUCAll == max(max(testAUCAll)));
a = testAUCAll(i, 1:j);
a = a';

%%
DLPATH = ['C:\Users\EEGLab\Dropbox\UTSA Research\Collaboration' ...
    '\EEGRoomPC\Reports\CombineSignalAnalysis'];
RLTPATH = ['C:\Users\EEGLab\Dropbox\UTSA Research\Collaboration' ...
    '\EEGRoomPC\Reports\CSA_Result'];

result_folders = {'RSVP_X2_S01_NORM_CH64', ...
    'RSVP_X2_S01_RAW_CH64', ...
    'RSVP_X2_S01_RAWFREQ_CH64', ...
    'RSVP_X2_S01_RAWP300_CH64'};

folderIdx = 1;

total_type_size = length(result_folders);
top16_vals = zeros(16, total_type_size);
top16_models = cell(16, total_type_size);

for rlt_fld_idx = 1:total_type_size
    
    [ testAUCAll, trainAUCAll, validAUCAll, testAUCMax, testAUCIdx, ...
        currMaxIdx, setFilesList] = get_one_fold_result...
        ( DLPATH, result_folders{rlt_fld_idx}, folderIdx );
    
    [top16_vals(:, rlt_fld_idx), top16_models(:, rlt_fld_idx)] = ...
        get_top_16_model(validAUCAll, testAUCAll, setFilesList);
        
end
save([RLTPATH '\model' num2str(folderIdx) '.mat'], 'top16_models', 'top16_vals');

%%
[h_norm_vs_raw, p_norm_vs_raw] = ttest(top16_vals(:, 1), top16_vals(:, 2));
[h_raw_vs_rawp300, p_raw_vs_rawp300] = ttest(top16_vals(:, 2), top16_vals(:, 4));
[h_raw_vs_rawfreq, p_raw_vs_rawfreq] = ttest(top16_vals(:, 2), top16_vals(:, 3));
