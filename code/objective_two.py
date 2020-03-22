from gurobipy import *
import math
import numpy as np
import matplotlib.pyplot as plt

def distance(a,b):
    dx = a[0] - b[0]
    dy = a[1] - b[1]
    return math.sqrt(dx*dx + dy*dy)

def get_cmap(n,name='hsv'):
    return plt.cm.get_cmap(name,n)

k = 20
# get k from terimal input, default set to 10
if len(sys.argv) > 1:
    k = int(sys.argv[1])

clients = np.loadtxt('../data/poi_1.data')
facilities = np.loadtxt('../data/poi_1.data')
numFacilities = len(facilities)
numClients = len(clients)
m = Model()

# Add variables
x = {}
y = {}
d = {} # Distance matrix (not a variable)
alpha = 1

for j in range(numFacilities):
    x[j] = m.addVar(vtype=GRB.BINARY, name="x%d" % j)
for i in range(numClients):
    for j in range(numFacilities):
        y[(i,j)] = m.addVar(lb=0, vtype=GRB.CONTINUOUS, name="t%d,%d" % (i,j))
        d[(i,j)] = distance(clients[i], facilities[j])
        m.update()

# Add constraints
for i in range(numClients):
    for j in range(numFacilities):
        m.addConstr(y[(i,j)] <= x[j])

for i in range(numClients):
    m.addConstr(quicksum(y[(i,j)] for j in range(numFacilities)) == 1)

for i in range(numFacilities):
    m.addConstr(quicksum(x[i] for i in range(numFacilities)) <= k)

m.setObjective( quicksum(quicksum(alpha*d[(i,j)]*y[(i,j)] \
 for i in range(numClients)) for j in range(numFacilities)) )
m.optimize()


# Print solution
# print(v.varName, v.x)

selected_id = []
print('\nTOTAL COSTS: %g' % m.objVal)
for v in m.getVars():
    if 'x' in v.varName:
        if v.x == 1:
            selected_id.append(int(v.varName[1:]))

clusters = [[sid] for sid in selected_id]
for v in m.getVars():

    if 't' in v.varName:
        if v.x != 0:
            for cluster in clusters:
                if int(v.varName.split(',')[1]) in cluster:
                    cluster.append(int(v.varName.split(',')[0][1:]))


print(clusters)
# visualize the selected result on the data (add vs not add)

def vis_add_or_not(selected_id):
    colors = []
    for i in range(numClients):
        if i in selected_id:
            colors.append('red')
        else:
            colors.append('blue')
    mkrs = []

    for  _x, _y, c in zip(clients[:,0],clients[:,1], colors):
        plt.scatter(_x, _y, c=c)
    #plt.scatter(clients[:,0], clients[:,1],marker = mkrs,c=colors ,alpha=0.5)
    plt.savefig("../plot/num1_"+str(k)+".png",transparent=True)
    # Note: only png can handle transparent!
    # Note: some points are overlapping

# visualize the clustered result on the data
def vis_by_group(clusters):
    colors = []
    cmap = get_cmap(len(clusters))
    for i in range(numClients):
        for j in range(len(clusters)):
            if i in clusters[j]:
                colors.append(cmap(j))
    for  _x, _y, c in zip(clients[:,0],clients[:,1], colors):
        plt.scatter(_x, _y, c=c)
    plt.savefig("../plot/cluster1_num_"+str(k)+".png",transparent=True)

print(selected_id)

