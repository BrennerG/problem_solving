from parser import load
from simulated_annealing import search

if __name__ == '__main__':
    nr_nodes, edges = load('vc-exact_019.gr')
    best_solution = search(nr_nodes, edges, max_running_time=60000, max_temperature=1)
    print('### Best solution eval: %d ###' % len(best_solution))
