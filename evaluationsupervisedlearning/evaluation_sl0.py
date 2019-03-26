# -*- coding: utf-8 -*-
"""
Created on Sat Jan 13 23:16:09 2018

@author: Dong Li
"""

import os
import pandas as pd
import numpy as np
import scipy.io as sio


def clear_data_name(charactors):
    charactors_copy=charactors
    Letter_pool='0123456789'
    for cha in charactors_copy:
        if cha not in Letter_pool:
            charactors_copy=charactors_copy.replace(cha,' ')
    return charactors_copy

layer_GY=pd.read_csv('area_processed.csv')
    
refer_dict=pd.read_csv('refer_dict.csv',index_col='Unnamed: 0')
nametrainlist=['M226L5','M248L1','M248R3','M262L2','M262L3','M262R3','M339R5','M339R6']

featureset=['F1','F2','F3','F4','F5','F6']
target='F1Nt8'

os.chdir('..')
os.chdir('..')
os.chdir('data')
folder_list=os.listdir()


sim_list=[]
sim_self_list=[]

for ifeature in featureset:
    sim_list.append([])
    for idata in nametrainlist:
        sim_list[featureset.index(ifeature)].append([])

for ifeature in featureset:
    sim_self_list.append([])

for ifolder in folder_list:
    

    
    
    os.chdir(ifolder)
    os.chdir('supervisedlearning')
    

    x0=layer_GY['composition'][layer_GY['Name']==ifolder].values[0]
    x1=clear_data_name(x0)
    x2=x1.split()
    composition_GY=[int(x) for x in x2]
    
    
    for ifeature in featureset:
        os.chdir(ifeature[1])
        
        for idata in nametrainlist:
        
            
                

            lrs_dict0=refer_dict['reference_layer'][refer_dict['reference']==idata].values[0]
            lrg_dict0=refer_dict['layer_GY'][refer_dict['reference']==idata].values[0]
            lrs_dict=eval(lrs_dict0) # map from th eresult
            lrg_dict=eval(lrg_dict0)   # map to GY's labelling
            
            resultfolder=idata+target
            os.chdir(resultfolder)
            
            
            
            

            mat=sio.loadmat('mat.mat')
            matp=mat['mat']
            
            summary=sio.loadmat('summary.mat')
            summary_label=summary['summary']
            val = summary_label[0,0]
            summary_result=val['result']
            summary_layer=val['layer']
            summary_tthickness=val['thickness']
            summary_similar=val['similar']
            # end of loading matlab result
            composition_d=summary_result.reshape((1,-1))[0].tolist()

            n_compare=np.min([len(composition_d),len(composition_GY)])
               
            com_d=composition_d[0:n_compare]
            com_GY=composition_GY[0:n_compare]

            lc_coms=np.array([0]*len(com_d))
            lg_coms=np.array([0]*len(com_GY))
    
            for kk in lrs_dict:
                ia=lrs_dict.index(kk)+1
                for kki in kk:
                    indices = [ii for ii, x in enumerate(com_d) if x == kki]    
                    lc_coms[indices]=ia
            for kk in lrg_dict:
                ia=lrg_dict.index(kk)+1
                for kki in kk:
                    indices = [ii for ii, x in enumerate(com_GY) if x == kki]    
                    lg_coms[indices]=ia


            com_diff=lc_coms-lg_coms
            com_diff_l=list(com_diff)
            n_zero=com_diff_l.count(0)
                      
                      
                      

            
            sim=n_zero/n_compare
            
            sim_list[featureset.index(ifeature)][nametrainlist.index(idata)].append(sim)
            
            ###### self similarity
            
            if idata==ifolder:
                sim_self_list[featureset.index(ifeature)].append(sim)
            
            
            
#############################################
#############################################




            




            os.chdir('..')
        
        os.chdir('..')
    os.chdir('..')
    os.chdir('..')
os.chdir('..')
os.chdir('code')
os.chdir('evaluationsupervisedlearning')

sim_np=np.array(sim_list)


for idata in nametrainlist:
    
    
    sim_np_i=sim_np[:,nametrainlist.index(idata),:]
    
    np.save(idata+'compareglobel.npy',sim_np_i)
    
    sim_np_i_mean=np.mean(sim_np_i,1)
    sim_np_i_std=np.std(sim_np_i,1)
    sim_np_i_max=np.max(sim_np_i,1)
    sim_np_i_min=np.min(sim_np_i,1)
    
    sim_i=pd.DataFrame()

    sim_i['ID']=featureset
    sim_i['mean']=sim_np_i_mean
    sim_i['std']=sim_np_i_std
    sim_i['max']=sim_np_i_max
    sim_i['min']=sim_np_i_min
    sim_i.to_csv(idata+'result_similarity_layer.csv')
    
sim_np_self=np.array(sim_self_list)

np.save('compareglobale_self.npy',sim_np_self)

sim_np_self_mean=np.mean(sim_np_self,1)
sim_np_self_std=np.std(sim_np_self,1)
sim_np_self_max=np.max(sim_np_self,1)
sim_np_self_min=np.min(sim_np_self,1)    


sim_self=pd.DataFrame()

sim_self['ID']=featureset
sim_self['mean']=sim_np_self_mean
sim_self['std']=sim_np_self_std
sim_self['max']=sim_np_self_max
sim_self['min']=sim_np_self_min
sim_self.to_csv('result_similarity_self.csv')    
