#Exercise 1.3. Builing the first toy model
##############################################

#an example of how to build a model with COBRApy can be found in:
#http://cobrapy.readthedocs.io/en/latest/building_model.html


#Import needed package
import cobra
from cobra import Model, Reaction, Metabolite

#############
#Define model
#############
cobra_model = Model('ToyModel')

##################
#Define reactions (15 internal, 5 external)
##################
reaction1 = Reaction('R1')
reaction1.name = 'reaction 1'
reaction1.subsystem = 'internal'
reaction1.lower_bound = 0. 
reaction1.upper_bound = 1000.  

reaction2 = Reaction('R2')
reaction2.name = 'reaction 2'
reaction2.subsystem = 'internal'
reaction2.lower_bound = 0.  
reaction2.upper_bound = 1000.  

reaction3 = Reaction('R3')
reaction3.name = 'reaction 3'
reaction3.subsystem = 'internal'
reaction3.lower_bound = 0.  
reaction3.upper_bound = 1000.  

reaction4 = Reaction('R4')
reaction4.name = 'reaction 4'
reaction4.subsystem = 'internal'
reaction4.lower_bound = -1000. 
reaction4.upper_bound = 1000.  

reaction5 = Reaction('R5')
reaction5.name = 'reaction 5'
reaction5.subsystem = 'internal'
reaction5.lower_bound = -1000.  
reaction5.upper_bound = 1000.  

reaction6 = Reaction('R6')
reaction6.name = 'reaction 6'
reaction6.subsystem = 'internal'
reaction6.lower_bound = -1000.  
reaction6.upper_bound = 1000.  

reaction7 = Reaction('R7')
reaction7.name = 'reaction 7'
reaction7.subsystem = 'internal'
reaction7.lower_bound = 0.  
reaction7.upper_bound = 1000.  

reaction8 = Reaction('R8')
reaction8.name = 'reaction 8'
reaction8.subsystem = 'internal'
reaction8.lower_bound = 0.  
reaction8.upper_bound = 1000.  

reaction9 = Reaction('R9')
reaction9.name = 'reaction 9'
reaction9.subsystem = 'internal'
reaction9.lower_bound = 0. 
reaction9.upper_bound = 1000.  

# add reactions 10 to 15:
reaction10 = Reaction('R10')
reaction10.name = 'reaction 10'
reaction10.subsystem = 'internal'
reaction10.lower_bound = 0. 
reaction10.upper_bound = 1000. 

reaction11 = Reaction('R11')
reaction11.name = 'reaction 11'
reaction11.subsystem = 'internal'
reaction11.lower_bound = 0. 
reaction11.upper_bound = 1000. 

reaction12 = Reaction('R12')
reaction12.name = 'reaction 12'
reaction12.subsystem = 'internal'
reaction12.lower_bound = -1000. 
reaction12.upper_bound = 1000. 

reaction13 = Reaction('R13')
reaction13.name = 'reaction 13'
reaction13.subsystem = 'internal'
reaction13.lower_bound = 0. 
reaction13.upper_bound = 1000. 

reaction14 = Reaction('R14')
reaction14.name = 'reaction 14'
reaction14.subsystem = 'internal'
reaction14.lower_bound = 0. 
reaction14.upper_bound = 1000. 

reaction15 = Reaction('R15')
reaction15.name = 'reaction 15'
reaction15.subsystem = 'internal'
reaction15.lower_bound = -1000. 
reaction15.upper_bound = 1000. 


reaction16 = Reaction('R16')
reaction16.name = 'reaction 16'
reaction16.subsystem = 'external'
reaction16.lower_bound = -10.  
reaction16.upper_bound = 1000.  

reaction17 = Reaction('R17')
reaction17.name = 'reaction 17'
reaction17.subsystem = 'external' 
reaction17.lower_bound = 0.  
reaction17.upper_bound = 1000.  

# add external reactions 18, 19 and 20:
reaction18 = Reaction('R18')
reaction18.name = 'reaction 18'
reaction18.subsystem = 'external' 
reaction18.lower_bound = 0.  
reaction18.upper_bound = 1000. 

reaction19 = Reaction('R19')
reaction19.name = 'reaction 19'
reaction19.subsystem = 'external' 
reaction19.lower_bound = 0.  
reaction19.upper_bound = 1000. 

reaction20 = Reaction('R20')
reaction20.name = 'reaction 20'
reaction20.subsystem = 'external' 
reaction20.lower_bound = 0.  
reaction20.upper_bound = 1000. 



###################
#Define metabolites
###################
A_e = Metabolite(
    'A_e',
    formula='',
    name='A',
    compartment='e')

B_e = Metabolite(
    'B_e',
    formula='',
    name='B',
    compartment='e')

C_e = Metabolite(
    'C_e',
    formula='',
    name='C',
    compartment='e')

M_e = Metabolite(
    'M_e',
    formula='',
    name='M',
    compartment='e')

X_e = Metabolite(
    'X_e',
    formula='',
    name='X',
    compartment='e')

E_c = Metabolite(
    'E_c',
    formula='',
    name='E',
    compartment='c')

F_c = Metabolite(
    'F_c',
    formula='',
    name='F',
    compartment='c')

G_c = Metabolite(
    'G_c',
    formula='',
    name='G',
    compartment='c')

H_c = Metabolite(
    'H_c',
    formula='',
    name='H',
    compartment='c')

I_c = Metabolite(
    'I_c',
    formula='',
    name='I',
    compartment='c')

J_c = Metabolite(
    'J_c',
    formula='',
    name='J',
    compartment='c')

# introduce metabolites L_c, M_c, N_c, O_c and X_c:
L_c = Metabolite(
    'L_c',
    formula='',
    name='L',
    compartment='c')

M_c = Metabolite(
    'M_c',
    formula='',
    name='M',
    compartment='c')

N_c = Metabolite(
    'N_c',
    formula='',
    name='N',
    compartment='c')

O_c = Metabolite(
    'O_c',
    formula='',
    name='O',
    compartment='c')

X_c = Metabolite(
    'X_c',
    formula='',
    name='X',
    compartment='c')




###############################
#Adding metabolites to reaction with their respective stoichiometry
###############################

reaction1.add_metabolites({X_c: -1.0,
                          X_e: 1.0})

reaction2.add_metabolites({E_c: 1.0,
                          A_e: -1.0})

reaction3.add_metabolites({E_c: -1.0,
                          F_c: 1.0})

reaction4.add_metabolites({E_c: -1.0,
                          G_c: 1.0})

reaction5.add_metabolites({F_c: -1.0,
                          G_c: 1.0})

reaction6.add_metabolites({F_c: -1.0,
                          I_c: 2.0})

reaction7.add_metabolites({H_c: 1.0,
                          B_e: -1.0})

reaction8.add_metabolites({I_c: -1.0,
                          J_c: 1.0})

reaction9.add_metabolites({J_c: -1.0,
                          O_c: 1.0})

# add metabolites to reactions 10 to 15:

reaction10.add_metabolites({C_e: -1.,
                            L_c: 1.})

reaction11.add_metabolites({L_c: -1.,
                            M_c: 1.,
                            N_c: 1.})

reaction12.add_metabolites({G_c: -1.,
                            N_c: 1.5})

reaction13.add_metabolites({M_c: -1.,
                            M_e: 1.})

reaction14.add_metabolites({O_c: -1.,
                            G_c: -1.,
                            X_c: 1.})

reaction15.add_metabolites({H_c: -1.,
                            I_c: 1.})


reaction16.add_metabolites({A_e: -1.0})

reaction17.add_metabolites({M_e: -1.0})

# add metabolites to external reactions 18, 19 and 20:
reaction18.add_metabolites({X_e: -1.})

reaction19.add_metabolites({B_e: -1.})

reaction20.add_metabolites({C_e: -1.})




#########################
#The model is still empty

print('Model information initially')
print("---------")
print('%i reactions initially' % len(cobra_model.reactions))
print('%i metabolites initially' % len(cobra_model.metabolites))
print('%i genes initially' % len(cobra_model.genes)) #we are not introducing genes for this example, but it could be done
print("")


################################
#Add the reactions to the model, which will also add all associated metabolites 
################################
for i in range(1,21): 
	cobra_model.add_reaction(eval('reaction'+str(i)))


###################################
#Now there are things in the model. Check that you get the right amount of reactions and metabolites
print('Model information')
print("---------")
print('%i reaction' % len(cobra_model.reactions))
print('%i metabolites' % len(cobra_model.metabolites))
print('%i genes' % len(cobra_model.genes))
print("")

#Lets take a further look into the model we have just created. Use the information printed to check you have introduced the model the right way
print("Reactions")
print("---------")
for x in cobra_model.reactions:
    print("%s : %s : %s : %s" % (x.id, x.reaction, x.lower_bound, x.upper_bound))

print("")
print("Metabolites")
print("-----------")
for x in cobra_model.metabolites:
    print('%9s : %s' % (x.id, x.compartment))


###########################
#Save model into SBML format:
############################
cobra.io.write_sbml_model(cobra_model, 'example_ToyModel')


