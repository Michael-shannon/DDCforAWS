
clear all;

%
% top_level_dir is where source data files can be found. Adjust as needed.
%   make sure to adjust directory seperators for windows,mac/linux
%
top_level_dir = 'D:/Michael_Shannon/3-26-2022_AWStest';

%
% create the output directory if it does not already exist
% 
DDC_Corrected_Files = fullfile( top_level_dir, 'DDC_Corrected_Files', filesep );
if ~exist( DDC_Corrected_Files, 'dir' )
    mkdir( DDC_Corrected_Files );
end

andDelete = true;
myCluster = parcluster('Attempt3_');

jobs = findJob(myCluster,'State','finished');
jobs

for j = 1:length(jobs)
    resultDDC = fetchOutputs( jobs(j) );
    t = resultDDC{ 1 };
    p = resultDDC{ 2 };
    filename = resultDDC{ 3 };
    disp( ['saving job ', num2str(jobs(j).ID), ': workers = ', num2str(p), ', time = ', num2str(t), ', ', filename] );
    tmp_ = resultDDC{ 4 };
    Final_Frame_Blinking_Corrected = resultDDC{ 5 };
    Final_Loc_Blinking_Corrected = resultDDC{ 6 };

    %
    %
    %

    combine_table = table( Final_Frame_Blinking_Corrected{1,1}, Final_Loc_Blinking_Corrected{1,1}(:,1), Final_Loc_Blinking_Corrected{1,1}(:,2) );
    combine_table.Properties.VariableNames = {'frame','x_nm_','y_nm_'};
  
    result_original_combined = innerjoin( tmp_, combine_table );
    DDC_Correct_Files = fullfile(top_level_dir, 'DDC_Corrected_Files',filesep);
    csvexport = regexprep(filename,'.csv','_DDC_corrected.csv');
    filenamefinal = [DDC_Correct_Files csvexport];
    writetable( result_original_combined, filenamefinal );

    %
    % Clear the job
    %
    if andDelete
        disp('deleting');
        delete( jobs(j) );
    end
end
