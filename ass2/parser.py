import os
path = 'data/'
script_dir = os.path.dirname(__file__)

# read like: nr_nodes, edges = load(file_name)
# no path necessary, just the file name
def load(file: str):

    # OPEN FILE
    full_path=os.path.join(script_dir, path,file)
    with open (full_path, "r") as myfile:
        data=myfile.read().split('\n')

    # READ LINES AS 
    for line in data:
        if line.startswith('c') or line.startswith(' ') or line == '':
            data.remove(line)

    # GET DATA
    nr_nodes = int(data[0].split(' ')[2])
    nr_edges = int(data[0].split(' ')[3])
    edges = frozenset(frozenset(map(int, x.split(' '))) for x in data[1:])

    # TODO nr_edges != len(edges)... probably double edges?

    # PRINT & RETURN
    print('LOAD\n' + str(nr_nodes), 'NODES', '\n' + str(nr_edges), 'EDGES')
    return nr_nodes, edges

# returns array of all data files names. can be used in a loop with load
def get_all_datafile_names():
    return os.listdir(os.path.join(script_dir, path))