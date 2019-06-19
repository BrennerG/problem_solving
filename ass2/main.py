from parser import load
from simulated_annealing import search

import matplotlib.pyplot as plt


def plot_evaluations(instance_name, nr_nodes, evaluations, best_evaluation, runtime, max_temperature, seed):
    props = dict(boxstyle='round', facecolor='lightblue', alpha=0.5)
    text = '\n'.join((r'$\mathrm{Runtime}=%d\mathrm{(ms)}$' % (runtime,),
                      r'$\mathrm{Seed}=%d$' % (seed,),
                      r'$T_{\mathrm{max}}=%d$' % (max_temperature,),
                      r'$\mathrm{Best}= %d$' % (best_evaluation,),
                      r'$\mathrm{Improvement}= %.2f\%%$' % ((nr_nodes - best_evaluation) / nr_nodes * 100)))
    fig, ax = plt.subplots()
    ax.plot(evaluations)
    ax.set(xlabel='Change iterations', ylabel='# of vertices', title=('Solutions for instance %s' % instance_name))
    ax.text(0.55, 0.95, text, transform=ax.transAxes, fontsize=14, verticalalignment='top', bbox=props)
    plt.show()


if __name__ == '__main__':
    filename = 'vc-exact_019.gr'
    runtime = 60000
    max_temperature = 1
    seed = 1

    nr_nodes, edges = load(filename)
    best_solution, evaluations = search(nr_nodes, edges, runtime, max_temperature, seed)
    plot_evaluations(filename, nr_nodes, evaluations, len(best_solution), runtime, max_temperature, seed)
