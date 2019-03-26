# -*- coding: utf-8 -*-
"""
Created on Sun Jan 14 13:06:19 2018

@author: Dong Li
"""
import pandas as pd
import os
import scipy.io as sio
import numpy as np


def clear_data_name(charactors):
    charactors_copy=charactors
    Letter_pool='0123456789'
    for cha in charactors_copy:
        if cha not in Letter_pool:
            charactors_copy=charactors_copy.replace(cha,' ')
    return charactors_copy

traincog='1'
trainlevel=8
nametrainlist=['M226L5','M248L1','M248R3','M262L2','M262L3','M262R3','M339R5','M339R6']







area_processed=pd.read_csv('area_processed.csv')

refer_dict=pd.DataFrame(index = range(0,len(nametrainlist)))
refer_dict['reference']=nametrainlist

reference_layer_list=[]
layer_GY_list=[]
sim_list_folder=[]
n_realize_list=[]

os.chdir('..')
os.chdir('..')
os.chdir('data')





for iname in nametrainlist:
    print(iname)
    if iname == 'M226L5':
        reference_layer=[[1,2],[3],[4,5]]
        layer_GY=[[1,2],[3],[5]]
    elif iname == 'M248L1':
        reference_layer=[[1],[2],[3],[4],[5],[6,7]]
        layer_GY=[[1],[2],[3],[4],[5],[6]]
    elif iname == 'M248R3':
        reference_layer=[[1],[2,3],[4],[5]]
        layer_GY=[[1],[2,3],[4],[5]]
    elif iname == 'M262L2':
        reference_layer=[[1],[2],[3],[4],[5],[6,7],[8,9]]
        layer_GY=[[1],[2],[3],[4],[5],[6],[7]]
    elif iname == 'M262L3':
        reference_layer=[[1],[2],[3],[4],[5],[6],[7]]
        layer_GY=[[1],[2],[3],[4],[5],[6],[7]]
    elif iname == 'M262R3':
        reference_layer=[[1],[2],[3],[4],[5]]
        layer_GY=[[1],[2],[3],[4],[5]]
    elif iname == 'M339R5':
        reference_layer=[[1],[2],[3],[4,5],[6,7]]
        layer_GY=[[1],[2],[3],[5],[6]]
    elif iname == 'M339R6':
        reference_layer=[[1],[2],[3],[4]]
        layer_GY=[[1],[2],[3],[5]]

    reference_layer_list.append(reference_layer)
    layer_GY_list.append(layer_GY)
    
    n_realize=len([y for x in layer_GY for y in x])
    print(n_realize)
    n_realize_list.append(n_realize)
    
    os.chdir(iname)
    os.chdir('clustering')
    os.chdir(traincog)
    label=sio.loadmat('label.mat')    
    label0=label['idxz0']

    layer_cluster=label0[:,trainlevel]
    x0=area_processed['composition'][area_processed['Name']==iname].values[0]
    x1=clear_data_name(x0)
    x2=x1.split()
    composition_GY=[int(x) for x in x2]
                    
    n_com=np.min([len(layer_cluster),len(composition_GY)])

    lc_com=layer_cluster[range(0,n_com)]
    lg_com=composition_GY[0:n_com]
    
    lc_coms=np.array([0]*len(lc_com))
    lg_coms=np.array([0]*len(lg_com))
    
    for kk in reference_layer:
        ia=reference_layer.index(kk)+1
        for kki in kk:
            indices = [ii for ii, x in enumerate(lc_com) if x == kki]    
            lc_coms[indices]=ia
    for kk in layer_GY:
        ia=layer_GY.index(kk)+1
        for kki in kk:
            indices = [ii for ii, x in enumerate(lg_com) if x == kki]    
            lg_coms[indices]=ia

    com_diff=lc_coms-lg_coms
    com_diff_l=list(com_diff)
    n_zero=com_diff_l.count(0)
    
    sim=n_zero/n_com
    
    sim_list_folder.append(sim)

    os.chdir('..')
    
    os.chdir('..')
    
    os.chdir('..')
        
    
    
refer_dict['reference_layer']=reference_layer_list
refer_dict['layer_GY']=layer_GY_list
refer_dict['self_similarity']=sim_list_folder
refer_dict['layer_touched']=n_realize_list

os.chdir('..')

os.chdir('code')
os.chdir('evaluationsupervisedlearning')
refer_dict.to_csv('refer_dict.csv')
