# -*- coding: utf-8 -*-
"""
Created on Thu May 23 11:24:04 2019

@author: made_
"""

'''
NOTES
to have import from extracellular side, set model.metabolites.get_by_id(...).lower_bound = -n
if n is pos. this means that we have influx from the outside to the intracellular side

for metabolites in the extracellular space, there also needs to be a reaction
which goes into the void: MET -->    .  # spaces mean the void

TOPICS
load model
model = read_sbml_model('name.xml')

minimal envurionment (exchange reactions)
a cell needs at least a C, N, O, P, S source from somewhere to grow and to be viable

optimize
solution = model.optimize()

active reactions
after opzimization, count the fluxes != 0 in solution:
    # get biomass id
    for i in range(N):
        for r in model.reactions:
            if r.objective_coefficient == 1:
                obj_id.append(r.id)
                obj_name.append(r.name)
    
    # get fluxes
    solution = model.optimize()
    
    # active reactions are those with non-zero flux
    print('This is solution.x_dict\n', solution.x_dict)
    fluxes = []
    id_list = []
    rxn2 = []
    dic = solution.x_dict.to_dict()
    list_keys = list(dic.keys())
    print(list(dic.keys()))
    
    # recovers reaction names with dictionaries by transforming solution.x_dict into dict and list
    for i in range(len(solution.x_dict)):
        if solution.x_dict[i] != 0:
            fluxes.append(solution.x_dict[i])
            id_list.append(i)
            rxn2.append(list_keys[i-1])


essential reactions
solution_deletion = single_reaction_deletion(model, model.reactions[:])
then count where fluxes == 0 (resp. round(fluxes, 4 or another threshold) == 0)
when these reactions have flux = 0 then there was no compensatory pathway

potential/alternative carbon sources
check C in the chemical elements not formula, since Ca also occurs or CO2
simply search in model.metabolites.elements:
    for x in model.metabolites:
        if "C" in x.elements:
            print(x.id)
            idname = x.id
this only works for e.coli, else we need to check via the formula and make this correct somehow
C is normally the first, thus if its lowercase (e.g. Ca), then it is some other element and not C
if upper, then good:
    for x in model.metabolites:
        if "C" in x.formula:
            if (next element is not uppercase):
                print(x.id)
                idname = x.id

carbon sources
turn off all carbon sources except the one wanted, by changing their exchange/import reactions
then do model.optimize again and see if the biomass flux is positive
if yes, it can use it as an alternative carbon source (e.g. like acetate etc.):
    # something like
    model.reactions.get_by_id(glc_id_of_EX).lower_bound = 0
    model.reactions.get_by_id(new_C_source_EX).lower_bound = -1000  # negative because uptake from env
    

objective coefficient
find objective coefficient and id like this:
    for i in range(N):
        for r in model_all[i].reactions:
            if r.objective_coefficient == 1:
                obj_id.append(r.id)
                obj_name.append(r.name)
                
    print(obj_id)
set objective coefficient:
    model.reactions.get_by_id(idname as string).objective_coefficient = 1
    
subsystems:
    subsystems = {key:[] for key in model_list}

    for ii in range(N):
        print(model_list[ii])
        for i in range(len(idx)):
            subsystems[model_list[ii]].append(model_all[ii].reactions[idx[i]].subsystem)
            
    Counter(subsystems['aa'])
'''