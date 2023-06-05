
function output = ISH_analysis2();
%Function to analyze in situ data
%Chooses one channel (ChAT) to make ROIs and compares mean intensity and percent coverage
%of each channel in target ROIs

%Outputs the following in a cell array: 
    % ROI image mask
    % Array of mean intensity for each ROI
    % ARray of coverage for each ROI in each channel

mask_ch_name = 'chat';
ch2_name = 'vgat';
ch3_name = 'gad';



%user defines save path here:
%savepath = uigetdir(); %comment this line out, and uncomment the following line if you don't want to select the folder each time
%cd(savepath);%
savepath = 'N:\MICROSCOPE\Karen\2020\ChAT in situ project\' ;


%%    
%Get user inputs
    [roi_ch, path] = uigetfile('*.tif','Select image to determine ROIs');
    str_length = strfind(roi_ch,'_CH');
    filename = roi_ch(1:str_length);
    
    cd(path);
    
    %get other two channels
    ch2 = uigetfile('*.tif',sprintf('Select %s image',ch2_name));
    ch3 = uigetfile('*.tif',sprintf('Select %s image',ch3_name));

    %load in images
    mask_ch_image = imread(roi_ch);
    ch2_image = imread(ch2);
    ch3_image = imread(ch3);

    %background subtract the images
    se = strel('disk',20);
    mask_ch_image = imtophat(mask_ch_image,se);
    ch2_image = imtophat(ch2_image,se); 
    ch3_image = imtophat(ch3_image,se); 

    %threshold the image 
    mask_ch_image = rgb2gray(mask_ch_image);
    th = graythresh(mask_ch_image);
    im_th = imbinarize(mask_ch_image,th); 

    %% Create CHAT ROIs

    %show the threshold chat image
    imshow(im_th)

    totMask = false(size(im_th)); % accumulate all single object masks to this one
    h = drawfreehand( gca ); %setColor(h,'red');
    BW = createMask( h );

    %Get all ROIs, double click on image when finished
    while sum(BW(:)) > 10 % less than 10 pixels is considered empty mask
      
        %Take intersection of current mask and the th
        BW =  im_th & BW;
    
        %convert a single binary ROI to points 
        k = find(BW);
        [x,y] = ind2sub(size(BW),k);
        %Find boundary
        bound = boundary(x,y,0.25);%Change the third value here to determine how convex the boundary is (0 - most convex, 1 - most concave)
        BW2 = poly2mask(y(bound),x(bound),size(BW,1),size(BW,2));  %convert the boundary to an ROI      
      
       totMask = totMask | BW2; % add mask to global mask
      
       %merge the image 
       temp_im = imfuse(im_th, totMask);
       imshow(temp_im)


      % ask user for another mask
      h = drawfreehand( gca ); %setColor(h,'red');
      BW = createMask( h );
end
% show the resulting mask
figure; imshow( totMask ); title('ChAT ROIs');

%% get intensity of gad and vgat within each ChAT ROI

%label and get number of blobs 
    
    [l, nBlobs] = bwlabeln(totMask);
    
    %Convert images to gray-scale
    ch2_image = rgb2gray(ch2_image);
    ch3_image = rgb2gray(ch3_image);    

    %preallocate blob_intensities
    ch1_intensities = NaN(nBlobs,1);
    ch2_intensities = NaN(nBlobs,1);
    ch3_intensities = NaN(nBlobs,1);

    %get the mean intensity in each blob region
    for i = 1:nBlobs
        index = find(l == i);
        npixels = length(index);

        %Ch1
        sum_intensity_ch1 = sum(mask_ch_image(index));
        ch1_intensities(i) = sum_intensity_ch1/npixels;

        %Ch2
        sum_intensity_ch2 = sum(ch2_image(index));
        ch2_intensities(i) = sum_intensity_ch2/npixels;

        %Ch3
        sum_intensity_ch3 = sum(ch3_image(index));
        ch3_intensities(i) = sum_intensity_ch3/npixels;

    end
    
    %%  
%Get coverage by VGAT and GAD in each channel

    %preallocate blob coverage
    ch1_coverage = NaN(nBlobs,1);
    ch2_coverage = NaN(nBlobs,1);
    ch3_coverage = NaN(nBlobs,1);
    
    %threshold remaining images    
    ch2_th = imbinarize(ch2_image,graythresh(ch2_image));
    %ch2_th = imbinarize(ch2_image,0.065);
    ch3_th = imbinarize(ch3_image,graythresh(ch3_image));

        %get the coverage in each blob region
    for i = 1:nBlobs
        blob = l == i;
        npixels = sum(blob,'all');

        %Ch1
        ch1_intersect = blob & im_th;
        ch1_coverage(i) = sum(ch1_intersect,'all')/npixels;

        %Ch2
        ch2_intersect = blob & ch2_th;
        ch2_coverage(i) = sum(ch2_intersect,'all')/npixels;
        
        %Ch3
        ch3_intersect = blob & ch3_th;
        ch3_coverage(i) = sum(ch3_intersect,'all')/npixels;
 
    end


%% Plot the data
figure; hold on;
subplot(2,3,1);
imshow(imfuse(im_th,totMask));
title('ChAT cell coverage in masks');

subplot(2,3,2);
imshow(imfuse(ch2_th,totMask));
title('VGAT cell cover age in masks');

subplot(2,3,3);
imshow(imfuse(ch3_th,totMask));
title('GAD cell coverage in masks');
 
subplot(2,3,4);
histogram(ch1_coverage,100);
xlabel('proportion covered by ChAT');
ylabel('# of ROIs')

subplot(2,3,5);
histogram(ch2_coverage,100);
xlabel('proportion covered by VGAT');
ylabel('# of ROIs')

subplot(2,3,6);
histogram(ch3_coverage,100);
xlabel('proportion covered by GAD');
ylabel('# of ROIs');

imwrite(getframe(gcf).cdata, 'histogram.tif')

%% Save the data
data_labels = {'Number of ROIs', ...
    'Ch1/ChAT mean intensities', 'Ch2/VGAT mean intensities', 'Ch3/Gad mean intensities',...
    'Ch1/ChAT coverage', 'Ch2/VGAT coverage', 'Ch3/Gad coverage',...
    'ROI mask'};
 
data = {nBlobs, ...
    ch1_intensities, ch2_intensities, ch3_intensities,...
    ch1_coverage, ch2_coverage, ch3_coverage,...
    totMask};

output.data_labels = data_labels;
output.data = data;

save_file_name = ['analysis_karen.mat'];
save(save_file_name,'output');
pause;
close all
    
end