import math
import os
import sys
import csv
from parser import load
from simulated_annealing import search
import matplotlib.pyplot as plt


def plot_evaluations(instance_name, nr_nodes, nr_edges, evaluations, best_evaluation,
                     runtime, max_temperature, seed, show=True):
    props = dict(boxstyle='round', facecolor='lightblue', alpha=0.5)
    text = '\n'.join((r'$\mathrm{Runtime}=%d\mathrm{(ms)}$' % (runtime,),
                      r'$\mathrm{Seed}=%d$' % (seed,),
                      r'$T_{\mathrm{max}}=%d$' % (max_temperature,),
                      r'$\vert V \vert=%d$' % (nr_nodes,),
                      r'$\vert E \vert=%d$' % (nr_edges,),
                      r'$\mathrm{Best}=%d$' % (best_evaluation,)))
    fig, ax = plt.subplots()
    ax.plot(evaluations)
    ax.set(xlabel='Iterations', ylabel='# of vertices', title=('Solutions for instance %s' % instance_name))
    ax.text(0.55, 0.95, text, transform=ax.transAxes, fontsize=12, verticalalignment='top', bbox=props)

    if show:
        plt.show()
    else:
        plt.savefig('plots/%s_runtime_%ims_max_temperature_%i_seed_%i.png' %
                    (instance_name, runtime, max_temperature, seed))


if __name__ == '__main__':

    """
    Execute specific file with passed settings from args
    """
    if len(sys.argv) > 1:
        if not len(sys.argv) == 5:
            print('Argument missmatch. Should be e.g.:')
            print('python3 main.py <file_name> <runtime in ms> <max_temperature> <seed>')
            print('python3 main.py vc-exact_019.gr 60000 1 1')
            exit(1)

        filename = sys.argv[1]
        runtime = int(sys.argv[2])
        max_temperature = int(sys.argv[3])
        seed = int(sys.argv[4])

        print('')
        print('Running %s' % filename)
        print('runtime: %i' % runtime)
        print('max_temperature: %i' % max_temperature)
        print('seed: %i' % seed)
        print('')

        nr_nodes, edges = load(filename)
        best_solution, evaluation_list = search(nr_nodes, edges, runtime, max_temperature, seed)
        plot_evaluations(filename, nr_nodes, evaluation_list, len(best_solution), runtime, max_temperature, seed)
        exit(0)

    """
    Exectue all files from data directory with all available settings
    """
    data_files = filter(lambda x: '.gr' in x, os.listdir('data'))

    for filename in data_files:
        nr_runs = 10
        runtime = 60000
        max_temperature = 1

        overall_best = {'evaluation': math.inf}
        nr_nodes, edges = load(filename)
        best_evaluations_sum = 0

        print('')
        print('==========================')
        print('RUNNING %s %i TIMES' % (filename, nr_runs))
        print('RUNTIME: %i(ms) PER RUN' % runtime)
        print('MAX TEMPERATURE: %i' % max_temperature)

        for i in range(nr_runs):
            print('')
            print('RUN %i' % i)

            best_solution, evaluation_list = search(nr_nodes, edges, runtime, max_temperature, i)
            if len(best_solution) < overall_best['evaluation']:
                overall_best = {
                    'seed': i,
                    'evaluation': len(best_solution),
                    'evaluation_list': evaluation_list
                }
            best_evaluations_sum += len(best_solution)

        print('')
        print('DONE RUNNING %s' % filename)
        print('Average evaluation: %.2f' % (best_evaluations_sum / nr_runs))
        print('Best overall evaluation: %i' % overall_best['evaluation'])
        print('==========================')
        print('')

        # Append results to csv
        with open('data/results.csv', mode='a') as results_file:
            results_writer = csv.writer(results_file, delimiter=',')
            results_writer.writerow([filename, overall_best['evaluation'], (best_evaluations_sum / nr_runs)])

        # Plot best solution evaluations
        plot_evaluations(filename, nr_nodes, len(edges), overall_best['evaluation_list'], overall_best['evaluation'],
                         runtime, max_temperature, overall_best['seed'], show=False)

        break
