%Intro_ImgProc  Introduction to simple steps in Image Processing
%
%   Thomas Haslwanter
%   May-2014
%***************************************************************

%%Matlab handles overflow gracefully
%-----------------------------------
x = uint8(250)
x+20

%% How to calculate a radius
%---------------------------
[X,Y] = meshgrid(1:9, 1:5)
X = X-6
Y = Y-2
R2 = X.^2 + Y.^2

%% Using Different Filters on Different Regions
%----------------------------------------------
% Get the data
inDir = '..\..\Images'
inFile = 'cat.jpg'
img = imread(fullfile(inDir, inFile));

% Convert them to grayscale, and show the result
img_g = rgb2gray(img);
imshow(img_g);

% Create Filters, and Filter the data
Filters = {};
Filters{1} = 1;
Filters{2} = ones(7) / 7^2;
Filters{3} = ones(15) / 15^2;

for ii = 1:3
    Filtered{ii} = imfilter(img_g, Filters{ii});
end

% Show the last filtered image
imshow(Filtered{2});

% Create and show 3 Zones
Zones = ones(size(img_g), 'uint8');
Zones(201:end,:) = 2;
Zones(401:end,:) = 3;
imshow(Zones);

% Create the final image from the filtered images
final = zeros(size(img_g), 'uint8');
for ii = 1:3
    final(Zones==ii) = Filtered{ii}(Zones==ii);
end
imshow(final)


