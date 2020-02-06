# -*- coding: utf-8 -*-
"""
Created on Tue May 21 13:40:36 2019

@author: made_
"""

import numpy as np
import cobra
from cobra.io import read_sbml_model
from cobra.flux_analysis import single_reaction_deletion


def main():
    model = read_sbml_model('glycolysis.xml')
    
    for x in model.metabolites:
        print(x)
    print('%i Metabolites' % len(model.metabolites))
    
    for x in model.reactions:
        print('%s : %s : %s : %s' %(x.id, x.reaction, x.lower_bound, x.upper_bound))
    print('%i Reactions' % len(model.reactions))
    
    # perform FBA to maximize ATP production
    for r in model.reactions:
        if r.objective_coefficient == 1:
            print(r.id, r.reaction)
    
    model.reactions.get_by_id("R20").objective_coefficient = 1
    
    solution = model.optimize()
    model.summary()
    
    # active reactions are those with non-zero flux
    print('This is solution.x_dict\n', solution.x_dict)
    fluxes = []
    id_list = []
    rxn2 = []
    dic = solution.x_dict.to_dict()
    list_keys = list(dic.keys())
    dic_keys = [*dic.keys()]
    print(list(dic.keys()))
    print(dic_keys)
    
    for i in range(len(solution.x_dict)):
        if solution.x_dict[i] != 0:
            fluxes.append(solution.x_dict[i])
            id_list.append(i)
            rxn2.append(list_keys[i-1])
            
    print('Those are the fluxes:', fluxes)
    print('This is the id_list', id_list)
    print(rxn2)
    
    
            
            
    
    
    # check if R2 is essential: no, because status is optimal when deleted
    solution_deletion = single_reaction_deletion(model, model.reactions[:])
    #print(solution_deletion)
    
    # R14 produces NADH and also 13dpg which is needed in R15 for the ATP production
    # but LDH is only needed in R19, R14 needs GAPD
#    model.metabolites.nadh.summary()
#    model.metabolites.atp.summary()
#    
#    # FVA
#    fractions = np.linspace(0,1,10)  # check flexibility for 10 different fractions
#    for i in range(len(fractions)):
#        fva_result = cobra.flux_analysis.flux_variability_analysis(model, model.reactions[:],
#                                                                   fraction_of_optimum=fractions[i])
#        #print(fva_result)  
    
if __name__ == '__main__':
    main()