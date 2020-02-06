# -*- coding: utf-8 -*-
"""
Created on Tue May 21 14:09:36 2019

@author: made_
"""


import numpy as np
import matplotlib.pyplot as plt
import cobra
from cobra.io import read_sbml_model


def main():
    model = read_sbml_model('e_coli_core.xml')
    for x in model.metabolites:
        print(x)
    
    for x in model.reactions:
        print('%s : %s : %s : %s' %(x.id, x.reaction, x.lower_bound, x.upper_bound))
        
    print('%i Metabolites' % len(model.metabolites))
    print('%i Reactions' % len(model.reactions))
    print('%i Genes' % len(model.genes))
    
    obj_id = str
    # objective ID: BIOMASS_Ecoli_core_w_GAM
    for r in model.reactions:
        if r.objective_coefficient == 1:
            print(r.id, r.reaction)
            obj_id = r.id
            
    solution = model.optimize()
    model.summary()
    
    print(solution.x_dict)
    
    # now, analyse for different uptake values
    uptake = np.linspace(0,50,10000)
    fluxes = np.zeros_like(uptake)
    
    # define lower and upper bounds accordingly
    for i in range(len(uptake)):
        model.reactions.get_by_id("EX_glc__D_e").lower_bound = -uptake[i]
        solution = model.optimize()
        fluxes[i] = solution.x_dict["BIOMASS_Ecoli_core_w_GAM"]
        
    # plot
    plt.plot(uptake,fluxes)
    plt.xlabel("Glucose uptake")
    plt.ylabel("flux of biomass")
    #plt.figure()
    plt.show()
    
    
    # analyse: EX_o2_e, EX_co2_e, EX_ac_e and EX_etoh_e
    o2_flux = np.zeros_like(uptake)
    co2_flux = np.zeros_like(uptake)
    ac_flux = np.zeros_like(uptake)
    etoh_flux = np.zeros_like(uptake)
    
    
    # change lower_bound since this is the uptake from external environment (nothingness):
    # metabolite_ext -> "nothingness", and if lower_bound has negative value, then there is also
    # back transport: "nothingness" -> metabolite_ext. That's why, we vary lower_bound.
    for i in range(len(uptake)):
        model.reactions.get_by_id("EX_glc__D_e").lower_bound = -uptake[i]
        solution = model.optimize()
        o2_flux[i] = solution.x_dict["EX_o2_e"]
        co2_flux[i] = solution.x_dict["EX_co2_e"]
        ac_flux[i] = solution.x_dict["EX_ac_e"]
        etoh_flux[i] = solution.x_dict["EX_etoh_e"]
        
    # plot
    plt.plot(uptake,o2_flux)
    plt.plot(uptake,co2_flux)
    plt.plot(uptake,ac_flux)
    plt.plot(uptake,etoh_flux)
    #plt.legend
    plt.xlabel("Glucose uptake")
    plt.ylabel("flux of different species")
    #plt.figure()
    plt.show()
    
    
    met_id  = []
    rxn_id  = [] # saves reaction id
    altC_id = []  # saves reaction id where biomass flux bigger than 0: biomass produced for alt C
    # check for alternative carbon sources by looking at their formula
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
            

    # set glucose boundaries to 0 and adjust acetate boundaries
    model.reactions.get_by_id("EX_glc__D_e").lower_bound = 0
    model.reactions.get_by_id("EX_glc__D_e").upper_bound = 0
    model.reactions.get_by_id("EX_ac_e").lower_bound = -10.
    
    # different biomass production, because less efficient pathway
    solution = model.optimize()
    model.summary()
    

if __name__ == '__main__':
    main()