# -*- coding: utf-8 -*-
"""
Created on Thu Jan 11 15:54:17 2018

@author: Dong Li
"""

import os
import pandas as pd
import numpy as np
import scipy.io as sio

# parameter
Tol=5

def clear_data_name(charactors):
    charactors_copy=charactors
    Letter_pool='0123456789'
    for cha in charactors_copy:
        if cha not in Letter_pool:
            charactors_copy=charactors_copy.replace(cha,' ')
    return charactors_copy
    
def smoothListGaussian2(myarray, degree):
    myarray = np.pad(myarray, (degree-1,degree-1), mode='edge')
    window=degree*2-1
    weight=np.arange(-degree+1, degree)/window
    weight = np.exp(-(16*weight**2))
    weight /= sum(weight)
    smoothed = np.convolve(myarray, weight, mode='valid')
    return smoothed
    
areadata=pd.read_csv('area_processed.csv',index_col='Unnamed: 0')
os.chdir('..')
os.chdir('..')
os.chdir('data/')
area_list=os.listdir()
coef_max_list=[]
for area in area_list:
    print(area)
    # layer from Guangyu
    x0=areadata['composition'][areadata['Name']==area].values[0]
    x1=clear_data_name(x0)
    x2=x1.split()
    Layer_GY=np.array(x2)
    n_slice_GY=np.size(Layer_GY,0)
    # Layer from clustering
    os.chdir(area)
    os.chdir('clustering/')
    featurecof_list=os.listdir()
    for featurecof in featurecof_list:
        os.chdir(featurecof)
        x=sio.loadmat('label.mat')
        Layer_hierarchy=x['idxz0']
        n_slice_h=np.size(Layer_hierarchy,0)
        n_h=np.size(Layer_hierarchy,1)
        n_slice=np.min([n_slice_h,n_slice_GY])
        # comparision
        
        Layer_GY0=Layer_GY[0:n_slice]
        bc_GY=[]
        for i in range(0,n_slice-1):
            bc_GY.append(int(np.equal(float(Layer_GY0[i]),float(Layer_GY[i+1]))))
        bc_GY0=np.array(bc_GY)
        bc_GY0_s=smoothListGaussian2(bc_GY0,Tol)

        coef_list=[]
        for j in range(0,n_h):
            Layer_hierarchy0=Layer_hierarchy[0:n_slice,j]
                
            bc_h=[]
            for i in range(0,n_slice-1):
                bc_h.append(int(np.equal(float(Layer_hierarchy0[i]),float(Layer_hierarchy0[i+1]))))
            bc_h0=np.array(bc_h)
            bc_h0_s=smoothListGaussian2(bc_h0,Tol)
            
            coef=np.corrcoef(bc_GY0_s,bc_h0_s)

            coef_list.append(coef[0,1])
        coef_max=np.nanmax(coef_list)
        
        coef_max_list.append(coef_max)    
        
        
        
        
        os.chdir('..')
    os.chdir('..')
    os.chdir('..')

coef_list=np.reshape(coef_max_list,(len(area_list),6)) 

coef_mean=np.mean(coef_list,0)  
coef_std=np.std(coef_list,0)
coef_max=np.max(coef_list,0)  
coef_min=np.min(coef_list,0)   



os.chdir('..')
os.chdir('code')
os.chdir('evaluationclustering')

result=pd.DataFrame(index=range(0,6))
result['ID']=['F1','F2','F3','F4','F5','F6']
result['mean']=coef_mean
result['std']=coef_std
result['max']=coef_max
result['min']=coef_min

result.to_csv('Compared_to_GY.csv')


matrix_relation=sio.loadmat('matrix_relation.mat')
matrix_relation0=matrix_relation['matrix_relation']
matrix_relation1=np.transpose(matrix_relation0)

matrix_mean=sio.loadmat('matrix_mean.mat')
matrix_mean0=matrix_mean['matrix_mean']
matrix_mean_l=np.zeros(shape=(np.size(matrix_mean0,0)+1, np.size(matrix_mean0,0)+1))

for i in range(0,np.size(matrix_mean0,0)):
    for j in range(0,np.size(matrix_mean0,0)):
        matrix_mean_l[i,j]=matrix_mean0[i,j]
    matrix_mean_l[i,np.size(matrix_mean0,0)]=coef_mean[i]
    matrix_mean_l[np.size(matrix_mean0,0),i]=coef_mean[i]
matrix_mean_l[np.size(matrix_mean0,0),np.size(matrix_mean0,0)]=1
Com_mean=pd.DataFrame(index=range(0,np.size(matrix_mean_l,0)))
for i in range(0,np.size(matrix_mean_l,0)):
    Com_mean[str(i)]=matrix_mean_l[:,i]


Com_result=pd.DataFrame(areadata['Name'])
Com_result['Type']=areadata['Type'].copy()
for i in range(0,15):
    Com_result[str(i)]=matrix_relation1[:,i]
for i in range(0,6):
    Com_result[str(100+i)]=coef_list[:,i]

Com_results=Com_result.sort_values(['Type'])




Com_results.to_csv('Compared_global.csv')
Com_mean.to_csv('Compared_mean.csv')

