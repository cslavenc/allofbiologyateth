# -*- coding: utf-8 -*-
"""
Created on Thu May 30 14:37:21 2019

@author: made_
"""

# useful functions for metabolic network analysis

import numpy as np
import matplotlib.pyplot as plt
import cobra
from cobra.io import read_sbml_model
from cobra.flux_analysis import single_reaction_deletion, flux_variability_analysis
import pandas as pd


# essential reactions are those when after deleting the flux, it becomes 0
# this means that there is no other way for the cell to overcome this deletion
# and there will be no flux in overall
# NOTE: the function single_reaction_deletion returns an unordered list, which is different
# from solution.x_dict in general
def get_essential_rxns(model):
    solution = model.optimize()
    #model.summary()
    
    ess_id = []
    ess_rxn= []
    solution_deletion = single_reaction_deletion(model, model.reactions[:])
    print('This is the deletion outcome:')
    print(solution_deletion)
    #print('Accessing the structure:', solution_deletion["flux"][1])
    for i in range(len(solution_deletion)):
        if round(solution_deletion["flux"][i],4) == 0:
            ess_id.append(i)
            
    # get access to the reaction names
    dic = solution_deletion.to_dict()
    rxn_list = [*dic['flux'].keys()]
    #print(rxn_list)  # access these reactions in unordered way with an ind_list
    
    for i in range(len(ess_id)):
        #print(rxn_list[ess_id[i]])
        ess_rxn.append(rxn_list[ess_id[i]])
    
    return ess_rxn



def get_active_rxns(model):
    # after optimization, count the fluxes != 0 in solution:
    
    # get fluxes
    solution = model.optimize()
    
    # active reactions are those with non-zero flux
    print('This is solution.x_dict\n', solution.x_dict)
    print('Warning: check for i=0 case manually!')
    fluxes = []
    id_list = []
    rxn = []
    dic = solution.x_dict.to_dict()
    list_keys = list(dic.keys())
    print(list(dic.keys()))
    
    # recovers reaction names with dictionaries by transforming solution.x_dict into dict and list
    # be careful if i = 0 form list_keys
    for i in range(len(solution.x_dict)):
        if solution.x_dict[i] != 0:
            fluxes.append(solution.x_dict[i])
            id_list.append(i)
            rxn.append(list_keys[i-1])
    
    return solution, fluxes, id_list, rxn

def get_fixed_rxns(model):
    # fixed reaction is where FVA results show minimum = flux = maximum.
    # this means that the flux is fixed and cannot vary in any way (minimum <= flux <= maximum).
    
    solution = model.optimize()
    
    fva_result = cobra.flux_analysis.flux_variability_analysis(model,model.reactions[:])
    print('FVA results:')
    print(fva_result)
    # find fixed reactions
    fixed_rxns = []
    fixed_vals = []
    
    dic_fva = fva_result.to_dict()
    fva_max_list = [*dic_fva['maximum'].values()]
    fva_min_list = [*dic_fva['minimum'].values()]
    fva_rxn_list = [*dic_fva['maximum'].keys()]
    
    for i in range(len(fva_max_list)):
        if round(fva_max_list[i],4) == round(fva_min_list[i],4):
            fixed_rxns.append(fva_rxn_list[i])
            fixed_vals.append(fva_max_list[i])
    
    fixed_dict = {keys:[] for keys in fixed_rxns}
    iter_var = 0
    
    for key in fixed_dict:
        fixed_dict[key].append(fixed_vals[iter_var])
        iter_var += 1
    
    
    print(fixed_dict)
    print(fixed_rxns)
    return fixed_dict, fixed_rxns, fixed_vals



# returns biomass id of the objective function of the model
def get_biomass_id(model):
    obj_id = []
    obj_name = []
    
    # get biomass id
    for r in model.reactions:
        if r.objective_coefficient == 1:
            obj_id.append(r.id)
            obj_name.append(r.name)
            
    print('Id is:', obj_id)
    print('Name is:', obj_name)
    return obj_id, obj_name


# check if model.reaction.id for glucose really is "EX_glc__D_e" !!
def other_viable_sources(model):
    # objective id
    obj_id = str
    for r in model.reactions:
        if r.objective_coefficient == 1:
            print(r.id, r.reaction)
            obj_id = r.id
    
    # memory space for alternative carbon sources
    met_id  = []
    rxn_id  = [] # saves reaction id
    altC_id = []  # saves reaction id where biomass flux bigger than 0: biomass produced for alt C
    
    # check for alternative carbon sources by looking at their formula
    # this only works for E.coli and C has to be the first element!
    # I need to differentiate the case if there are elements like Ca etc. for general model systems
    for n in model.metabolites:
        if 'C' in n.elements and 'e' in n.compartment:
            print(n.formula, n.name, n.id, n.compartment)
            met_id.append(n.id)
    
    print(met_id)
    for idname in met_id:
        for x in model.reactions:
            if idname in x.id:
                rxn_id.append(x.id)
    
    print(rxn_id)
    model.reactions.get_by_id("EX_glc__D_e").lower_bound = 0
    for i in range(len(rxn_id)):
        model.reactions.get_by_id(rxn_id[i]).lower_bound = -1000.  # or -10. simply
        solution = model.optimize()
        #model.summary()
        # extract biomass flux information
        if solution.x_dict[obj_id] > 0:
            altC_id.append(rxn_id[i])
            #altC_id.append(solution.x_dict[obj_id])
            
    print('These are the names for alternative C:', altC_id)
    print(len(altC_id), '<?', len(rxn_id))

    return altC_id, rxn_id, met_id
