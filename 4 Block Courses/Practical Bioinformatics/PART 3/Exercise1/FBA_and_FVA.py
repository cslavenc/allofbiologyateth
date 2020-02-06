# -*- coding: utf-8 -*-
"""
Created on Sat May 18 10:25:11 2019

@author: made_
"""

import cobra
import pandas as pd
from cobra import Model, Reaction, Metabolite
from cobra.io import read_sbml_model
from cobra.flux_analysis import single_reaction_deletion


def main():
    
    model = read_sbml_model('example_ToyModel')
    
    # Objective function
    model.reactions.get_by_id('R1').objective_coefficient = 1
    for x in model.reactions:
        print(x.id, x.reaction)
    
    
    #model.reactions.get_by_id("R16").lower_bound = -100.
    #model.reactions.get_by_id('R2').lower_bound = 10.
    solution = model.optimize()
    model.summary()  # it does not seem that X_e is influenced by changes in A_e... 
    
    ess_id = []
    ess_rxn= []
    solution_deletion = single_reaction_deletion(model, model.reactions[:])
    print('This is the deletion outcome:\n', solution_deletion)
    print('Accessing the structure:', solution_deletion["flux"][1])
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
        
    #print(solution.x_dict)
    
    # fixed reaction is where FVA results show minimum = flux = maximum 
    # this means that the flux is fixed and cannot vary in any way (minimum <= flux <= maximum)
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
    
    for key, vals in fixed_dict.items():
        print(key, vals)
    
    
if __name__ == '__main__':
    main()
