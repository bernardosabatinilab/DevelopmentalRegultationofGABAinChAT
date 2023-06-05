% Folder   = cd;
% 
% FileList = dir(fullfile(Folder, '**', '*_karen.mat'));
% masterfile = cell(2000, 8);
% currentline = 0;
% for i = 1:length(FileList)
%     file_name = strcat(FileList(i).folder,filesep,FileList(i).name);
%     output = load(file_name);
%     roi_num = cell2mat(output.output.data(1)); 
%     for k = 1:roi_num
%         masterfile(currentline+k,1) = cellstr(file_name);
%         masterfile(currentline+k,2) = num2cell(k);
%         for j = 2:7
%             if roi_num == 1
%                 data_cell = output.output.data(j);
%                 temp =  data_cell(1);
%                 masterfile(currentline+k,j+1) = num2cell(temp{k});
%             else
%                 masterfile(currentline+k,j+1) = num2cell(output.output.data{j}(k));
% 
%             end
%         end
%     end 
%     currentline = currentline + roi_num;
% end
%% 

masterfile = load('masterfile wo thres.mat').masterfile;
masterfile2 = load('adult_masterfile_Added.mat').Adult_masterfile;


times = {'P0','P7','P14','P21','P28','Adult'};
regions = {'BF','MS'};
BF_P0 = cell(170,6);BF_P7 = cell(173,6); BF_P14 = cell(319,6); BF_P21 = cell(163,6); BF_P28=cell(172,6);
MS_P0 = cell(75,6);MS_P7 = cell(122,6); MS_P14 = cell(95,6); MS_P21 = cell(200,6); MS_P28=cell(137,6);
BF_adult = cell(199,6); MS_adult = cell(181,6); 
currentline_BFP0 = 1;
currentline_BFP7 = 1;
currentline_BFP14 = 1;
currentline_BFP21 = 1;
currentline_BFP28 = 1;
currentline_MSP0 = 1;
currentline_MSP7 = 1;
currentline_MSP14 = 1;
currentline_MSP21 = 1;
currentline_MSP28 = 1;

currentline_BFadult = 1;
currentline_MSadult = 1;

for i = 1:size(masterfile,1)
    text = masterfile(i,1);
    if contains(text{1},times{1}) + contains(text{1},regions{1})== 2
 
        for j = 3:8
            BF_P0(currentline_BFP0, j-2) = masterfile(i, j);
            
        end
        currentline_BFP0 = currentline_BFP0 +1;
    
    elseif contains(text{1},times{1}) + contains(text{1},regions{2}) == 2
     
        for j = 3:8
            MS_P0(currentline_MSP0, j-2) = masterfile(i, j);
          
        end
       currentline_MSP0 = currentline_MSP0 +1;
        
 
         
    elseif contains(text{1},times{2}) + contains(text{1},regions{1}) == 2

        for j = 3:8
            BF_P7(currentline_BFP7, j-2) = masterfile(i, j);
            
        end
        currentline_BFP7 = currentline_BFP7 +1;
    elseif contains(text{1},times{2}) + contains(text{1},regions{2}) == 2
      
        for j = 3:8
            MS_P7(currentline_MSP7, j-2) = masterfile(i, j);
          
        end
        currentline_MSP7 = currentline_MSP7 +1;

        
    elseif contains(text{1},times{3}) + contains(text{1},regions{1}) == 2
       
        for j = 3:8
            BF_P14(currentline_BFP14, j-2) = masterfile(i, j);
        end
        
            currentline_BFP14 = currentline_BFP14 +1;
      
    elseif contains(text{1},times{3}) + contains(text{1},regions{2}) == 2

        for j = 3:8
            MS_P14(currentline_MSP14, j-2) =masterfile(i, j);
        end
            currentline_MSP14 = currentline_MSP14 +1;
       
        
        
    elseif contains(text{1},times{4}) + contains(text{1},regions{1}) == 2

        for j = 3:8
            BF_P21(currentline_BFP21, j-2) = masterfile(i, j);
        end
        
            currentline_BFP21 = currentline_BFP21 +1;
    
    elseif contains(text{1},times{4}) + contains(text{1},regions{2}) == 2

        for j = 3:8
            MS_P21(currentline_MSP21, j-2) = masterfile(i, j);
        end
        
            currentline_MSP21 = currentline_MSP21 +1;
      
        
    elseif contains(text{1},times{5}) + contains(text{1},regions{1}) == 2

        for j = 3:8
            BF_P28(currentline_BFP28, j-2) = masterfile(i, j);
        end
        
            currentline_BFP28 = currentline_BFP28 +1;
   
    elseif contains(text{1},times{5}) + contains(text{1},regions{2}) == 2

        for j = 3:8
            MS_P28(currentline_MSP28, j-2) = masterfile(i, j);
        end
        
            currentline_MSP28 = currentline_MSP28 +1;
    end
end

for i = 1:size(masterfile2,1)
    text = masterfile2(i,1);

    if contains(text{1},times{6}) + contains(text{1},regions{1}) == 2

        for j = 3:8
            BF_adult(currentline_BFadult, j-2) = masterfile2(i, j);
        end
        
            currentline_BFadult = currentline_BFadult +1;
            
    elseif contains(text{1},times{6}) + contains(text{1},regions{2}) == 2

        for j = 3:8
            MS_adult(currentline_MSadult, j-2) = masterfile2(i, j);
        end
        
            currentline_MSadult = currentline_MSadult +1;
        
    end
end

%% presentation graph
figure;
subplot(3,2,1)
shading flat;
grid on;
axis equal;
cdfplot(cell2mat(BF_P0(:,4))) ;
hold on;cdfplot(cell2mat(BF_P7(:,4))); cdfplot(cell2mat(BF_P14(:,4))); cdfplot(cell2mat(BF_P21(:,4))); cdfplot(cell2mat(BF_P28(:,4)));cdfplot(cell2mat(BF_adult(:,4)));
ylabel('probability')
xlim([0,0.5])
xlabel('Choline Acetyltransferase percentage coverage in basal forebrain')
title('Choline Acetyltransferase in basal forebrain at p0 - p28')
legend('P0', 'P7','P14','P21','P28','adult')


subplot(3,2,2)
shading flat;
grid on;
axis equal;
cdfplot(cell2mat(MS_P0(:,4))) ;
hold on;cdfplot(cell2mat(MS_P7(:,4))); cdfplot(cell2mat(MS_P14(:,4))); cdfplot(cell2mat(MS_P21(:,4))); cdfplot(cell2mat(MS_P28(:,4)));cdfplot(cell2mat(MS_adult(:,4)));
ylabel('probability')
xlim([0,0.5])
xlabel('Choline Acetyltransferase percentage coverage in Medium Septum')
title('Choline Acetyltransferase in Medium Septum at p0 - p28')
legend('P0', 'P7','P14','P21','P28','adult')

subplot(3,2,3)
shading flat;
grid on;
axis equal;
cdfplot(cell2mat(BF_P0(:,5))) ;
hold on;cdfplot(cell2mat(BF_P7(:,5))); cdfplot(cell2mat(BF_P14(:,5))); cdfplot(cell2mat(BF_P21(:,5))); cdfplot(cell2mat(BF_P28(:,5)));cdfplot(cell2mat(BF_adult(:,5)));
ylabel('probability')
xlim([0 0.2])
xlabel('Vescular GABA Transporter percentage coverage in basal forebrain')
title('Vescular GABA Transporter in basal forebrain at p0 - p28')
legend('P0', 'P7','P14','P21','P28','adult')


subplot(3,2,4)
shading flat;
grid on;
axis equal;
cdfplot(cell2mat(MS_P0(:,5))) ;
hold on;cdfplot(cell2mat(MS_P7(:,5))); cdfplot(cell2mat(MS_P14(:,5))); cdfplot(cell2mat(MS_P21(:,5))); cdfplot(cell2mat(MS_P28(:,5)));cdfplot(cell2mat(MS_adult(:,5)));
ylabel('probability')
xlim([0,0.2])
xlabel('Vescular GABA Transporter percentage coverage in Medium Septum')
title('Vescular GABA Transporter in Medium Septum at p0 - p28')
legend('P0', 'P7','P14','P21','P28','adult')

subplot(3,2,5)
shading flat;
grid on;
axis equal;
cdfplot(cell2mat(BF_P0(:,6))) ;
hold on;cdfplot(cell2mat(BF_P7(:,6))); cdfplot(cell2mat(BF_P14(:,6))); cdfplot(cell2mat(BF_P21(:,6))); cdfplot(cell2mat(BF_P28(:,6)));cdfplot(cell2mat(BF_adult(:,6)));
ylabel('probability')
xlim([0,0.6])
xlabel('Glutamate decarboxylase percentage coverage in basal forebrain')
title('Glutamate decarboxylase in basal forebrain at p0 - p28')
legend('P0', 'P7','P14','P21','P28','adult')


subplot(3,2,6)
shading flat;
grid on;
axis equal;
xlim([0,0.025])
cdfplot(cell2mat(MS_P0(:,6))) ;
hold on;cdfplot(cell2mat(MS_P7(:,6))); cdfplot(cell2mat(MS_P14(:,6))); cdfplot(cell2mat(MS_P21(:,6))); cdfplot(cell2mat(MS_P28(:,6)));cdfplot(cell2mat(MS_adult(:,6)));
ylabel('probability')
xlim([0,0.6])
xlabel('Glutamate decarboxylase percentage coverage in Medium Septum')
title('Glutamate decarboxylase in Medium Septum at p0 - p28')
%% Combine arrays for export
%create a table consisting of percentage coverage for BF and MS

BF_P0 = cell2mat(BF_P0); BF_P7 = cell2mat(BF_P7); BF_P14 = cell2mat(BF_P14); 
BF_P21 = cell2mat(BF_P21); BF_P28 = cell2mat(BF_P28); 

MS_P0 = cell2mat(MS_P0); MS_P7 = cell2mat(MS_P7); MS_P14 = cell2mat(MS_P14); 
MS_P21 = cell2mat(MS_P21); MS_P28 = cell2mat(MS_P28); 


Rawcdf = {'region', 'P0', 'P7','P14','P21','P28';...
    'BF',BF_P0(:,[4 5 6]),BF_P7(:,[4 5 6]),BF_P14(:,[4 5 6]),...
    BF_P21(:,[4 5 6]),BF_P28(:,[4 5 6]);...
    'MS',MS_P0(:,[4 5 6]),MS_P7(:,[4 5 6]),...
    MS_P14(:,[4 5 6]),MS_P21(:,[4 5 6]),MS_P28(:,[4 5 6])};



%% Past Data Analysis

% 
% %%
% %visualization of graphs - VGAT mean intensity 1. BF 2. MS. 3. STR        
% 
% figure;
% subplot(3,1,1) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(BF_P0_clean(:,2)); 
% hold on; cdfplot(BF_P7_clean(:,2)); cdfplot(BF_P14_clean(:,2)); cdfplot(BF_P21_clean(:,2)); cdfplot(BF_P28_clean(:,2));
% ylabel('probability')
% xlabel('mean intensity of Vesicular GABA Transporter (VGAT) in basal forebrain')
% title('Vesicular GABA Transporter (VGAT) in basal forebrain at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% 
% 
% subplot(3,1,2) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(MS_P0_clean(:,2));
% hold on; cdfplot(MS_P7_clean(:,2)); cdfplot(MS_P14_clean(:,2)); cdfplot(MS_P21_clean(:,2)); cdfplot(MS_P28_clean(:,2))
% ylabel('probability')
% xlabel('mean intensity of Vesicular GABA Transporter (VGAT) in medial septum ')
% title('Vesicular GABA Transporter (VGAT) in medial septum at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% 
% %%
% %histogram of CHAT intensity 1. BF 2. MS. STR
% figure; 
% subplot(5,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P0_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in basal forebrain')
% title('Choline Acetyltransferase in basal forebrain at p0')
% 
% subplot(5,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P7_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in basal forebrain')
% title('Choline Acetyltransferase in basal forebrain at p7')
% 
% subplot(5,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P14_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in basal forebrain')
% title('Choline Acetyltransferase in basal forebrain at p14')
% 
% subplot(5,1,4) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P21_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in basal forebrain')
% title('Choline Acetyltransferase in basal forebrain at p21')
% 
% subplot(5,1,5) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P28_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in basal forebrain')
% title('Choline Acetyltransferase in basal forebrain at p28')
% 
% figure; 
% subplot(5,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P0_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in medial septum')
% title('Choline Acetyltransferase in medial septum at p0')
% 
% subplot(5,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P7_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in medial septum')
% title('Choline Acetyltransferase in medial septum at p7')
% 
% subplot(5,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P14_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in medial septum')
% title('Choline Acetyltransferase in medial septum at p14')
% 
% subplot(5,1,4) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P21_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in medial septum')
% title('Choline Acetyltransferase in medial septum at p21')
% 
% subplot(5,1,5) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P28_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in medial septum')
% title('Choline Acetyltransferase in medial septum at p28')
% 
% %STR
% 
% figure; 
% subplot(3,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P0_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in striatum')
% title('Choline Acetyltransferase in striatum at p0')
% 
% subplot(3,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P7_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in striatum')
% title('Choline Acetyltransferase in striatum at p7')
% 
% 
% subplot(3,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P21_clean(:,1));
% xlabel('histogram of Choline Acetyltransferase mean intensity in striatum')
% title('Choline Acetyltransferase in striatum at p21')
% 
% %%
% %%%
% %histogram of VGAT intensity 1. BF 2. MS. STR
% figure; 
% subplot(5,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P0_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in basal forebrain')
% title('Vesicular GABA Transporter (VGAT) in basal forebrain at p0')
% 
% subplot(5,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P7_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in basal forebrain')
% title('Vesicular GABA Transporter (VGAT) in basal forebrain at p7')
% 
% subplot(5,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P14_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in basal forebrain')
% title('Vesicular GABA Transporter (VGAT) in basal forebrain at p14')
% 
% subplot(5,1,4) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P21_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in basal forebrain')
% title('Vesicular GABA Transporter (VGAT) in basal forebrain at p21')
% 
% subplot(5,1,5) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P28_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in basal forebrain')
% title('Vesicular GABA Transporter (VGAT) in basal forebrain at p28')
% 
% figure; 
% subplot(5,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P0_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in medial septum')
% title('Vesicular GABA Transporter (VGAT) in medial septum at p0')
% 
% subplot(5,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P7_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in medial septum')
% title('Vesicular GABA Transporter (VGAT) in medial septum at p7')
% 
% subplot(5,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P14_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in medial septum')
% title('Vesicular GABA Transporter (VGAT) in medial septum at p14')
% 
% subplot(5,1,4) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P21_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in medial septum')
% title('Vesicular GABA Transporter (VGAT) in medial septum at p21')
% 
% subplot(5,1,5) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P28_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in medial septum')
% title('Vesicular GABA Transporter (VGAT) in medial septum at p28')
% 
% %STR
% 
% figure; 
% subplot(3,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P0_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in striatum')
% title('Vesicular GABA Transporter (VGAT) in striatum at p0')
% 
% subplot(3,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P7_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in striatum')
% title('Vesicular GABA Transporter (VGAT) in striatum at p7')
% 
% 
% subplot(3,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P21_clean(:,2));
% xlabel('histogram of Vesicular GABA Transporter (VGAT) mean intensity in striatum')
% title('Vesicular GABA Transporter (VGAT) in striatum at p21')
% 
% %%
% % GAD histogram - mean intensity
% %%%
% %histogram of GAD intensity 1. BF 2. MS. STR
% figure; 
% subplot(5,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P0_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in basal forebrain')
% title('glutamic acid decarboxylase (GAD) in basal forebrain at p0')
% 
% subplot(5,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P7_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in basal forebrain')
% title('glutamic acid decarboxylase (GAD) in basal forebrain at p7')
% 
% subplot(5,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P14_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in basal forebrain')
% title('glutamic acid decarboxylase (GAD) in basal forebrain at p14')
% 
% subplot(5,1,4) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P21_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in basal forebrain')
% title('glutamic acid decarboxylase (GAD) in basal forebrain at p21')
% 
% subplot(5,1,5) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P28_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in basal forebrain')
% title('glutamic acid decarboxylase (GAD) in basal forebrain at p28')
% 
% figure; 
% subplot(5,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P0_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in medial septum')
% title('glutamic acid decarboxylase (GAD) in medial septum at p0')
% 
% subplot(5,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P7_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in medial septum')
% title('glutamic acid decarboxylase (GAD) in medial septum at p7')
% 
% subplot(5,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P14_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in medial septum')
% title('glutamic acid decarboxylase (GAD) in medial septum at p14')
% 
% subplot(5,1,4) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P21_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in medial septum')
% title('glutamic acid decarboxylase (GAD) in medial septum at p21')
% 
% subplot(5,1,5) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P28_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in medial septum')
% title('glutamic acid decarboxylase (GAD) in medial septum at p28')
% 
% %STR
% 
% figure; 
% subplot(3,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P0_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in striatum')
% title('glutamic acid decarboxylase (GAD) in striatum at p0')
% 
% subplot(3,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P7_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in striatum')
% title('glutamic acid decarboxylase (GAD) in striatum at p7')
% 
% 
% subplot(3,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P21_clean(:,3));
% xlabel('histogram of glutamic acid decarboxylase (GAD) mean intensity in striatum')
% title('glutamic acid decarboxylase (GAD) in striatum at p21')
% 
% 
% %% Histogram part 2 % coverage
% 
% %histogram of VGAT intensity 1. BF 2. MS. STR
% figure; 
% subplot(5,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P0_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in basal forebrain')
% title('Vesicular GABA transporter (VGAT) in basal forebrain at p0')
% 
% subplot(5,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P7_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in basal forebrain')
% title('Vesicular GABA transporter (VGAT) in basal forebrain at p7')
% 
% subplot(5,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P14_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in basal forebrain')
% title('Vesicular GABA transporter (VGAT) in basal forebrain at p14')
% 
% subplot(5,1,4) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P21_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in basal forebrain')
% title('Vesicular GABA transporter (VGAT) in basal forebrain at p21')
% 
% subplot(5,1,5) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P28_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in basal forebrain')
% title('Vesicular GABA transporter (VGAT) in basal forebrain at p28')
% 
% figure; 
% subplot(5,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P0_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in medial septum')
% title('Vesicular GABA transporter (VGAT) in medial septum at p0')
% 
% subplot(5,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P7_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in medial septum')
% title('Vesicular GABA transporter (VGAT) in medial septum at p7')
% 
% subplot(5,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P14_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in medial septum')
% title('Vesicular GABA transporter (VGAT) in medial septum at p14')
% 
% subplot(5,1,4) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P21_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in medial septum')
% title('Vesicular GABA transporter (VGAT) in medial septum at p21')
% 
% subplot(5,1,5) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P28_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in medial septum')
% title('Vesicular GABA transporter (VGAT) in medial septum at p28')
% 
% %STR
% 
% figure; 
% subplot(3,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P0_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in striatum')
% title('Vesicular GABA transporter (VGAT) in striatum at p0')
% 
% subplot(3,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P7_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in striatum')
% title('Vesicular GABA transporter (VGAT) in striatum at p7')
% 
% 
% subplot(3,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P21_clean(:,5));
% xlabel('histogram of Vesicular GABA transporter (VGAT) % coverage in striatum')
% title('Vesicular GABA transporter (VGAT) in striatum at p21')
% 
% 
% %histogram of GAD intensity 1. BF 2. MS. STR
% figure; 
% subplot(5,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P0_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in basal forebrain')
% title('Glutamic acid decarboxylase (GAD) in basal forebrain at p0')
% 
% subplot(5,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P7_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in basal forebrain')
% title('Glutamic acid decarboxylase (GAD) in basal forebrain at p7')
% 
% subplot(5,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P14_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in basal forebrain')
% title('Glutamic acid decarboxylase (GAD) in basal forebrain at p14')
% 
% subplot(5,1,4) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P21_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in basal forebrain')
% title('Glutamic acid decarboxylase (GAD) in basal forebrain at p21')
% 
% subplot(5,1,5) 
% shading flat;
% grid on;
% axis equal;
% histogram(BF_P28_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in basal forebrain')
% title('Glutamic acid decarboxylase (GAD) in basal forebrain at p28')
% 
% figure; 
% subplot(5,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P0_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in medial septum')
% title('Glutamic acid decarboxylase (GAD) in medial septum at p0')
% 
% subplot(5,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P7_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in medial septum')
% title('Glutamic acid decarboxylase (GAD) in medial septum at p7')
% 
% subplot(5,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P14_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in medial septum')
% title('Glutamic acid decarboxylase (GAD) in medial septum at p14')
% 
% subplot(5,1,4) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P21_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in medial septum')
% title('Glutamic acid decarboxylase (GAD) in medial septum at p21')
% 
% subplot(5,1,5) 
% shading flat;
% grid on;
% axis equal;
% histogram(MS_P28_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in medial septum')
% title('Glutamic acid decarboxylase (GAD) in medial septum at p28')
% 
% %STR
% 
% figure; 
% subplot(3,1,1) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P0_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in striatum')
% title('Glutamic acid decarboxylase (GAD) in striatum at p0')
% 
% subplot(3,1,2) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P7_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in striatum')
% title('Glutamic acid decarboxylase (GAD) in striatum at p7')
% 
% 
% subplot(3,1,3) 
% shading flat;
% grid on;
% axis equal;
% histogram(STR_P21_clean(:,6));
% xlabel('histogram of Glutamic acid decarboxylase (GAD) % coverage in striatum')
% title('Glutamic acid decarboxylase (GAD) in striatum at p21')
% 
% 
% 
% %%
% 
% 
% %visualization of graphs - CDF - CHAT mean intensity 1. BF 2. MS. 3. STR        
% 
% 
% figure; 
% subplot(3,1,1) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(BF_P0_clean(:,1)) 
% hold on;cdfplot(BF_P7_clean(:,1)); cdfplot(BF_P14_clean(:,1)); cdfplot(BF_P21_clean(:,1)); cdfplot(BF_P28_clean(:,1));
% ylabel('probability')
% xlabel('Choline Acetyltransferase mean intensity in basal forebrain')
% title('Choline Acetyltransferase in basal forebrain at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% 
% subplot(3,1,2) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(MS_P0_clean(:,1));
% hold on; cdfplot(MS_P7_clean(:,1)); cdfplot(MS_P14_clean(:,1)); cdfplot(MS_P21_clean(:,1)); cdfplot(MS_P28_clean(:,1))
% ylabel('probability')
% xlabel('Choline Acetyltransferase mean intensity in medial septum ')
% title('Choline Acetyltransferase in medial septum at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% subplot(3,1,3) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(STR_P0_clean(:,1)) 
% hold on; cdfplot(STR_P7_clean(:,1));  cdfplot(STR_P21_clean(:,1)); 
% ylabel('probability')
% xlabel('Choline Acetyltransferase mean intensity in striatum')
% title('Choline Acetyltransferase in striatum at p0 - p28')
% legend('P0', 'P7','P21')
% %%
% %visualization of graphs - VGAT mean intensity 1. BF 2. MS. 3. STR        
% 
% figure;
% subplot(3,1,1) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(BF_P0_clean(:,2)); 
% hold on; cdfplot(BF_P7_clean(:,2)); cdfplot(BF_P14_clean(:,2)); cdfplot(BF_P21_clean(:,2)); cdfplot(BF_P28_clean(:,2));
% ylabel('probability')
% xlabel('mean intensity of Vesicular GABA Transporter (VGAT) in basal forebrain')
% title('Vesicular GABA Transporter (VGAT) in basal forebrain at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% 
% 
% subplot(3,1,2) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(MS_P0_clean(:,2));
% hold on; cdfplot(MS_P7_clean(:,2)); cdfplot(MS_P14_clean(:,2)); cdfplot(MS_P21_clean(:,2)); cdfplot(MS_P28_clean(:,2))
% ylabel('probability')
% xlabel('mean intensity of Vesicular GABA Transporter (VGAT) in medial septum ')
% title('Vesicular GABA Transporter (VGAT) in medial septum at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
%  
% subplot(3,1,3) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(STR_P0_clean(:,2)) 
% hold on; cdfplot(STR_P7_clean(:,2));  cdfplot(STR_P21_clean(:,2)); 
% ylabel('probability')
% xlabel('mean intensity of Vesicular GABA Transporter (VGAT) in striatum')
% title('Vesicular GABA Transporter (VGAT)  in striatum at p0 - p28')
% legend('P0', 'P7','P21')
% 
% %% 
% %visualization of graphs - GAD mean intensity 1. BF 2. MS. 3. STR      
% figure; 
% subplot(3,1,1) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(BF_P0_clean(:,3)) 
% hold on; cdfplot(BF_P7_clean(:,3)); cdfplot(BF_P14_clean(:,3)); cdfplot(BF_P21_clean(:,3)); cdfplot(BF_P28_clean(:,3))
% ylabel('probability')
% xlabel('mean intensity of glutamic acid decarboxylase (GAD) in basal forebrain')
% title('Vglutamic acid decarboxylase (GAD) in basal forebrain at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% subplot(3,1,2) 
% shading flat;
% grid on;
% axis equal; 
% cdfplot(MS_P0_clean(:,3)) 
% hold on; cdfplot(MS_P7_clean(:,3)); cdfplot(MS_P14_clean(:,3)); cdfplot(MS_P21_clean(:,3)); cdfplot(MS_P28_clean(:,3))
% ylabel('probability')
% xlabel('mean intensity of glutamic acid decarboxylase (GAD) in medial septum ')
% title('glutamic acid decarboxylase (GAD) in medial septum at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% subplot(3,1,3) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(STR_P0_clean(:,3)) 
% hold on; cdfplot(STR_P7_clean(:,3));  cdfplot(STR_P21_clean(:,3)); 
% ylabel('probability')
% xlabel('mean intensity of glutamic acid decarboxylase (GAD) in striatum')
% title('glutamic acid decarboxylase (GAD) in striatum at p0 - p28')
% legend('P0', 'P7','P21')
% %%
% %visualization of graphs - CHAT coverage 1. BF 2. MS. 3. STR
% figure; 
% subplot(3,1,1) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(BF_P0_clean(:,4)) 
% hold on; cdfplot(BF_P7_clean(:,4)); cdfplot(BF_P14_clean(:,4)); cdfplot(BF_P21_clean(:,4)); cdfplot(BF_P28_clean(:,4))
% ylabel('probability')
% xlabel('percentage coverage of Choline Acetyltransferase in basal forebrain')
% title('Choline Acetyltransferase coverage in basal forebrain at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% subplot(3,1,2) 
% shading flat;
% grid on;
% axis equal; cdfplot(MS_P0_clean(:,4)) 
% hold on; cdfplot(MS_P7_clean(:,4)); cdfplot(MS_P14_clean(:,4)); cdfplot(MS_P21_clean(:,4)); cdfplot(MS_P28_clean(:,4))
% ylabel('probability')
% xlabel('percentage coverage of Choline Acetyltransferase in medial septum ')
% title('Choline Acetyltransferase coverage in medial septum at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% subplot(3,1,3) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(STR_P0_clean(:,4)) 
% hold on; cdfplot(STR_P7_clean(:,4));  cdfplot(STR_P21_clean(:,4)); 
% ylabel('probability')
% xlabel('percentage coverage of Choline Acetyltransferase in striatum')
% title('Choline Acetyltransferase coverage in striatum at p0 - p28')
% legend('P0', 'P7','P21')
% 
% %%
% %visualization of graphs - VGAT coverage 1. BF 2. MS. 3. STR
% figure; 
% subplot(3,1,1) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(BF_P0_clean(:,5)) 
% hold on; cdfplot(BF_P7_clean(:,5)); cdfplot(BF_P14_clean(:,5)); cdfplot(BF_P21_clean(:,5)); cdfplot(BF_P28_clean(:,5))
% ylabel('probability')
% xlabel('percentage coverage of Vesicular GABA Transporter (VGAT) in basal forebrain')
% title('Vesicular GABA Transporter (VGAT) coverage in basal forebrain at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% subplot(3,1,2) 
% shading flat;
% grid on;
% axis equal; cdfplot(MS_P0_clean(:,5)) 
% hold on; cdfplot(MS_P7_clean(:,5)); cdfplot(MS_P14_clean(:,5)); cdfplot(MS_P21_clean(:,5)); cdfplot(MS_P28_clean(:,5))
% ylabel('probability')
% xlabel('percentage coverage of Vesicular GABA Transporter (VGAT) in medial septum ')
% title('Vesicular GABA Transporter (VGAT) coverage in medial septum at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% subplot(3,1,3) 
% shading flat;
% grid on;
% axis equal; cdfplot(STR_P0_clean(:,5)) 
% hold on; cdfplot(STR_P7_clean(:,5));  cdfplot(STR_P21_clean(:,5)); 
% ylabel('probability')
% xlabel('percentage coverage of Vesicular GABA Transporter (VGAT) in striatum')
% title('Vesicular GABA Transporter (VGAT) coverage in striatum at p0 - p28')
% legend('P0', 'P7','P21')
% 
% %%
% %visualization of graphs - GAD coverage 1. BF 2. MS. 3. STR
% figure; 
% subplot(3,1,1) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(BF_P0_clean(:,6)) 
% hold on; cdfplot(BF_P7_clean(:,6)); cdfplot(BF_P14_clean(:,6)); cdfplot(BF_P21_clean(:,6)); cdfplot(BF_P28_clean(:,6))
% ylabel('probability')
% xlabel('percentage coverage of glutamic acid decarboxylase (GAD) in basal forebrain')
% title('glutamic acid decarboxylase (GAD) coverage in basal forebrain at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% subplot(3,1,2) 
% shading flat;
% grid on;
% axis equal; cdfplot(MS_P0_clean(:,6)) 
% hold on; cdfplot(MS_P7_clean(:,6)); cdfplot(MS_P14_clean(:,6)); cdfplot(MS_P21_clean(:,6)); cdfplot(MS_P28_clean(:,6))
% ylabel('probability')
% xlabel('percentage coverage of glutamic acid decarboxylase (GAD) in medial septum ')
% title('glutamic acid decarboxylase (GAD) coverage in medial septum at p0 - p28')
% legend('P0', 'P7','P14','P21','P28')
% 
% subplot(3,1,3) 
% shading flat;
% grid on;
% axis equal;
% cdfplot(STR_P0_clean(:,6)) 
% hold on; cdfplot(STR_P7_clean(:,6));  cdfplot(STR_P21_clean(:,6)); 
% ylabel('probability')
% xlabel('percentage coverage of glutamic acid decarboxylase (GAD) in striatum')
% title('glutamic acid decarboxylase (GAD) coverage in striatum at p0 - p28')
% legend('P0', 'P7','P21')
% 
% %%

% %%
% % divide data based on threshold : COL1 above threshold, COL2 below
% % threshold 1. BF
% z = struct('above_threshold',[],'below_threshold',[]);
% c = struct('timepoint',{},'data',{});
% file_total = {'BF_P0_clean','BF_P7_clean','BF_P14_clean','BF_P21_clean','BF_P28_clean'}
% for a = length(file_total)
%     z.a =zeros(800,2);
%     b = eval(file_total{1})
%     line_no1 = 1;
%     line_no2 = 1
%     for i = 1:length(b(1))
%         if b(i) >= 1.8674e+03
%             z.a(line_no1) = cell2mat(b(i));
%             z.timepoint(a) = b;
%             
%         end
%     end
% end
% 
%     
%         
%         
%         
