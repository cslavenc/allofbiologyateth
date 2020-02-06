# Exercise 4.1

import cobra
from cobra.io import read_sbml_model
model = read_sbml_model("iJO1366.xml")

print("Reactions:", len(model.reactions))
print("Metabolites:", len(model.metabolites))
print("Genes:", len(model.genes))

for r in model.reactions:
    if r.objective_coefficient==1:
        biomass = r.id
        print(biomass)
        model.reactions.get_by_id(biomass).objective_coefficient = 1
sol = model.optimize()
model.summary()

# How many reactions active?
active = []
for i in range(len(sol.x_dict)):
    if sol.x_dict[i] > 0.0001 or sol.x_dict[i] < -0.0001:
        active.append(sol.x_dict.keys()[i])
print(len(active))

actex = []
for i in active:
    if i.startswith("EX"):
        actex.append(i)
print(actex)
print(len(actex))

for i in actex:
    print(model.reactions.get_by_id(i).reaction)
# Consuming and excreting minerals

# =============================================================================
#
# =============================================================================


# Exercise 4.2

from cobra.flux_analysis import single_reaction_deletion
deletions = single_reaction_deletion(model, model.reactions[:])
print(deletions)

essential = []
for i in range(len(deletions['flux'])):
    if deletions['flux'][i] < 0.001:
        essential.append(deletions['flux'].keys()[i])
print(len(essential))


frac = len(essential)/len(model.reactions)
print("Fraction of essential reactions for glucose:", frac, "=", str(frac*100)+"%")

# =============================================================================
#
# =============================================================================


# Exercise 4.3

modelac = read_sbml_model("iJO1366.xml")

for r in modelac.reactions:
    if r.objective_coefficient==1:
        biomass = r.id
        print(biomass)
        model.reactions.get_by_id(biomass).objective_coefficient = 1

modelac.reactions.get_by_id("EX_glc__D_e").lower_bound = 0
modelac.reactions.get_by_id('EX_ac_e').lower_bound = -10
sol_ac = modelac.optimize()
modelac.summary()

active_ac = []
for i in range(len(sol.x_dict)):
    if sol_ac.x_dict[i] > 0.0001 or sol_ac.x_dict[i] < -0.0001:
        active_ac.append(sol.x_dict.keys()[i])
print(len(active_ac))



deletions_ac = single_reaction_deletion(modelac, modelac.reactions[:])

essential_ac = []
for i in range(len(deletions_ac['flux'])):
    if deletions_ac['flux'][i] < 0.001:
        essential_ac.append(deletions_ac['flux'].keys()[i])

frac = len(essential_ac)/len(modelac.reactions)
print("Fraction of essential reactions for acetate:", frac, "=", str(frac*100)+"%")
# A higher fraction than with glucose



common = []
diff = []
for i in essential:
    if i in essential_ac:
        common.append(i)
    if i not in essential_ac:
        diff.append(i)
print(common)
print(len(common))
print(diff)

# =============================================================================
#
# =============================================================================


# Exercise 4.4
diff = []
for i in essential_ac:
    if not i in essential:
        diff.append(i)
print(diff)

# =============================================================================
#
# =============================================================================


# Exercise 4.5

fyle = open("iJO1366_reactionInfo.csv")
x = fyle.readlines()
fyle.close()


pathways = []
names = []
for i in x:
    l = i.split(",")
    pathways.append(l[6])
    names.append(l[1])

used_pathways = []
for i in essential:
    n= model.reactions.get_by_id(i).name
    for k in range(len(names)):
        if n == names[k]:
            used_pathways.append(pathways[k])

most = 0
m = "none"
upw = list(set(used_pathways))
for i in upw:
    count = 0
    for k in used_pathways:
        if i == k:
            count += 1
    if count > most:
        most = count
        m = i
    print(i, count)
print()
print("Pathway with most essential reactions:", m)


# =============================================================================
#
# =============================================================================

# Exercise 4.6
model_rich = read_sbml_model("iJO1366.xml")

rich = open("rich_environment.txt")
y = rich.readlines()
rich.close()

stripped = []
for i in y:
    stripped.append(i.strip())

iden = []
bounds = []
for i in stripped:
    if not len(i) == 0:
        ls = i.split("= ")
        print(ls)
        iden.append(ls[0].strip(" "))
        bounds.append(ls[1])


ids = []
metab = []
c = 0
for r in model.reactions:
    if r.id.startswith("EX"):
        met = str(r.metabolites).split("Metabolite ")[1].split(" at")[0]
        metab.append(met)
        if met in iden:
            ids.append(r.id)
print(ids)
#ids.sort()


for i in range(len(ids)):
    model_rich.reactions.get_by_id(ids[i]).lower_bound = int(bounds[i])

sol_rich = model_rich.optimize()
model_rich.summary()


from cobra.flux_analysis import single_reaction_deletion
deletions_rich = single_reaction_deletion(model_rich, model_rich.reactions[:])
print(deletions_rich)

essential_rich = []
for i in range(len(deletions_rich['flux'])):
    if deletions_rich['flux'][i] < 0.001:
        essential_rich.append(deletions_rich['flux'].keys()[i])
print(len(essential_rich))

# There are less essential reactions in a rich environment
# Which makes sense, as more options available
# A rich environment is probably more realistic in the gut, actually,
# considering what goes in


# =============================================================================
#
# =============================================================================

# Exercise 4.7


model = read_sbml_model("iJO1366.xml")

for r in model.reactions:
    if r.objective_coefficient==1:
        biomass = r.id
        print(biomass)
        model.reactions.get_by_id(biomass).objective_coefficient = 1

import string
alph = list(string.ascii_uppercase)

pot_carbs = []
for r in model.reactions:
    if r.id.startswith("EX"):
        met = str(r.metabolites).split("Metabolite ")[1].split(" at")[0]
        f = model.metabolites.get_by_id(met).formula
        for i in range(len(f)-1):
            if f[i] == "C":
                if f[i+1] in alph:
                    continue
                pot_carbs.append(r.id)
                print(r.id,f)

print(len(pot_carbs))


carbsource = []
model.reactions.get_by_id("EX_glc__D_e").lower_bound = 0
for i in pot_carbs:
    model.reactions.get_by_id(i).lower_bound = -10
    try:
        sol= model.optimize()
        model.reactions.get_by_id(i).lower_bound = 0
        if sol.f > 0.0001:
            carbsource.append(i)
    except:
        continue

print(carbsource)
print(len(carbsource))


### For aerobic/anaerobic: same as above but set O2 import to zero as well
for i in model.reactions:
    if "o2" in i.id:
        print(i.id)

# Anaerobic sources:
carbsource_unaer = []
model.reactions.get_by_id("EX_glc__D_e").lower_bound = 0
model.reactions.get_by_id("EX_o2_e").lower_bound = 0
for i in pot_carbs:
    model.reactions.get_by_id(i).lower_bound = -10
    try:
        sol= model.optimize()
        model.reactions.get_by_id(i).lower_bound = 0
        if sol.f > 0.0001:
            carbsource_unaer.append(i)
    except:
        continue

print(carbsource_unaer)
print(len(carbsource_unaer))

# Carbon sources for which e. coli is viable only aerobically:
diff_aer = []
for i in carbsource:
    if not i in carbsource_unaer:
        diff_aer.append(i)
print(diff_aer)
print(len(diff_aer))

# Carbon sources for which e. coli is viable only anaerobically:
diff_unaer = []
for i in carbsource_unaer:
    if not i in carbsource:
        diff_unaer.append(i)
print(diff_unaer)
print(len(diff_unaer))
# None!

# =============================================================================
#
# =============================================================================


# Exercise 4.8

diff_aer


model = read_sbml_model("iJO1366.xml")

for r in model.reactions:
    if r.objective_coefficient==1:
        biomass = r.id
        print(biomass)
        model.reactions.get_by_id(biomass).objective_coefficient = 1

biomass = []
model.reactions.get_by_id("EX_glc__D_e").lower_bound = 0
for i in diff_aer:
    model.reactions.get_by_id(i).lower_bound = -10
    try:
        sol= model.optimize()
        model.reactions.get_by_id(i).lower_bound = 0
        biomass.append(sol.f)
    except:
        continue


#diff_aer.remove("EX_ethso3_e")

import matplotlib.pyplot as plt
plt.plot(biomass, marker="o", color="green")