# -*- coding: utf-8 -*-
"""
Created on Wed May 22 11:07:05 2019

@author: made_
"""

import numpy as np
import matplotlib.pyplot as plt
import cobra
from cobra.io import read_sbml_model
from cobra.flux_analysis import single_reaction_deletion
import pandas as pd
import string


def main():
    
    model = read_sbml_model('iJO1366.xml')
    obj_name = []
    fluxes   = []
    counter  = 0
    
    
    # analyse
    '''
    1805 Metabolites
    2583 Reactions
    1367 Genes
    '''
    
    for x in model.metabolites:
        print(x)
    
    for x in model.reactions:
        print('%s : %s' %(x.id, x.reaction))
        print('%s:' % x.genes)
        
    print('%i Metabolites' % len(model.metabolites))
    print('%i Reactions' % len(model.reactions))
    print('%i Genes' % len(model.genes))
    
    
    ### GLUCOSE MINIMAL ENVIRONMENT
    # objective function
    for r in model.reactions:
        if r.objective_coefficient == 1:
            obj_name.append(r.id)
    
    # FBA
    solution = model.optimize()
    model.summary()
    fluxes.append(solution.x_dict[obj_name[0]])

    
    # active reactions
    for i in range(len(solution.x_dict)):
        if solution.x_dict[:][i] != 0:
            counter += 1
    print(counter)
    print("Ratio of active reactions:", counter/len(solution.x_dict))
    
    # essential reactions
    essential = 0
    solution_deletion = single_reaction_deletion(model, model.reactions[:])
    #print(solution_deletion)
    
    id_list_glc = []
    for i in range(len(solution_deletion["flux"])):
        if round(solution_deletion["flux"][i],4) == 0:
            essential += 1
            id_list_glc.append(model.reactions[i].id)
    print(essential)
    print(essential/len(solution_deletion))
    
    
    ### ACETATE MINIMAL ENVIRONMENT
    # set new bounds for glucose and acetate
    acetate_id = str
    glucose_id = str
    
    # find correct acetate id
    for x in model.reactions:
        if "EX" in x.id and "_ac_" in x.id:
            #print(x.id)
            acetate_id = x.id
            
    model.reactions.get_by_id(acetate_id).lower_bound = -10.
    model.reactions.get_by_id(acetate_id).upper_bound = 1000.
    
    # find correct glucose id
    for x in model.reactions:
        if "EX" in x.id and "glc__" in x.id:
            #print(x.id)
            glucose_id = x.id
    
    model.reactions.get_by_id(glucose_id).lower_bound = 0.
    model.reactions.get_by_id(glucose_id).upper_bound = 1000.    
    #model.metabolites.ac_c.summary()
    
    # optimize model
    solution_ac = model.optimize()
    model.summary()
    fluxes.append(solution_ac.x_dict[obj_name[0]])
    print(fluxes)
    
    # active reactions
    counter_ac = 0
    
    for i in range(len(solution_ac.x_dict)):
        if round(solution_ac.x_dict[:][i],8) != 0:
            counter_ac += 1
    print(counter_ac)  # 410
    print("Ratio of active reactions:", counter_ac/len(solution_ac.x_dict))
    
    # essential reactions
    essential_ac = 0
    solution_ac_deletion = single_reaction_deletion(model, model.reactions[:])
    print(solution_ac_deletion)
    
    id_list_ac = []
    for i in range(len(solution_ac_deletion["flux"])):
        if round(solution_ac_deletion["flux"][i],4) == 0:
            essential_ac += 1
            id_list_ac.append(model.reactions[i].id)
    print(essential_ac)
    
    # essential in both environments
    essential_both = []
    for i in range(min(len(id_list_glc),len(id_list_ac))):
        if len(id_list_glc) > len(id_list_ac):
            if id_list_ac[i] in id_list_glc:
                print(id_list_ac[i])
                essential_both.append(id_list_ac[i])
        else:
            if id_list_glc[i] in id_list_ac:
                print(id_list_glc[i])
                essential_both.append(id_list_glc[i])
                
    print(essential_both)
    
    # essential only in acetate, but not in glucose environment
    essential_ac_only = []
    for i in range(len(id_list_ac)):
        if id_list_ac[i] not in id_list_glc:
            essential_ac_only.append(id_list_ac[i])
    
    
    # output summary
    print(counter)
    print("Ratio of active reactions:", counter/len(solution.x_dict))
    print(essential)
    print(essential/len(solution_deletion))
    print(counter_ac)  # 410
    print("Ratio of active reactions:", counter_ac/len(solution_ac.x_dict))
    print(essential_ac)
    print(essential_ac_only)
    print(len(essential_both))
    
    
    # RICH ENVIRONMENT
    rich = pd.read_csv('rich_environment.txt')
    print(rich)
    
    # make a dictionary with ids and boundaries
    rich_names = []
    rich_bounds= []
    file = open('rich_environment.txt')
    for line in file:
        line = line.split()
        print(line[0])
        rich_names.append(line[0])
        rich_bounds.append(line[2])
    
    # set new reaction boundaries
    idx_list = []
    for i in range(len(rich_names)):
        for x in model.reactions:
            if rich_names[i] in x.id:
                idx_list.append(x.id)
    print(idx_list)
    
    for i in range(len(rich_names)):
        model.reactions.get_by_id(idx_list[i]).lower_bound = float(rich_bounds[i])
        
    # FBA
    solution2 = model.optimize()
    model.summary()
    #fluxes.append(solution2.x_dict[obj_name[0]])

    
    # active reactions
    counter2 = 0
    for i in range(len(solution2.x_dict)):
        if solution2.x_dict[:][i] != 0:
            counter2 += 1
    print(counter2)
    print("Ratio of active reactions:", counter2/len(solution2.x_dict))
    
    # essential reactions
    #solution_deletion2 = single_reaction_deletion(model, model.reactions[:])
    #print(solution_deletion2)    
         
    # potential carbon sources
    Csources = []
    for x in model.metabolites:
        if 'C' in x.elements and 'e' in x.compartment:
            Csources.append(x.id)
    
    print("These are alternative C sources:", Csources, '\n')
    
#     alternative way with formula
    Csources2 = []
    for x in model.reactions:
        if x.id.startswith('EX'):
            Csources2.append()
    
#    print('This is the general way for identifying alternatve C sources for any model\n', Csources2)
    
    pot_carbs = []
    for x in model.reactions:
        if x.id.startswith("EX"):
            met = str(x.metabolites).split("Metabolite ")[1].split(" at")[0]
            f = model.metabolites.get_by_id(met).formula
            for i in range(len(f)-1):
                if f[i] == "C":
                    if not f[i+1].islower():
                        continue
                    pot_carbs.append(x.id)
                    #print(r.id,f)
    

    alph = list(string.ascii_uppercase)
    
    pot_carbs2 = []
    for r in model.reactions:
        if r.id.startswith("EX"):
            met = str(r.metabolites).split("Metabolite ")[1].split(" at")[0]
            f = model.metabolites.get_by_id(met).formula
            for i in range(len(f)-1):
                if f[i] == "C":
                    if f[i+1] in alph:
                        continue
                    pot_carbs2.append(r.id)
                    print(r.id,f)
                    
    print(pot_carbs == pot_carbs2)
    
    
    # calculate biomass flux of every single alternative C source
    # set all lower boundaries for uptake to 0 except for C source in question which is -1000
    model.reactions.get_by_id('EX_glc__D_e').lower_bound = 0
    
    for ii in range(len(Csources2)):
        model.reactions.get_by_id(Csources2[ii]).lower_bound = -10.
    
    
    
    
if __name__ == '__main__':
    main()