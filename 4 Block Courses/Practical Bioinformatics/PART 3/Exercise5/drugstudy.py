# -*- coding: utf-8 -*-
"""
Created on Thu May 23 09:08:51 2019

@author: made_
"""

import numpy as np
import matplotlib.pyplot as plt
import cobra
from cobra.io import read_sbml_model
from cobra.flux_analysis import single_reaction_deletion
import pandas as pd


# PRE : a valid network model
# POST: prints a few important insights about the model and returns their lengths
def analyse_network(model):
    for x in model.metabolites:
        print(x)
    
    for x in model.reactions:
        print('%s : %s' %(x.id, x.reaction))
        print('%s:' % x.genes)
        
    print('%i Metabolites' % len(model.metabolites))
    print('%i Reactions' % len(model.reactions))
    print('%i Genes' % len(model.genes))
    return (len(model.metabolites), len(model.reactions), len(model.genes))

# PRE : a valid network model
# POST: identifies the objective id
def find_objective_id(model):
    obj_id = []
    for r in model.reactions:
        if r.objective_coefficient == 1:
            obj_id.append(r.id)
    print(obj_id)
    return obj_id

# PRE : tryword is a string which is used to check whether parts of it occur in model.reactions.id
# maybe need to check if it works for a list too like this
def find_rxn_id(tryword, model):
    try_id = str
    
    for x in model.reactions:
        if tryword in x.id:
            print(x.id, x.name)
            try_id = x.id
    return try_id



def main():
    sakai = read_sbml_model('iEco1345_Sakai.xml')
    mg = read_sbml_model('iEco1339_MG1655.xml')
    min_env = pd.read_csv('template_minimal_env.txt')
    
    sakai_obj = find_objective_id(sakai)
    mg_obj    = find_objective_id(mg)
    
    # Analyse models
    '''
    MG
    1705 Metabolites
    2428 Reactions
    1338 Genes
    
    Sakai
    1708 Metabolites
    2374 Reactions
    959 Genes
    '''
#    sakai_met, sakai_rxn, sakai_gen = analyse_network(sakai)
#    mg_met, mg_rxn, mg_gen = analyse_network(mg)
    
    # define minimal environment according to the contents of min_env
    # all extracellular metabolites
    extracellular_met = str
    for x in sakai.metabolites:
        if "m_" in x.id and "_e_Extracellular" in x.id:
            #print(x.id, x.name)
            extracellular_met = x.id
    
        
    # required metabolites for minimal enviornment
    required_met= str
    for x in sakai.metabolites:
        if "ca2_e" in x.id or "cl_e" in x.id or "cobalt2_e" in x.id or "cu2_e" in x.id or "o2_e" in x.id or "_h2o_e" in x.id or "k_e" in x.id or "mg2_e" in x.id or "mn2_e" in x.id or "mobd_e" in x.id or "nh4_e" in x.id or "_pi_e" in x.id or "so4_e" in x.id or "zn2_e" in x.id or "fe2_e" in x.id or "m_fe3_e" in x.id:
            #print(x.id, x.name)
            required_met = x.id
            
    # set the other metabolites to 0 and their exchange reactions to lower_bound = 0
    for i in range(len(extracellular_met)):
        if extracellular_met[i] not in required_met:
            sakai.reactions.get_by_id(extracellular_met[i]).lower_bound = 0  # no import
            mg.reactions.get_by_id(extracellular_met[i]).lower_bound = 0
    
    
    
    # find glucose id  (use x.name to check the name of the reaction for more insights)
    glucose_id_sak  = str
    glucose_id_mg   = str
    o2_id_sak       = str
    o2_id_mg        = str
    
    for x in sakai.reactions:
        if "EX_O2_" in x.id:
            print(x.id, x.name)
            o2_id_sak = x.id
    
    for x in mg.reactions:
        if "EX_O2_" in x.id:
            print(x.id, x.name)
            o2_id_mg = x.id
    
    for x in sakai.reactions:
        if "_GLC_" in x.id:
            print(x.id, x.name)
            gluc_id_sak = x.id
            
    for x in mg.reactions:
        if "_GLC_" in x.id:
            print(x.id, x.name)
            gluc_id_mg = x.id
    
    # aerobic analysis
    # define glucose boundaries (see exercise sheet)
    sakai.reactions.get_by_id(gluc_id_sak).lower_bound = -7.9
    mg.reactions.get_by_id(gluc_id_mg).lower_bound = -15.5
    
    sol_sakai_o2 = sakai.optimize()
    sol_mg_o2 = mg.optimize()
    
    print('Sakai: aerobic')
    sakai.summary()
    print('MG: aerobic')
    mg.summary()
    
    # anaerobic analysis
    # set O2 boundaries to 0 for anaerobic conditions
    sakai.reactions.get_by_id(gluc_id_sak).lower_bound = -19.2
    mg.reactions.get_by_id(gluc_id_mg).lower_bound = -8.1
    
    sakai.reactions.get_by_id(o2_id_sak).lower_bound = 0
    sakai.reactions.get_by_id(o2_id_sak).upper_bound = 0
    mg.reactions.get_by_id(o2_id_mg).lower_bound = 0
    mg.reactions.get_by_id(o2_id_mg).upper_bound = 0
    
    sol_sakai_an = sakai.optimize()
    sol_mg_an = mg.optimize()
    print('Sakai: anaerobic')
    sakai.summary()
    print('MG: anaerobic')
    mg.summary()
    
    
    # make dictionary of alternative carbon sources
    alt_carbs_list = []
    file = open('carbon_source_list')
    
    for line in file:
        line = line.strip()
        alt_carbs_list.append(line)
    
    # find ids of alternative carbon sources for a list
    # not finished yet
    carbs_id = str
    for x in sakai.metabolites:
        if all(xx in x.id for xx in alt_carbs_list):
            print(x.id, x.name)
            carbs_id = x.id

    
if __name__ == '__main__':
    main()