# -*- coding: utf-8 -*-
"""
Created on Sat Jan 16 13:16:09 2018

@author: Dong Li
"""

import os
import pandas as pd
import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt

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
    
correct_order0=pd.read_csv('Compared_global.csv')
order0=correct_order0['Unnamed: 0']
Name0=correct_order0['Name']


featureset=['F1','F2','F3','F4','F5','F6']
Tol=5







# thick result
lmsr_np_mean_list=[]
lmsr_np_std_list=[]
n_featureset0=len(featureset)
n_folder=len(Name0)
lmss=[]
for i in range(0,n_featureset0):
    lmss.append([])



lmsrD=pd.DataFrame(index=range(0,n_featureset0))


for i in range(0,n_featureset0):
    os.chdir('..')
    os.chdir('..')
    os.chdir('data/')
    featurename=str(i+1)
#        sim_list_folder=[]
#        sim_list_folder_a=[]
    sim=np.array([[0.0]*n_folder]*n_folder)
    for areak in Name0:
        os.chdir(areak)
        os.chdir('clustering')
        os.chdir(featurename)
        label=sio.loadmat('label.mat')
        idxz0=label['idxz0']
        dis=np.sum(idxz0,1)
        boundary=[]
        for ib in range(0,len(dis)-1):
            qa=dis[ib+1]
            qb=dis[ib]
            boundary.append(float(qa)-float(qb))
        d_boundary=[]
        for ib in range(0,len(boundary)-1):
            qa=boundary[ib+1]
            qb=boundary[ib]
            d_boundary.append(float(qa)-float(qb))


        os.chdir('..')
        os.chdir('..')
        os.chdir('..')
        
        
        #vectorA
        vxlsa=smoothListGaussian2(d_boundary,Tol)


        n_vxlsa=len(vxlsa) 
        
        for areakk in Name0:
            if areak==areakk:
                sim[list(Name0).index(areak),list(Name0).index(areak)]=1
            else:     
            
                os.chdir(areakk)
                os.chdir('clustering')
                os.chdir(featurename)
                label=sio.loadmat('label.mat')
                idxz0=label['idxz0']
                dis=np.sum(idxz0,1)
                boundary=[]
                for ib in range(0,len(dis)-1):
                    qa=dis[ib+1]
                    qb=dis[ib]
                    boundary.append(float(qa)-float(qb))

    
    
                os.chdir('..')
                os.chdir('..')
                os.chdir('..')


                #vectorB

                vxlsb=smoothListGaussian2(boundary,Tol)
        
                n_vxlsb=len(vxlsb) 

                if n_vxlsa==n_vxlsb:
                    sim_max=np.corrcoef(vxlsa,vxlsb)[0,1]

                else:
                    n_com=min(n_vxlsa,n_vxlsb)
                    sim_options=[]
                    for ixx in range(0,n_vxlsa-n_com+1):
                        vlxlsa=vxlsa[ixx:n_com+ixx]

                        for iyy in range(0,n_vxlsb-n_com+1):
                            vlxlsb=vxlsb[iyy:n_com+iyy]

                            sim_0=np.corrcoef(vlxlsa,vlxlsb)[0,1]
                            sim_options.append(sim_0)
                    sim_max=np.nanmax(sim_options)
                    

                sim[list(Name0).index(areak),list(Name0).index(areakk)]=sim_max      

    plt.figure()
    plt.imshow(sim)  
    plt.colorbar()
    
    resultD=pd.DataFrame(index=range(0,len(Name0)))
    resultD['Name']=Name0
    for jj in range(0,len(Name0)):
        resultD[Name0[jj]]=sim[:,jj]
    
    os.chdir('..')
    os.chdir('code')
    os.chdir('evaluationclustering')
    resultD.to_csv('herarchical_similarity_'+featureset[i]+'.csv')    