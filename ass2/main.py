import os
import sys
from parser import load
from simulated_annealing import search
import matplotlib.pyplot as plt


def plot_evaluations(instance_name, nr_nodes, evaluations, best_evaluation, runtime, max_temperature, seed, show=True):
    props = dict(boxstyle='round', facecolor='lightblue', alpha=0.5)
    text = '\n'.join((r'$\mathrm{Runtime}=%d\mathrm{(ms)}$' % (runtime,),
                      r'$\mathrm{Seed}=%d$' % (seed,),
                      r'$T_{\mathrm{max}}=%d$' % (max_temperature,),
                      r'$\mathrm{Best}= %d$' % (best_evaluation,),
                      r'$\mathrm{Improvement}= %.2f\%%$' % ((nr_nodes - best_evaluation) / nr_nodes * 100)))
    fig, ax = plt.subplots()
    ax.plot(evaluations)
    ax.set(xlabel='Iterations', ylabel='# of vertices', title=('Solutions for instance %s' % instance_name))
    ax.text(0.55, 0.95, text, transform=ax.transAxes, fontsize=14, verticalalignment='top', bbox=props)

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
        best_solution, evaluations = search(nr_nodes, edges, runtime, max_temperature, seed)
        plot_evaluations(filename, nr_nodes, evaluations, len(best_solution), runtime, max_temperature, seed)
        exit(0)

    """
    Exectue all files from data directory with all available settings
    """
    data_files = filter(lambda x: '.gr' in x, os.listdir('data'))

    settings = [
        dict(runtime=60000, max_temperature=1, seed=1),
        dict(runtime=60000, max_temperature=1, seed=2),
    ]

    for filename in data_files:
        print('')
        print('==========================')
        print('RUNNING %s' % filename)

        for setting in settings:
            [runtime, max_temperature, seed] = setting.values()

            print('')
            print('RUNTIME: %i ms' % runtime)
            print('MAX TEMPERATURE: %i' % max_temperature)
            print('SEED: %i' % seed)

            nr_nodes, edges = load(filename)
            best_solution, evaluations = search(nr_nodes, edges, runtime, max_temperature, seed)
            plot_evaluations(filename, nr_nodes, evaluations, len(best_solution), runtime, max_temperature, seed, show=False)

