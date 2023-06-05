from __future__ import division
import scipy.io
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

mat_file_name = "adult_masterfile_added.mat"

region_pool = ['BF','MS']
mouse_id = ['AG99', 'AG104', 'AG103', 'AG96a', 'KM11','KM12']

mat = scipy.io.loadmat(mat_file_name)


'''
my_string_list = mat["adult_masterfile_added"][300][0][0].split("ChAT in situ project")[1].split("\\")
print(my_string_list[3])
print(len(mat.keys()))

'''
#Create a dictionary in which key corresponds to a kep tuple with time, region and mouse id,
#and its value is a list of three values- percentage coverage for Chat, VGAT and GAD.
#eg: value - [0.01, 0.2, 0.3]

def extract(mat, name):

    # key of result is (time, region, mouse)
    result = dict()

    # traverse through each row in table CAUTION: total 380 rows in this specific context
    for i in range(len(mat[name])):
        my_string_list = mat[name][i][0][0].split("ChAT in situ project")[1]
        key_tuple = (get_region_string(my_string_list),
                     get_mouse_string(my_string_list))
        value_list = []
        for j in [5, 6, 7]:
            value_list.append(mat[name][i][j][0][0])
        if key_tuple not in result:
            result[key_tuple] = []
            result[key_tuple].append(value_list)
        else:
            result[key_tuple].append(value_list)

    return result



def get_region_string(my_string_list):
    my_string = my_string_list
    for region in region_pool:
        if region in my_string:
            return region


def get_mouse_string(my_string_list):
    my_string = my_string_list
    for ids in mouse_id:
        if ids in my_string:
            return ids



# compile individual list into three giant list containing data of col4, col 5, col6 (% coverage for chat, VGAT and GAD)
def extract_col(result):
    new_list = dict()
    for key in result.keys():
        percov_list = []
        percov_list.append(list())
        percov_list.append(list())
        percov_list.append(list())
        for i in range(len(result[key])):
            percov_list[0].append(result[key][i][0])
            percov_list[1].append(result[key][i][1])
            percov_list[2].append(result[key][i][2])
        new_list[key] = percov_list
    return new_list


#create a new list with one column is used to define positive or negative cells
def define_threshold(threshold,result,col1):
    # col1 is the column at which threshold is defined,[0,2]
    filtered_list = dict()
    for key in result.keys():
        percovthres_list = [list(), list(), list()]
        total_sum = 0
        count = 0
        for i in range(len(result[key][col1])):
            if result[key][col1][i] >= threshold:
                count += 1
                percovthres_list[0].append(result[key][0][i])
                percovthres_list[1].append(result[key][1][i])
                percovthres_list[2].append(result[key][2][i])
        if percovthres_list == [[],[],[]]:
            percovthres_list = [[0],[0],[0]]
        filtered_list[key] = percovthres_list
    return filtered_list
def plot_dotplot2(dict_1,dict_2, col,brain_region):
#Compare the number of dict 1 over dict 2 to find percentage of cells positive for a certain paramters.
    #col 0 = chat,1 = VGAT, col 2 = GAD.dict_1 will be outcome. dict_2 will be filtered list. This function will
    #return a final dict with 
    my_dict = dict()
    for key in dict_1.keys():
        if key[0] == brain_region:
            new_key = key
            if (dict_2)[new_key]==[[0], [0], [0]]:
                y_coord = 0
                my_dict[new_key] = 0
            else:
                y_coord = len((dict_2)[new_key][0])/len((dict_1)[new_key][0])
                my_dict[new_key] = y_coord
    return my_dict



def perc_pos_cell_sum(outcome, threshold, thres_col,brain_region):
    #this function will provide a dict based on 'outcome' list. Threshold is the value you choose to filter out lines in thres_col.
    #threshold_col takes value from 0 to 2. 0 is chat. 1 is VGAT and 2 is GAD percentage coverage. 
    dict_2= define_threshold(threshold,outcome,thres_col)
    return plot_dotplot2(outcome,dict_2, thres_col,brain_region)

def double_positive(outcome, threshold,brain_region):
#Percentage for cells that are double positive for VGAT and GAD
    VGAT_positive = define_threshold(threshold,outcome,1)
    Double_positive = define_threshold(threshold, VGAT_positive,2)
    y = plot_dotplot2(outcome,Double_positive,1,brain_region)
    #output col is going to be the same no matter what - unnecessary 
    return  y

def average_dict (my_dict):
    sum_of_list = 0
    count = 0
    for key in my_dict.keys():
        sum_of_list += my_dict [key]
        count += 1
    average = sum_of_list/count
    return average

        
#INPUT FOR FINAL FUNCTION
#EXTRACTION
result = extract(mat, 'Adult_masterfile')
outcome = extract_col(result)

#THRESHOLDING
threshold = 0.05

#VISUALIZATION
x = [1,2]
width = 0.2       
fig, ax = plt.subplots(3, figsize=(8,10), dpi=80)
#Create a list where VGAT and GAD percentage coverage higher than 0.05
VGAT_BF = perc_pos_cell_sum(outcome, threshold,1,'BF')
VGAT_MS = perc_pos_cell_sum(outcome, threshold,1,'MS')
GAD_BF = perc_pos_cell_sum(outcome, threshold,2,'BF')
GAD_MS = perc_pos_cell_sum(outcome, threshold,2,'MS')
Copositive_BF = double_positive(outcome, threshold,'BF')
Copositive_MS = double_positive(outcome, threshold,'MS')
print(VGAT_BF, VGAT_MS, GAD_BF, GAD_MS,Copositive_BF,Copositive_MS)



#Calculate average
BF_VGAT_avg_data = average_dict(VGAT_BF)
MS_VGAT_avg_data = average_dict(VGAT_MS)
BF_GAD_avg_data = average_dict(GAD_BF)
MS_GAD_avg_data = average_dict(GAD_MS)
BF_VGAT_GAD_avg_data = average_dict(Copositive_BF)
MS_VGAT_GAD_avg_data = average_dict(Copositive_MS)

labels = list(outcome.keys())

VGAT_BF_list =list(VGAT_BF.values())
VGAT_MS_list =list(VGAT_MS.values())
GAD_BF_list =list(GAD_BF.values())
GAD_MS_list =list(GAD_MS.values())
VGAT_GAD_BF_list =list(Copositive_BF.values())
VGAT_GAD_MS_list =list(Copositive_MS.values())


#Visualization of bar graph 
labels = ['BF','MS']
x1 = [1,1,1,1,1]
x2 = [2,2,2,2]
ax[0].bar(1, BF_VGAT_avg_data, width)
ax[0].bar(2, MS_VGAT_avg_data, width)
ax[1].bar(1, BF_GAD_avg_data, width)
ax[1].bar(2, MS_GAD_avg_data, width)
ax[2].bar(1, BF_VGAT_GAD_avg_data, width)
ax[2].bar(2, MS_VGAT_GAD_avg_data, width)
print(VGAT_MS.values())



ax[0].scatter(x1, VGAT_BF.values(),color='black', s=10)
ax[1].scatter(x1, GAD_BF.values(),color='black', s=10)
ax[2].scatter(x1, Copositive_BF.values(),color='black', s=10)
ax[0].scatter(x2, VGAT_MS.values(),color='black', s=10)
ax[1].scatter(x2, GAD_MS.values(),color='black', s=10)
ax[2].scatter(x2, Copositive_MS.values(),color='black', s=10)
ax[0].set_ylabel('Proportion of VGAT+ ChAT+ neurons', size = 9)
ax[1].set_ylabel('Proportion of GAD1/2+ ChAT+ neurons', size=9)
ax[2].set_ylabel('Proportion of ChAT+ neurons that are\n co-positive for VGAT and GAD1/2  ', size = 9)

for n in range(3):
    ax[n].set_xticks(x, labels)
    ax[n].set_xlim(0,3)
    ax[n].set_ylim(0,1)

    
plt.tight_layout()
plt.show()



# Output all data to a csv file
import csv
with open('ChAT_FISH_adult_VGAT','w', newline = '\n') as file:
    writer = csv.writer(file)
    writer.writerow(["Mouse ID", "total cells", "Positive cells", "percentage"])
    filtered_dict_VGAT = define_threshold(threshold,outcome,1)
    for key in VGAT_BF:
        if filtered_dict_VGAT[key]== [[0],[0],[0]]:
            writer.writerow([key, len(outcome[key][0]), 0,
                             VGAT_BF[key], BF_VGAT_avg_data])
        else:
            writer.writerow([key, len(outcome[key][0]), len(filtered_dict_VGAT[key][0]),
                             VGAT_BF[key], BF_VGAT_avg_data])
    for key in VGAT_MS:
        if filtered_dict_VGAT[key]== [[0],[0],[0]]:
            writer.writerow([key, len(outcome[key][0]), 0,
                             VGAT_MS[key], MS_VGAT_avg_data])
        else:
            writer.writerow([key, len(outcome[key][0]), len(filtered_dict_VGAT[key][0]),
                             VGAT_MS[key], MS_VGAT_avg_data])
  

with open('ChAT_FISH_adult_GAD','w', newline = '\n') as file:
    writer = csv.writer(file)
    writer.writerow(["Mouse ID", "total cells", "Positive cells", "percentage"])
    filtered_dict_GAD = define_threshold(threshold,outcome,2)
    for key in GAD_BF:
        if filtered_dict_GAD[key]== [[0],[0],[0]]:
            writer.writerow([key, len(outcome[key][0]), 0,
                             GAD_BF[key], BF_GAD_avg_data])
        else:
            writer.writerow([key, len(outcome[key][0]), len(filtered_dict_GAD[key][0]),
                             GAD_BF[key], BF_GAD_avg_data])
            
    for key in GAD_MS:
        if filtered_dict_GAD[key]== [[0],[0],[0]]:
            writer.writerow([key, len(outcome[key][0]), 0,
                             GAD_MS[key], MS_GAD_avg_data])
        else:
            writer.writerow([key, len(outcome[key][0]), len(filtered_dict_GAD[key][0]),
                             GAD_MS[key], MS_GAD_avg_data])

VGAT_positive = define_threshold(threshold,outcome,1)
Double_positive = define_threshold(threshold, VGAT_positive,2)
print(Double_positive)
with open('ChAT_FISH_adult_copositive','w', newline = '\n') as file:
    writer = csv.writer(file)
    writer.writerow(["Mouse ID", "total cells", "Positive cells", "percentage"])
    for key in Copositive_BF:
        if Double_positive[key] == [[0],[0],[0]]:
            writer.writerow([key, len(outcome[key][0]), 0, Copositive_BF[key], BF_VGAT_GAD_avg_data])
        else:
            writer.writerow([key, len(outcome[key][0]), len(Double_positive[key][0]), Copositive_BF[key],
                             BF_VGAT_GAD_avg_data])
    for key in Copositive_MS:
        if Double_positive[key] == [[0],[0],[0]]:
            writer.writerow([key, len(outcome[key][0]), 0, Copositive_MS[key], MS_VGAT_GAD_avg_data])
        else:
            writer.writerow([key, len(outcome[key][0]), len(Double_positive[key][0]), Copositive_MS[key],
                             MS_VGAT_GAD_avg_data])


    



