import numpy as np
import pandas as pd


def get_distance_matrix(pop_data,type='l1'):
    '''

    :param pop_data: n entries of row_id,col_id,grid_population
    :param type: distance type, l1, l2, ..
    :return: n * n distance matrix
    '''
    n = pop_data.shape[0]
    dist = np.zeros((n,n))
    for i in range(n):
        for j in range(i+1,n):
            dist[i,j] = int(abs(pop_data.x[i]-pop_data.x[j])/0.0083) + \
                        int(abs(pop_data.y[i]-pop_data.y[j])/0.00833)
    dist = dist + np.transpose(dist)

    return dist


def cal_gain(pop,gid,selected_ids,dist,theta):
    '''

    :param pop: a list of n grid population data
    :param gid: grid id
    :param selected_ids: selected ids
    :param dist: distance matrix
    :param theta: turning parameter
    :return:
    '''
    inc_gain = 0
    n = len(pop)
    if len(selected_ids) == 0:
        for i in range(n):
            inc_gain += np.exp(-dist[i, gid] / theta) * pop[i]
    else:
        for i in range(n):
            tmp_dist = min(dist[i,selected_ids])
            if dist[i,gid] < tmp_dist:
                inc_gain += (np.exp(-dist[i,gid]/theta) - np.exp(-tmp_dist/theta)) * pop[i]
    return inc_gain


def greedy_selection(k,dist,pop,theta=1):
    '''

    :param k: number of sensors available
    :param dist: distance matrix
    :param pop: population data
    :param theta: tuning parameter
    :return:
    selected ids
    '''
    selected_ids = []
    n = len(pop)
    for i in range(k):
        tmp_gain = 0
        tmp_id = 0
        for gid in range(n):
            inc_gain = cal_gain(pop,gid,selected_ids,dist,theta)
            if inc_gain >tmp_gain:
                tmp_gain = inc_gain
                tmp_id = gid
        selected_ids.append(tmp_id)
    return selected_ids


pop_data = pd.read_csv("../data/pop.csv")
dist = get_distance_matrix(pop_data)
k = 10
selected_ids = greedy_selection(k,dist,pop_data.population,theta=1)
print('selected ids:',selected_ids)
print(pop_data.population[selected_ids])