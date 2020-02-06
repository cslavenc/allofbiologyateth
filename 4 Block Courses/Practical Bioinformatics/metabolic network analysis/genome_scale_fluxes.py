# -*- coding: utf-8 -*-
"""
Created on Wed May 22 08:58:25 2019

@author: made_
"""

import numpy as np
import matplotlib.pyplot as plt
import cobra
from cobra.io import read_sbml_model


def main():
    
    model_full = read_sbml_model('iAF1260.xml')
    model_aa   = read_sbml_model('iAF1260_no_AA.xml')
    model_lip  = read_sbml_model('iAF1260_no_Lipids.xml')
    model_dna  = read_sbml_model('iAF1260_no_DNA.xml')
    model_rna  = read_sbml_model('iAF1260_no_RNA.xml')
    model_all  = [model_full, model_aa, model_lip, model_dna, model_rna]
    N = len(model_all)
    
    solution_all = []  # container for all FBA models
    obj_id       = []
    obj_name     = []
    fluxes = np.zeros_like(model_all)
    flux_diff = np.zeros_like(model_all)
    
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
        
    for j in range(N):
        print("Name: %s, Biomass: %s" % (obj_id[j], fluxes[j]))
        
    for k in range(N):
        flux_diff[k] = abs(fluxes[0] - fluxes[k])
        
    print(max(flux_diff))
    print(flux_diff)
        
    
    
if __name__ == '__main__':
    main()