% read_corner_parameters.m  - a function for reading in project parameters for
% the corner finding program 
% See cornerparams.dat for a sample input file and description of what each
% of the parameters are.
% Usage:
%   [filename,S,N,D,M] = read_corner_parameters('cornerparams.dat');
%

% ~~~QUESTION 1~~~

function [filename,S,N,D,M] = read_corner_parameters(paramfilename)

fp = fopen('cornerparams.dat','r');

%Note: this is a general framework for reading parameters from a data file
params = {};
paramtypes = {'%s','%f','%d','%d','%d'};
paramnames = {'filename','S','N','D','M'};

for i=1:length(paramtypes);
    line = fgets(fp);

    %ignore comment lines
    while(line(1)=='%')    
        line = fgets(fp);
    end
    command = sprintf('%s = sscanf(line,''%s'');',paramnames{i},paramtypes{i});
    eval(command);
end

fclose(fp);


% ~~~QUESTION 2~~~

imageData = imread(filename);
imageData = im2double(rgb2gray(imageData));


% ~~~QUESTION 3~~~

% get kernel size
kernelSize = 2 * ceil(3 * S) + 1;

% create kernel
x = -floor(kernelSize/2):floor(kernelSize/2);
gKernel = exp(-x.^2 / (2 * S^2));

% normalize before convolving
gKernel = gKernel / sum(gKernel); 

% conv along rows then cols
smoothedRow = conv2(gKernel, 1, imageData, 'full');
smoothedImage = conv2(1, gKernel', smoothedRow, 'full');


% ~~~QUESTION 4~~~

[Gx, Gy] = gradient(smoothedImage);

%imshow(imageData);
imshow(smoothedImage);

return
