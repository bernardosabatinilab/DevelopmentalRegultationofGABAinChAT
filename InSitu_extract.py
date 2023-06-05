from __future__ import division
import scipy.io
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

mat_file_name = "Masterfile.mat"


time_pool = ['P0', 'P7', 'P14', 'P21', 'P28']
region_pool = ['BF', 'MS']

mat = scipy.io.loadmat(mat_file_name)


#print(mat['masterfile'])
#print(mat['masterfile'][0][5][0][0])

#Create a dictionary in which key corresponds to a kep tuple with time, region and mouse id,
#and its value is a list of three values- percentage coverage for Chat, VGAT and GAD.
#eg: value - [0.01, 0.2, 0.3]

def extract(mat, name):
    # key of result is (time, region, mouse)
    result = dict()

    # traverse through each row in table
    for i in range(len(mat[name])):
        my_string_list = mat[name][i][0][0].split("KEYENCE IMAGES")[1].split("\\")
        if not get_region_string(my_string_list):
            continue

        key_tuple = (get_time_string(my_string_list),
                     get_region_string(my_string_list),
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


def get_time_string(my_string_list):
    my_string = my_string_list[1]
    for time in time_pool:
        if time in my_string:
            return time


def get_region_string(my_string_list):
    my_string = my_string_list[3]
    for region in region_pool:
        if region in my_string:
            return region


def get_mouse_string(my_string_list):
    my_string = my_string_list[2]
    return my_string


result = extract(mat, 'masterfile')

'''
for key in result.keys():
    print(key)
    counter += 1

print("there are", counter, "keys")
print(result[('P0', 'BF', '9g')])

'''
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
                total_sum += result[key][col1][i]
                count += 1
                percovthres_list[0].append(result[key][0][i])
                percovthres_list[1].append(result[key][1][i])
                percovthres_list[2].append(result[key][2][i])
        if percovthres_list == [[],[],[]]:
            percovthres_list = [[0],[0],[0]]
        filtered_list[key] = percovthres_list
    return filtered_list

'''
def avg_per_coverage (filtered_dict):
    # filtered_list is a dict. This function will return a dict with each key corresponding to a list consisted on
    # three values [CHAT average, VGAT average and GAD average].
    avg_dict = dict()
    for key in filtered_dict.keys():
        avg_list = []
        for i in range(len(filtered_dict[key])):
            sum = 0
            count = 0
            for j in range(len(filtered_dict[key][i])):
                sum += filtered_dict[key][i][j]
                count += 1
            avg_list.append(sum/count)
        avg_dict[key] = avg_list
    return avg_dict
#A new list with GAD positive cells that are defined by the threshold of 0.05.
filtered_list =  define_threshold(0.05, outcome,2)
data = avg_per_coverage(define_threshold(0.05,outcome,2))



def avg_positive_cells (filtered_dict):
        # filtered_list is a dict. This function will return a dict with each key corresponding to a list consisted on
        # three values [number of cells positive ChAt, number of VGAT+ cells, and number of GAD+ cells].
        avg_dict = dict()
        for key in filtered_dict.keys():
            avg_list = []
            for i in range(len(filtered_dict[key])):
                count = 0
                for j in range(len(filtered_dict[key][i])):
                    sum += filtered_dict[key][i][j]
                    count += 1
                avg_list.append(sum / count)
            avg_dict[key] = avg_list
        return avg_dict
   
def plot_dotplot1(avg_dict,col,brain_region):
#col extracts the average percentage coverage of the corresponding marker in avg_dict. col 0 = chat,
#col 1 = VGAT, col 2 = GAD
    data_X = []
    data_Y = []
    for key in avg_dict.keys():
        if key[1] == brain_region:
            new_key = key
            x_coord = int(new_key[0].lstrip('P'))
            y_coord = avg_per_coverage (filtered_list)[key][col]
            data_X.append(x_coord)
            data_Y.append(y_coord)
    return data_X, data_Y
print(outcome.keys())
print(filtered_list.keys())
print(plot_dotplot1(data, 1,'BF'))

'''

def plot_dotplot2(dict_1,dict_2, col,brain_region):
#Compare the number of dict 1 over dict 2 to find percentage of cells positive for a certain paramters.
    #col 0 = chat,1 = VGAT, col 2 = GAD.dict_1 will be outcome. dict_2 will be filtered list.
    x_list = []
    y_list = []
    for key in dict_1.keys():
        if key[1] == brain_region:
            new_key = key
            x_coord = int(new_key[0].lstrip('P'))
            if (dict_2)[new_key]==[[0], [0], [0]]:
                y_coord = 0
                x_list.append(x_coord)
                y_list.append(y_coord)
            else:
                y_coord = len((dict_2)[key][col])/len((dict_1)[key][col])
                x_list.append(x_coord)
                y_list.append(y_coord)
    return x_list, y_list

def plot_dotplot2_dict(dict_1,dict_2, col):
#Compare the number of dict 1 over dict 2 to find percentage of cells positive for a certain paramters.
    #col 0 = chat,1 = VGAT, col 2 = GAD.dict_1 will be outcome. dict_2 will be filtered list.
    new_dict = {}
    for key in dict_1.keys():
        if (dict_2)[key]==[[0], [0], [0]]:
            y_coord = 0
            new_dict[key] = y_coord
        else:
            y_coord = len((dict_2)[key][col])/len((dict_1)[key][col])
            new_dict[key] = y_coord
    return new_dict

def scatter_hist(x, y, ax):

        # the scatter plot:
            ax.scatter(x, y)

        # now determine nice limits by hand:
            binwidth = 0.25
            xymax = max(np.max(np.abs(x)), np.max(np.abs(y)))
            lim = (int(xymax/binwidth) + 1) * binwidth

            bins = np.arange(-lim, lim + binwidth, binwidth)


def perc_pos_cell_sum(outcome, threshold, thres_col,brain_region):
    #this function will draw a dotplot based on 'outcome' list. Threshold is the value you choose to filter out lines in thres_col.
    #threshold_col takes value from 0 to 2. O is chat. 1 is VGAT and 2 is GAD percentage coverage. 
    #brain region is a string that can be 'BF', 'MS', 'STR' and output_col is what the graph concerns for percentage of positive cells.
    dict_2= define_threshold(threshold,outcome,thres_col)
    x_list = []
    y_list = []
    x = plot_dotplot2(outcome,dict_2,thres_col ,brain_region)[0]
    y = plot_dotplot2(outcome,dict_2, thres_col,brain_region)[1]
    x_list.append(x)
    y_list.append(y)
    return x_list, y_list

def double_positive(outcome, threshold, brain_region):
#Percentage for cells that are doubel positive for VGAT and GAD
    VGAT_positive = define_threshold(threshold,outcome,1)
    Double_positive = define_threshold(threshold, VGAT_positive,2)
    x_list = []
    y_list = []
    x = plot_dotplot2(outcome,Double_positive,1,brain_region)[0]
    y = plot_dotplot2(outcome,Double_positive,1,brain_region)[1]
    #output col is going to be the same no matter what - unnecessary 
    x_list.append(x)
    y_list.append(y)
    return x_list, y_list



#visualization 
threshold = 0.05

x1 = perc_pos_cell_sum(outcome, threshold, 1,'BF')[0]
y1 = perc_pos_cell_sum(outcome, threshold, 1,'BF')[1]
x2 = perc_pos_cell_sum(outcome, threshold, 1,'MS')[0]
y2 = perc_pos_cell_sum(outcome, threshold, 1,'MS')[1]
x3 = perc_pos_cell_sum(outcome, threshold, 2,'BF')[0]
y3 = perc_pos_cell_sum(outcome, threshold, 2,'BF')[1]
x4 = perc_pos_cell_sum(outcome, threshold, 2,'MS')[0]
y4 = perc_pos_cell_sum(outcome, threshold, 2,'MS')[1]
#double positive
x5 = double_positive(outcome,threshold, 'BF')[0]
y5 = double_positive(outcome, threshold, 'BF')[1]
x6 = double_positive(outcome, threshold, 'MS')[0]
y6 = double_positive(outcome, threshold, 'MS')[1]


# Functions for re-organzing and calculation
def create_dict(x_value, y_value):
    #Organize the two lists into one single dict with values being timepoint (0,7,14,21,28) and each value corresponds to a list of value
    my_dictionary = {0 : [],7: [],14: [], 21 : [],28: []}
    for i in range(len(x_value[0])):
       my_dictionary[x_value[0][i]].append(y_value[0][i])
    return my_dictionary

def average_dict (my_dict):
    average_dictionary = {}
    for key in my_dict.keys():
        avg = np.mean(my_dict [key])
        average_dictionary[key] = avg
    return average_dictionary

def sem_dict (my_dict):
    sem_dictionary = {}
    for key in my_dict.keys():
        sem_dictionary[key] = np.std(my_dict [key], ddof=1) / np.sqrt(np.size(my_dict [key]))
    return sem_dictionary
        
#Load Data into four dicts

BF_VGAT_data = create_dict(x1,y1)
MS_VGAT_data = create_dict(x2,y2)
BF_GAD_data = create_dict(x3,y3)
MS_GAD_data = create_dict(x4,y4)
BF_VGAT_GAD_data = create_dict(x5,y5)
MS_VGAT_GAD_data = create_dict(x6,y6)

#Calculate average and standard deviation
BF_VGAT_avg_data = average_dict(BF_VGAT_data)
MS_VGAT_avg_data = average_dict(MS_VGAT_data)
BF_GAD_avg_data = average_dict(BF_GAD_data)
MS_GAD_avg_data = average_dict(MS_GAD_data)
BF_VGAT_GAD_avg_data = average_dict(BF_VGAT_GAD_data)
MS_VGAT_GAD_avg_data = average_dict(MS_VGAT_GAD_data)

BF_VGAT_sem_data = sem_dict(BF_VGAT_data)
MS_VGAT_sem_data = sem_dict(MS_VGAT_data)
BF_GAD_sem_data = sem_dict(BF_GAD_data)
MS_GAD_sem_data = sem_dict(MS_GAD_data)
BF_VGAT_GAD_sem_data = sem_dict(BF_VGAT_GAD_data)
MS_VGAT_GAD_sem_data = sem_dict(MS_VGAT_GAD_data)

print(BF_VGAT_data)
print(BF_VGAT_avg_data)
print(BF_VGAT_sem_data)
    
x = [0,7,14,21,28]
y = [0,0.25, 0.5, 0.75, 1.0]
# the label locations
width = 3.00  # the width of the bars

# Plot scatter 
fig, ax = plt.subplots(2, figsize=(8,8), dpi=80)
for key in BF_VGAT_data:
    rects1 = ax[0].bar(key ,BF_VGAT_avg_data[key] , width, yerr=BF_VGAT_sem_data[key], label='BF', alpha=0.5, ecolor='black', capsize=10,color=(0,0,0,0))
    rects2 = ax[1].bar(key , MS_VGAT_avg_data[key] , width, yerr=MS_VGAT_sem_data[key], label='MS', alpha=0.5, ecolor='black', capsize=10)


ax[0].scatter(x1, y1,color='black', s= 10)
ax[1].scatter(x2, y2,color='black', s= 10)


# Add some text for labels, title and custom x-axis tick labels, etc.
ax[0].set_xlabel('Days')
ax[0].set_ylabel('Proportion of VGAT+ ChAT+ neurons in basal forebrain', fontsize=9)
ax[0].set_xticks(x, x)
ax[0].set_yticks(y)
ax[0].set_ylim([0, 1])
ax[0].set_xlim([-1.5, 30])

ax[1].set_xlabel('Days')
ax[1].set_ylabel('Proportion of VGAT+ ChAT+ neurons in medial septum', fontsize=9)
ax[1].set_xticks(x, x)
ax[1].set_yticks(y)
ax[1].set_ylim([0, 1])
ax[1].set_xlim([-1.5, 30])

fig.tight_layout()

plt.show()

fig, ax = plt.subplots(2, figsize=(8,8), dpi=80)
for key in BF_GAD_data:
    rects3 = ax[0].bar(key ,BF_GAD_avg_data[key] , width, yerr=BF_GAD_sem_data[key], label='BF',
                       alpha=0.5, ecolor='black', capsize=10,color=(0,0,0,0))
    rects4 = ax[1].bar(key,MS_GAD_avg_data[key] , width, yerr=MS_GAD_sem_data[key], label='MS',
                       alpha=0.5, ecolor='black', capsize=10)

ax[0].scatter(x3, y3,color='black', s=10)
ax[1].scatter(x4, y4,color='black', s=10)


ax[0].set_xlabel('Days')
ax[0].set_ylabel('Proportion of GAD1/2+ ChAT+ neurons in Basal Forebrain', fontsize=9)
ax[0].set_xticks(x, x)
ax[0].set_ylim([0, 1])
ax[0].set_ylim([0, 1])
ax[0].set_xlim([-1.5, 30])

ax[1].set_xlabel('Days')
ax[1].set_ylabel('Proportion of GAD1/2+ ChAT+ neurons in medial septum', fontsize=9)
ax[1].set_xticks(x, x)
ax[1].set_ylim([0, 1])
ax[1].set_ylim([0, 1])
ax[1].set_xlim([-1.5, 30])


fig.tight_layout()

plt.show()


#double positive

fig, ax = plt.subplots(2, figsize=(8,10), dpi=80)
for key in BF_VGAT_GAD_data:
    rects1 = ax[0].bar(key ,BF_VGAT_GAD_avg_data[key] , width, yerr=BF_VGAT_GAD_sem_data[key], label='BF',
                   alpha=0.5, ecolor='black', capsize=10,color=(0,0,0,0))
    rects2 = ax[1].bar(key, MS_VGAT_GAD_avg_data[key] , width, yerr=MS_VGAT_GAD_sem_data[key],
                   label='MS', alpha=0.5, ecolor='black', capsize=10)

ax[0].scatter(x5, y5,color='black', s= 10)
ax[1].scatter(x6, y6, color='black', s= 10)

ax[0].set_xlabel("Days", fontsize=10)
ax[0].set_ylabel("Proportion of ChAT+neurons co-positive for VGAT and GAD in BF", fontsize=10)
ax[0].set_xticks(x, x)
ax[0].set_yticks(y)
ax[0].set_ylim([0, 1])
ax[0].set_xlim([-1.5, 30])

ax[1].set_xlabel("Days", fontsize=10)
ax[1].set_ylabel("Proportion of ChAT+neurons co-positive for VGAT and GAD in MS", fontsize=10)
ax[1].set_xticks(x, x)
ax[1].set_yticks(y)
ax[1].set_ylim([0, 1])
ax[1].set_xlim([-1.5, 30])

plt.tight_layout()
plt.show()

print(define_threshold(threshold,outcome,1))
#Visualization
# Output all data to a csv file
import csv
with open('ChAT_FISH_P0P28_scatter','w', newline = '\n') as file:
    writer = csv.writer(file)
    writer.writerow(["Marker", "mouse ID", "total cells", "positive cells", "percentage"])
    percentage_VGAT = plot_dotplot2_dict(outcome,define_threshold(threshold,outcome,1),1)
    percentage_GAD = plot_dotplot2_dict(outcome,define_threshold(threshold,outcome,2),2)
    VGAT_positive = define_threshold(threshold,outcome,1)
    Double_positive = define_threshold(threshold, VGAT_positive,2)
    percentage_VGATGAD = plot_dotplot2_dict(outcome,Double_positive,1)
    for key in outcome:
        if define_threshold(threshold,outcome,1)[key] ==[[0],[0],[0]]:
            writer.writerow(["VGAT", key, len(outcome[key][0]), 0,
                             percentage_VGAT[key]])
        else:
            writer.writerow(["VGAT", key, len(outcome[key][0]),
                             len(define_threshold(threshold,outcome,1)[key][0]),percentage_VGAT[key]])
    for key in outcome:
        if define_threshold(threshold,outcome,2)[key] == [[0],[0],[0]]:
            writer.writerow(["GAD1/2", key, len(outcome[key][0]), 0,
                             percentage_GAD[key]])
        else:
            writer.writerow(["GAD1/2", key, len(outcome[key][0]),
                             len(define_threshold(threshold,outcome,2)[key][0]),percentage_GAD[key]])
    for key in outcome:
        if Double_positive[key] == [[0],[0],[0]]:
            writer.writerow(["co-positive", key, len(outcome[key][0]), 0,percentage_VGATGAD[key]])
        else:
            writer.writerow(["co-positive", key, len(outcome[key][0]), len(Double_positive[key]),
                             percentage_VGATGAD[key]])
        
print(Double_positive)

with open('ChAT_FISH_P0P28_scatter_part2','w', newline = '\n') as file:
    writer = csv.writer(file)
    writer.writerow(["Marker", "brain region", "postnatal days", "scatterplot info", "average", "standard error"])
    for key in BF_VGAT_data:
        writer.writerow(["VGAT", "BF", key, BF_VGAT_data[key],
                         BF_VGAT_avg_data[key], BF_VGAT_sem_data[key]])
    for key in BF_GAD_data:
        writer.writerow(["GAD", "BF", key, BF_GAD_data[key],
                         BF_GAD_avg_data[key], BF_GAD_sem_data[key]])
    for key in MS_VGAT_data:
        writer.writerow(["VGAT", "MS", key, MS_VGAT_data[key],
                         MS_VGAT_avg_data[key], MS_VGAT_sem_data[key]])
    for key in MS_GAD_data:
        writer.writerow(["GAD", "MS", key, MS_GAD_data[key],
                         MS_GAD_avg_data[key], MS_GAD_sem_data[key]])      
    for key in BF_VGAT_GAD_data:
        writer.writerow(["Co-positive", "BF", key, BF_VGAT_GAD_data[key],
                         BF_VGAT_GAD_avg_data[key], BF_VGAT_GAD_sem_data[key]])
    for key in MS_VGAT_GAD_data:
        writer.writerow(["Co-positive", "MS", key, MS_VGAT_GAD_data[key],
                         MS_VGAT_GAD_avg_data[key], MS_VGAT_GAD_sem_data[key]])   





