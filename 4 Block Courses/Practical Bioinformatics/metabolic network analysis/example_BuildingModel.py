#Building example
##############################################

#Import needed package
import cobra
from cobra import Model, Reaction, Metabolite

#Define model
cobra_model = Model('example_BuildingModel')

#Define reactions 
reaction1 = Reaction('R1')
reaction1.lower_bound = 0. 
reaction1.upper_bound = 1000.  

reaction2 = Reaction('R2')
reaction2.lower_bound = 0.  
reaction2.upper_bound = 1000.  

reaction3 = Reaction('R3')
reaction3.lower_bound = -1000.  
reaction3.upper_bound = 1000. 

reaction4 = Reaction('R4')
reaction4.lower_bound = -1000.  
reaction4.upper_bound = 1000. 

reaction5 = Reaction('R5')
reaction5.lower_bound = -1000.  
reaction5.upper_bound = 1000. 

reaction6 = Reaction('R6')
reaction6.lower_bound = -1000.  
reaction6.upper_bound = 1000.

reaction7 = Reaction('R7')
reaction7.lower_bound = -1000.  
reaction7.upper_bound = 1000. 

reaction8 = Reaction('R8')
reaction8.lower_bound = -1000.  
reaction8.upper_bound = 1000. 

reaction9 = Reaction('R9')
reaction9.lower_bound = -1000.  
reaction9.upper_bound = 1000. 


#Define metabolites
A = Metabolite('A')
B = Metabolite('B')
C = Metabolite('C')
D = Metabolite('D')
E = Metabolite('E')
A_e = Metabolite('A_e')
B_e = Metabolite('B_e')
E_e = Metabolite('E_e')


#Adding metabolites to reaction with their respective stoichiometry
reaction1.add_metabolites({A: -1.0,
                           B:-2,
                           C: 1.0})

reaction2.add_metabolites({B: -1.0,
                           C: -1.0,
                           D: 1.0})

reaction3.add_metabolites({A: -1.0,
                           D: -1.0,
                           E: 2.0})
reaction4.add_metabolites({A: -1.,
                           A_e: 1.})
reaction5.add_metabolites({B: -1.,
                           B_e: 1.})
reaction6.add_metabolites({E: -1.,
                           E_e: 1.})
reaction7.add_metabolites({A_e: -1.})
reaction8.add_metabolites({B_e: -1.})
reaction9.add_metabolites({E_e: -1.})


#Add the reactions to the model, which will also add all associated metabolites 
cobra_model.add_reaction(reaction1)
cobra_model.add_reaction(reaction2)
cobra_model.add_reaction(reaction3)
cobra_model.add_reaction(reaction4)
cobra_model.add_reaction(reaction5)
cobra_model.add_reaction(reaction6)
cobra_model.add_reaction(reaction7)
cobra_model.add_reaction(reaction8)
cobra_model.add_reaction(reaction9)

# aliter:
#for i in range(1,9):
#    cobra_model.add_reaction(eval('reaction'+str(i)))

# Objective function
cobra_model.reactions.get_by_id('R9').objective_coefficient = 1

#Now your model has been populated with reactions and metabolites. Check that you got the right reactions and metabolites
print('Model information')
print("---------")
print('%i reaction' % len(cobra_model.reactions))
print('%i metabolites' % len(cobra_model.metabolites))
print("")

#Let's take a further look at the model we have just created. Use the information printed to check you have introduced the model the right way
print("Reactions")
print("---------")
for x in cobra_model.reactions:
    print("%s : %s : %s : %s" % (x.id, x.reaction, x.lower_bound, x.upper_bound))

#Save model in SBML format
cobra.io.write_sbml_model(cobra_model, 'example_BuildingModel')

