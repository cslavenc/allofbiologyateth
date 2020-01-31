###IMPORTING MOULES###

import matplotlib.pyplot as plt

from scipy.stats import binom

######################



###DEFINE FUNCTIONS###

def calculate_insertions (X_ni_initial,Y_ins_initial,p,passage,max_reached,color):

    # initialize new data structure for split

    new_max_ni = max(X_ni_initial)

    X_new_ni = range(new_max_ni + 1)

    Y_new_ins = [0] * (new_max_ni + 1)

    if new_max_ni > 1000:

        print 'Max ins limit reached! Analysis will end at %s passage' %passage

        plt.show()

        return 0,0,True

    for ni, ins in zip(X_ni_initial, Y_ins_initial):

        for k in xrange(ni+1):

            Y_new_ins[k] += ins * binom.pmf(k, ni, p)

    plt.semilogx(X_new_ni, Y_new_ins, "%so"% color,basex = 10)

    print "%s SPLIT: Number of insertions lost: %.f" %(passage,Y_new_ins[0])

    insertions = sum(Y_new_ins[1:])

    print "Number of insertions: %.f (%.2f%%)"%(insertions,insertions/num_ins*100)

    return X_new_ni,Y_new_ins,False

######################



###DEFINE PARAMETERS### 

num_cells = raw_input("Cell number (5.0e8): ")

if num_cells == "":

    num_cells = 5.0e8

else:

    num_cells = float(num_cells)

num_ins = raw_input("Number of Insertions (5.0e7): ")

if num_ins == "":

    num_ins = 5.0e7

else:

    num_ins = float(num_ins)

split_ratio = raw_input("Split ratio (5): ")

if split_ratio == "":

    split_ratio = 5.0

else:

    split_ratio = float(split_ratio)

growth_ratio = raw_input("Growth ratio between splits (10): ")

if growth_ratio == "":

    growth_ratio = 10.0

else:

    growth_ratio = float(growth_ratio)

plating_efficiency = raw_input("Plating efficiency (50%): ")

if plating_efficiency == "":

    plating_efficiency = 0.5

else:

    plating_efficiency = float(plating_efficiency) / 100



print '***STARTING***\nUsed parameters:'

print "\tCell number: ", num_cells

print "\tInsertions: ", num_ins

print "\tSplit ratio: ", split_ratio

print "\tGrowth ratio: ", growth_ratio

print "\tPlating efficiency: ", plating_efficiency

######################









 

# INITIAL SPLIT OF POOL IS 1 : 2 FIXED - Control and Selected

 

X_ni_initial = [int(round(num_cells / num_ins, 0))]

Y_ins_initial = [num_ins]

max_reached = False

colors = ['r','b','g','c','y','k','m']

color_n = 0 



print "\nInitial ni = ", X_ni_initial[0]

 

# split them using plating efficiency and split ratio of 2 using binomial distributions

p = plating_efficiency * 0.5

X_new_ni,Y_new_ins,max_reached = calculate_insertions (X_ni_initial,Y_ins_initial,p,'INITIAL',max_reached,colors[color_n])

 

# SECOND SPLIT --------------------------------------------

p = plating_efficiency * (1/split_ratio)

color_n +=1



Y_ins_initial = Y_new_ins

X_ni_initial = [int(round(x * 2 * plating_efficiency, 0)) for x in X_new_ni]

X_new_ni,Y_new_ins,max_reached = calculate_insertions (X_ni_initial,Y_ins_initial,p,'SECOND',max_reached,colors[color_n])

 

# OTHERS SPLIT --------------------------------------------

for passage in ['THIRD','FOURTH','FIFTH','SIXTH','SEVENTH']:

    if not max_reached:

        color_n +=1 

        Y_ins_initial = Y_new_ins

        X_ni_initial = [int(round(x * growth_ratio, 0)) for x in X_new_ni]

        X_new_ni,Y_new_ins,max_reached = calculate_insertions (X_ni_initial,Y_ins_initial,p,passage,max_reached,colors[color_n])



plt.show()