%
% [mst]
% brochure_test.m
% Testing Normalized Cross Correlation
%
% We run NCC in MATLAB over a given image and a sub-pattern to run 
% and present object recognition coefficient
% This is a supplement code for the academic paper:
% 'Using Normalized Cross-Correlation for Object Recognition' by Vladimir Nikolin
%
% circa 2015
%

clear all
close all

%read the images (using urls to be able to run in online editors)
brochure    = imread('https://raw.githubusercontent.com/bbhitec/ncc_recognition_paper/main/brochure.jpg');
txt         = imread('https://raw.githubusercontent.com/bbhitec/ncc_recognition_paper/main/brochure_text_bigger.jpg');   % sub-image cropped from 'brochure.jpg'

%%optional local images use
%brochure    = imread('brochure.jpg');
%txt         = imread('brochure_text_bigger.jpg');   % sub-image cropped from 'brochure.jpg'

figure('Name', 'Brochure orig');
imshow(brochure)
figure('Name', 'Sub-Image');
imshow(txt)

%calculate the Normalized Correlation Coefficients
ncc = normxcorr2(txt(:,:,1),brochure(:,:,1));       % use 'text' as a template
figure('Name', 'Correlation Result Graph');

surf(ncc), shading FLAT
hold on
colorbar;                                           %show a color bar along the 3D graph

%find the maximal NCCed value and it's index
[max_val, max_idx] = max(abs(ncc(:)));              %the resulted 'max_idx' is linear
[idx_row, idx_col] = ind2sub(size(ncc),max_idx(1)); %get the row and col of the maximal NCC value
%cut off the correlation padding frame
xoffset = idx_col - size(txt,2);
yoffset = idx_row - size(txt,1);

%% optional: find and plot n maximal NCC coeffs
%n = 1;
%[sortedValues,sortIndex] = sort(ncc(:),'descend');  %sort the values in descending order
%maxIndex = sortIndex(1:n);                          %get a linear index into A of the 5 largest values
%[idx_row_n, idx_col_n] = ind2sub(size(ncc),maxIndex);
%strValues = strtrim(cellstr(num2str(sortedValues(1:n),'%1.4f')));
%%strValues1 = strtrim(cellstr(num2str([idx_col_n(:) idx_row_n(:)],'(%d,%d)')));
%for i = 1:n
%    hold on
%    plot3(idx_col_n(i),idx_row_n(i),sortedValues(i),'.');    
%    text(idx_col_n,idx_row_n,sortedValues(1:n),strValues,'VerticalAlignment','bottom');
%end


%display the sub-image: first paste it in the original image
padded = uint8(zeros(size(brochure)));
padded(round(yoffset+1):round(yoffset+size(txt,1)),round(xoffset+1):round(xoffset+ size(txt,2)),:) = txt;

figure('Name', 'Found Sub-Image');
imshowpair(brochure(:,:,1),padded,'blend')