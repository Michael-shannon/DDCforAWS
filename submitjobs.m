
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

csv_files = dir( sprintf('%s/*.csv',top_level_dir) );
n_csv_files = numel( csv_files );

for i = 1:n_csv_files
    csv_filename = fullfile( csv_files( i ).folder, csv_files( i ).name );
    tmp_ = readtable( csv_filename );

    LocalizationsFinal{1} = [tmp_.x_nm_, tmp_.y_nm_];
    Frame_Information{1}  = tmp_.frame;

    workers = 36;
    disp( ['submitting ', num2str( i )] );
    j( i ) = batch( @batchDDC, 6, { workers, csv_files( i ).name, tmp_, Frame_Information, LocalizationsFinal }, 'Pool', workers-1, 'AutoAddClientPath', false );
end

%
%
%

function [ t, w, filename, tmp_, Final_Frame_Blinking_Corrected, Final_Loc_Blinking_Corrected ] = batchDDC( w, filename, tmp_, Frame_Information, LocalizationsFinal )
    s = tic;
    run( 'Split_UP_Image_Multiple_Images_headless.m' );
    run( 'run_script_DDC_headless.m' );
    run( 'Combine_Images_headless.m' );
    t = toc( s );
end
