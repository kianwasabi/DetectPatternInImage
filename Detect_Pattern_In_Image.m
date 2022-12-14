% Search Pattern in Picture
%==========================================================================
clc;
clear all; 
close all;
%==========================================================================
% Import picture
%startingFolder = 'C:\Program Files\MATLAB';
%if ~exist(startingFolder, 'dir')
%  % If that folder doesn't exist, just start in the current folder.
%  startingFolder = pwd;
%end
%% Get the name of the file that the user wants to use.
%defaultFileName = fullfile(startingFolder, '*.*');
%[baseFileName, folder] = uigetfile(defaultFileName, 'Select a file');
%if baseFileName == 0
%  % User clicked the Cancel button.
%  return;
%end
%fullFileName = fullfile(folder, baseFileName)
%myImage = imread(fullFileName);

filename_picture = 'A.png';
filename_pattern = 'B.png';
RGB_picture = imread(filename_picture);
RGB_pattern = imread(filename_pattern);
%==========================================================================
% Convert imported picture and pattern from RGB to GRAY
picture = rgb2gray(RGB_picture);
pattern = rgb2gray(RGB_pattern);
%==========================================================================
% get size of picture and pattern
[row_pic,col_pic] = size(picture);
[row_pat,col_pat] = size(pattern);
%==========================================================================
% check if picture is larger or at least quals than the the size of pattern
if( (row_pat<=row_pic) || (col_pat<=col_pic) ) 
    row_res = row_pic-row_pat+1;
    col_res = col_pic-col_pat+1;
else
    error('Fehler. Muster muss kleiner als Bild sein.');
end
%==========================================================================
% define result matrix
result = zeros(col_res,row_res);
%==========================================================================
% search pattern in picture 
for row=1:(row_res)     
    for col=1:(col_res)
        cutout = picture(row:(row+row_pat-1),col:(col+col_pat-1));
        R = corr2(cutout,pattern);
        result(row,col) = R;
    end
    clc;
    disp(['This may take some time..',...
        num2str(round(row/(row_pic-row_pat)*100)),'%']);
end
clc;
%==========================================================================
% compute maximum and position in result matrix
[max_y,pos_row]= max(result);
[max  ,pos_col]= max(max_y);
pos_row = pos_row(pos_col);
disp(['Korrelationsergebnis:','x = ',num2str(pos_col),...
                            '; y = ',num2str(pos_row)]);
disp(['K_max: ',num2str(max)]);
%==========================================================================
% store computed pattern 
pat_in_pic_y = pos_row:(pos_row+row_pat-1);
pat_in_pic_x = pos_col:(pos_col+col_pat-1);
found_pattern = picture(pat_in_pic_y,pat_in_pic_x);
%==========================================================================  
% Display 
figure(1);
subplot(2,2,1);
imshow(pattern);
title('Muster');
subplot(2,2,2);
imshow(found_pattern);
title('in Bild gefundenes Muster');
subplot(2,2,3);
imshow(picture);
title('Bild in dem gesucht werden soll');
subplot(2,2,4);
imshow(picture); hold on;
rectangle('position',[pos_col pos_row col_pat row_pat],...
          'edgecolor', [1 0 0]); % highlight pattern in picture
title('Position des gefundenen Musters');
%==========================================================================
% 3D-Plot Koorelationsmatrix  
figure(2);
surf(result,'edgecolor', 'none');
grid on; axis tight;
xlabel('x-Position');
ylabel('y-Position');
zlabel('Korrelation');
title(['Korrelationsmatrix',' von ', filename_picture]);
