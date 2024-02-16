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

for i=1:length(paramtypes)
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
smoothedRow = conv2(gKernel, 1, imageData, 'same');
smoothedImage = conv2(1, gKernel', smoothedRow, 'same');


% ~~~QUESTION 4~~~

% gradient() in Matlab uses central difference 
[Gx, Gy] = gradient(smoothedImage);


% ~~~QUESTION 5~~~

% ~~~~~~part a~~~~
GxGx = Gx .* Gx;
GxGy = Gx .* Gy;
GyGy = Gy .* Gy;

% ~~~~~~part b~~~~
box_filter = ones(N, N);

Sx2 = conv2(GxGx, box_filter, 'same');
Sxy = conv2(GxGy, box_filter, 'same');
Sy2 = conv2(GyGy, box_filter, 'same');

% ~~~~~~part c~~~~
[rows, cols] = size(imageData);
H = zeros(rows, cols, 2, 2);
for x = 1 : rows
    for y = 1 : cols
        H(x, y, 1, 1) = Sx2(x, y);
        H(x, y, 1, 2) = Sxy(x, y);
        H(x, y, 2, 1) = Sxy(x, y);
        H(x, y, 2, 2) = Sy2(x, y);
    end
end

% ~~~~~~part d~~~~
R = zeros(rows, cols);
for x = 1:rows
    for y = 1:cols

        % extract H at each pixel
        H11 = H(x, y, 1, 1);
        H12 = H(x, y, 1, 2);
        H21 = H(x, y, 2, 1);
        H22 = H(x, y, 2, 2);

        % calculate determinant and trace
        det = (H11 * H22) - (H12 * H21);
        trace = H11 + H22;

        % compute R
        k = 0.05;
        R(x, y) = det - k * trace^2;
    end
end


%imshow(imageData);
imshow(smoothedImage);
%imshow(R);
disp(GxGx)

return
