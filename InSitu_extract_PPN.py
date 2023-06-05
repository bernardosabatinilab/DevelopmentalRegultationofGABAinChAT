from __future__ import division
import scipy.io
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

mat_file_name = "PPN_masterfile.mat"

region_pool = ['PPN']

mat = scipy.io.loadmat(mat_file_name)
'''
print(len(mat['PPN_masterfile']))
print(mat['PPN_masterfile'][0][5][0][0])
string = (mat['PPN_masterfile'][1][0][0].split("ChAT in situ project")[1].split("/"))
print(string)
print(mat['PPN_masterfile'][1][5])
'''
#Create a dictionary in which key corresponds to a kep tuple with time, region and mouse id,
#and its value is a list of three values- percentage coverage for Chat, VGAT and GAD.
#eg: value - [0.01, 0.2, 0.3]

def extract(mat, name):

    # key of result is (time, region, mouse)
    result = dict()

    # traverse through each row in table
    for i in range(len(mat[name])-1):
        my_string_list = mat[name][i][0][0].split("ChAT in situ project")[1].split("/")
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
    my_string = my_string_list[1]
    for region in region_pool:
        if region in my_string:
            return region


def get_mouse_string(my_string_list):
    my_string = my_string_list[2]
    return my_string


result = extract(mat, 'PPN_masterfile')






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
#INPUT FOR FINAL FUNCTION
outcome = extract_col(result)

'''
print(outcome.keys())
print(outcome.values())
'''

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

def plot_dotplot2(dict_1,dict_2, col):
#Compare the number of dict 1 over dict 2 to find percentage of cells positive for a certain paramters.
    #col 0 = chat,1 = VGAT, col 2 = GAD.dict_1 will be outcome. dict_2 will be filtered list. So It will return a list of three values
    #corresponding [('PPN', 'KM2'), ('PPN', 'KM3'), ('PPN', 'KM4')]
    y_dict = {}
    for key in dict_1.keys():
        if key[0] == 'PPN':
            new_key = key
            #Noted that dict_2 are filtered list based on the threshold for one column
        if (dict_2)[key][0] == [0] and (dict_2)[key][1] == [0] and (dict_2)[key][2] == [0]: #needs to look at previous pipeline
                y_coord = 0/len((dict_1)[key][col])
                y_dict[key] = y_coord
        else:
            y_coord = len((dict_2)[key][col])/len((dict_1)[key][col])
            y_dict[key] = y_coord
    return y_dict



def perc_pos_cell_sum(outcome, threshold, thres_col):
    #this function will create a dict based on 'outcome' list. Threshold is the value you choose to filter out lines in thres_col.
    #threshold_col takes value from 0 to 2. 0 is chat. 1 is VGAT and 2 is GAD percentage coverage. 
    dict_2= define_threshold(threshold,outcome,thres_col)
    y_dict = plot_dotplot2(outcome,dict_2, thres_col)
    return y_dict

def double_positive(outcome, threshold):
#Percentage for cells that are doubel positive for VGAT and GAD
    VGAT_positive = define_threshold(threshold,outcome,1)
    Double_positive = define_threshold(threshold, VGAT_positive,2)
    y_dict = plot_dotplot2(outcome,Double_positive,1)
    #output col is going to be the same no matter what - unnecessary 
    return  y_dict

threshold = 0.05
filtered_list =  define_threshold(0.05, outcome,1)
filtered_list2 =  define_threshold(0.05, outcome,2)
filtered_list3 =  define_threshold(0.05, filtered_list,2)
x = [1,2,3]
y_bar = [0,0.1,0.2]
labels  = ["Mouse 1", "Mouse 2", "Mouse 3"]
width = 0.2       
fig, ax = plt.subplots(3, figsize=(8,10), dpi=80)
#Create a list where VGAT and GAD percentage coverage higher than 0.05
VGAT = perc_pos_cell_sum(outcome, threshold,1)
GAD = perc_pos_cell_sum(outcome, threshold,2)
Cop = double_positive(outcome, threshold)
print(outcome)
print(filtered_list)
print(VGAT, GAD, Cop)

# Output all data to a csv file
import csv
with open('ChAT_FISH_PPN','w', newline = '\n') as file:
    writer = csv.writer(file)
    writer.writerow(["GABAergic Markers", "Mouse ID", "total cells", "Positive cells", "percentage"])
    for key in outcome:
        if filtered_list[key] == [[0],[0],[0]]:
             writer.writerow(["VGAT",key, len(outcome[key][0]), 0,VGAT[key]])
        else:
            writer.writerow(["VGAT", key, len(outcome[key][0]), len(filtered_list[key][0]),VGAT[key]])
    
    for key in outcome:
        if filtered_list2[key] == [[0],[0],[0]]:
             writer.writerow(["GAD",key, len(outcome[key][0]), 0,GAD[key]])
        else:
            writer.writerow(["GAD", key, len(outcome[key][0]), len(filtered_list2[key][0]),GAD[key]])
    for key in outcome:
        if filtered_list3[key] == [[0],[0],[0]]:
             writer.writerow(["Co-positive",key, len(outcome[key][0]), 0,Cop[key]])
        else:
            writer.writerow(["Co-positive", key, len(outcome[key][0]), len(filtered_list3[key][0]),Cop[key]])

'''
#Visualization of bar graph 

ax[0].bar(x, y1, width)
ax[1].bar(x, y2, width)
ax[2].bar(x, y3, width)

ax[0].set_ylabel('Proportion of VGAT+ ChAT+ neurons in PPN', size = 9)
ax[1].set_ylabel('Proportion of GAD1/2+ ChAT+ neurons in PPN', size=9)
ax[2].set_ylabel('Proportion of ChAT+ neurons that are\n co-positive for VGAT and GAD1/2 in PPN ', size = 9)

for n in range(3):
    ax[n].set_xticks(x, labels)
    ax[n].set_xlim(0,4)
    ax[n].set_ylim(0,0.2)
    ax[n].set_yticks(y_bar)
    
    
plt.tight_layout()
plt.show()

#Visualization of cdf for PPN
color = sns.color_palette("bright")
fig, axes = plt.subplots(sharey=True)
fig.suptitle('Percentage Coverage of GABAergic markers in PPN Cholinergic neurons')
for key in outcome.keys():
    VGAT_PPN=[]
    GAD_PPN = []
    for i in outcome[key][1]:
        VGAT_PPN.append(i)
    for f in outcome[key][2]:
        GAD_PPN.append(f)
sns.ecdfplot(data = VGAT_PPN, stat='proportion', legend = False)
sns.ecdfplot(data = GAD_PPN, stat='proportion', legend = False)
axes.set_xlabel('Percentage Coverage of GABAergic markers in ChAT+ neurons in PPN')
plt.legend(title='GABAergic Markers', loc='best', labels=['VGAT', 'GAD1/2'])
plt.show()
'''

