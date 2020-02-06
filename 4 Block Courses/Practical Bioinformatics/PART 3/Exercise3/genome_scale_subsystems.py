# -*- coding: utf-8 -*-
"""
Created on Wed May 22 09:36:42 2019

@author: made_
"""

import numpy as np
import matplotlib.pyplot as plt
import cobra
from cobra.io import read_sbml_model
from cobra.flux_analysis import single_reaction_deletion
from collections import Counter



    
model_full = read_sbml_model('iAF1260.xml')
model_aa   = read_sbml_model('iAF1260_AA.xml')
model_lip  = read_sbml_model('iAF1260_Lipids.xml')
model_dna  = read_sbml_model('iAF1260_DNA.xml')
model_rna  = read_sbml_model('iAF1260_RNA.xml')
model_all  = [model_full, model_aa, model_lip, model_dna, model_rna]
model_list = ['full', 'aa', 'lip', 'dna', 'rna']
N = len(model_all)

solution_all = []  # container for all FBA models
obj_id       = []
obj_name     = []
fluxes = np.zeros_like(model_all)
solution_deletion = np.zeros_like(model_all)
idx = []

for i in range(N):
    for r in model_all[i].reactions:
        if r.objective_coefficient == 1:
            obj_id.append(r.id)
            obj_name.append(r.name)
            
print(obj_id)
            

for i in range(N):
    solution = model_all[i].optimize()
    solution_all.append(solution)
    model_all[i].summary()
    fluxes[i] = solution.x_dict[obj_id[i]]
    solution_deletion[i] = single_reaction_deletion(model_all[i], model_all[i].reactions[:])
    
for j in range(N):
    print("Name: %s, Biomass: %s" % (obj_name[j], fluxes[j]))
    #print("Subsystem: %s" % model_all[j].reactions.subsystem)

for kk in range(N):
    for k in range(len(solution_deletion[0])):
        if round(solution_deletion[kk]["flux"][k],3) == 0:
            print(solution_deletion[kk]["flux"][k])
            idx.append(k)

subsystems = {key:[] for key in model_list}

for ii in range(N):
    print(model_list[ii])
    for i in range(len(idx)):
        subsystems[model_list[ii]].append(model_all[ii].reactions[idx[i]].subsystem)
    
Counter(subsystems['aa'])