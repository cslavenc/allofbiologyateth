%FindPupilEdge	Example of how easily an "eye position" can be found with the MATLAB image processing toolbox
%
%	ThH, Oct-2007
%	Ver 1.0
%*****************************************************************

clear all; close all;

% data.orig = imread('..\..\Images\eye.bmp');
data.orig = imread('eye.bmp');
imshow(data.orig); pause

figure
imhist(data.orig);
pause

data.bw = im2bw(data.orig, 80/256);
imshow(data.bw); pause

data.filled =~(imfill(~data.bw, 'holes'));
imshow(data.filled); pause

data.pupil = imclose(data.filled, strel('disk', 10));
imshow(data.pupil); pause

edge(uint8(data.pupil), 'sobel');
