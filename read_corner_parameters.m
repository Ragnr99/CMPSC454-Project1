% read_corner_parameters.m  - a function for reading in project parameters for
% the corner finding program 
% See cornerparams.dat for a sample input file and description of what each
% of the parameters are.
% Usage:
%   [filename,S,N,D,M] = read_corner_parameters('cornerparams.dat');
%

function [filename,S,N,D,M] = read_corner_parameters(paramfilename)

fp = fopen('cornerparams.dat','r');

%Note: this is a general framework for reading parameters from a data file
params = {};
paramtypes = {'%s','%f','%d','%d','%d'};
paramnames = {'filename','S','N','D','M'};

for i=1:length(paramtypes);
    line = fgets(fp);
    while(line(1)=='%')    %ignore comment lines
        line = fgets(fp);
    end
    command = sprintf('%s = sscanf(line,''%s'');',paramnames{i},paramtypes{i});
    eval(command);
end

fclose(fp);

% Read the image file
imageData = imread(filename);

% Convert to double float grayscale
imageData = im2double(rgb2gray(rgbImage));

% Display all the saved values
fprintf('filename: %s\n', filename);
fprintf('S: %f\n', S);
fprintf('N: %d\n', N);
fprintf('D: %d\n', D);
fprintf('M: %d\n', M);

return
