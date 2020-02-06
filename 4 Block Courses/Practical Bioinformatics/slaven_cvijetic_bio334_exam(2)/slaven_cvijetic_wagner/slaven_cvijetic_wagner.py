# -*- coding: utf-8 -*-
"""
Created on Thu May 30 21:03:14 2019

@author: made_
"""

# slaven_cvijetic_wagner
import numpy as np
import matplotlib.pyplot as plt
import cobra
from cobra.io import read_sbml_model
from cobra.flux_analysis import single_reaction_deletion, flux_variability_analysis
import pandas as pd


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
    
    return ess_rxn, ess_id




def main():
    model = read_sbml_model('iYO844.xml')
    
    # a) analyse
    '''
    990  Metabolites
    1250 Reactions
    229  External reactions
    844  Genes
    '''
    ex_rxn_no = []
    for x in model.metabolites:
        print(x)
    
    for x in model.reactions:
        print('%s : %s' %(x.id, x.reaction))
        print('%s:' % x.genes)
        
        
    print('%i Metabolites' % len(model.metabolites))
    print('%i Reactions' % len(model.reactions))
    print('%i Genes' % len(model.genes))
    
    for x in model.reactions:
        if 'EX_' in x.id:
            #print(x.id)
            ex_rxn_no.append(x.id)
    print(len(ex_rxn_no))
    
    # b) metabolite consumption in a glucose minimal environment
    # id: BIOMASS_BS_10
    obj_id, obj_name = get_biomass_id(model)
    
    solution = model.optimize()
    model.summary()  # here we can read the IN FLUXES which are the metabolites it consumes
    #print(solution.x_dict)
    biomass_on_glc = solution.x_dict[obj_id]
    
    '''
    The model consumes the following metabolites with their influxes:
    o2_e      5.71    
    glc__D_e  1.7       
    nh4_e     0.945     
    pi_e      0.181
    k_e       0.0833
    so4_e     0.0201
    mg2_e     0.012
    fe3_e     0.000407
    ca2_e     0.000378 
    '''
    
    # c) essential reactions
    essentials_on_glc, ess_rxn = get_essential_rxns(model)
    print(essentials_on_glc)
    #print(ess_rxn)
    
    # d) alanine as an alternative carbon source
    # get external glucose lower bound
    glc_id = str
    ala_id = str
    for x in model.reactions:
        if 'glc__D' in x.id and 'EX_' in x.id:
            print(x.id)
            glc_id = x.id
            
    for x in model.reactions:
        if 'ala__L' in x.id and 'EX_a' in x.id:
            print(x.id)
            ala_id = x.id
    
    # change lower bounds in glucose and alanine
    # glucose has to become 0 such that there is no uptake
    glc_lower = model.reactions.get_by_id(glc_id).lower_bound
    model.reactions.get_by_id(glc_id).lower_bound = 0
    model.reactions.get_by_id(ala_id).lower_bound = glc_lower
    
    # optimize model again now with alanine as its external carbon source
    solution = model.optimize()
    model.summary()
    # compare biomass fluxes
    biomass_on_ala = solution.x_dict[obj_id]
    print('Biomass on alanine:', biomass_on_ala)
    print('Biomass on glucose:', biomass_on_glc)
    print('Biomass production on alanine is lower than on glucose')
    
    # e) essential reactions on alanine
    essentials_on_ala, ess_rxn2 = get_essential_rxns(model)
    print(essentials_on_ala)
    set_ala = set(essentials_on_ala)
    set_glc = set(essentials_on_glc)
    print(set_glc ^ set_ala)
    
    # alternative way
    only_glc_list = []
#    for elem in set_glc:
#        if not elem in set_ala:
#            only_glc_list.append(elem)
#    print(only_glc_list)
    for i in range(len(essentials_on_glc)):
        if 'EX_' in essentials_on_glc[i] and not essentials_on_glc[i] in essentials_on_ala:
            only_glc_list.append(essentials_on_glc[i])
    print(only_glc_list)
    # Essential external reactions on glucose: ['EX_glc__D_e', 'EX_nh4_e']
    
    # explore their chemical formulas
    for x in model.metabolites:
        if 'glc__D_e' in x.id:
            print(x.id, x.formula, x.elements)
            
    for x in model.metabolites:
        if 'ala__L_e' in x.id and not 'met_' in x.id:
            print(x.id, x.formula, x.elements)
    '''
    Summary:
    ['EX_glc__D_e', 'EX_nh4_e']
    glc__D_e C6H12O6 {'C': 6, 'H': 12, 'O': 6}
    ala__L_e C3H7NO2 {'C': 3, 'H': 7, 'N': 1, 'O': 2}
    
    The external uptake reactions for glucose makes sense of course, since only glucose can be
    imported and not alanine. Obviously, it is essential when growing only on glucose (and alanine
    cannot be imported via the reaction EX_glc__D_e).
    For the second reaction, we have to remind ourselves of the definition of a minimal environment:
        a minimal environment for a cell consists of a C,O,N,S,P source.
    We observe that alanine is already a N-source, while glucose is not.
    Therefore, we need to an external uptake reaction for N, in this case it is:
        EX_nh4_e
    Thus, NH4 serves as a N-source and is essential on a glucose minimal environment.
    '''
    
    
if __name__ == '__main__':
    main()