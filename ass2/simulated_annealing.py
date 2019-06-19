import math
import random

from util import current_milli_time

SEED = 1
random.seed(SEED)


def search(number_of_vertices, edges, max_running_time=1000, max_temperature=100000):
    """
    Starts search for solution using Simulated Annealing.

    :param number_of_vertices: the total number of vertices
    :param edges: all edges
    :param max_running_time: the time stopping criterion for the algorithm in milliseconds
    :param max_temperature: the maximum (starting) temperature
    :return: the best found solution
    """
    current_solution = create_initial_solution(number_of_vertices)
    best_solution = current_solution
    start_time = current_milli_time()
    while current_milli_time() - start_time < max_running_time:
        temperature = calculate_temp(max_temperature, start_time, current_milli_time(), max_running_time)
        neighbor = get_random_neighbor(current_solution, number_of_vertices)
        eval_current = evaluate(current_solution, edges)
        eval_neighbor = evaluate(neighbor, edges)
        if eval_neighbor < eval_current:
            current_solution = neighbor
            if eval_neighbor < evaluate(best_solution, edges):
                best_solution = neighbor
                print('Better solution found: ', best_solution)
        elif math.e ** ((eval_current - eval_neighbor) / temperature) > random.random():
            current_solution = neighbor
    return best_solution


def calculate_temp(max_temp, start_time, current_time, max_running_time):
    """
    Returns the current temperature which is proportional to the time elapsed
    and the time stopping criterion.

    :param max_temp: the current temperature
    :param start_time: the time the algorithm started in milliseconds
    :param current_time: the current time in milliseconds
    :param max_running_time: the max running time in milliseconds
    :return: a decreased temperature
    """
    return (0.00000001 - max_temp) * (current_time - start_time) / max_running_time + max_temp


def create_initial_solution(number_of_vertices):
    """
    Returns an initial solution which contains all vertices.

    :param number_of_vertices: the total number of vertices
    :return: a set of integers
    """
    initial_solution = set()
    for i in range(1, number_of_vertices + 1):
        initial_solution.add(i)
    return initial_solution


def get_random_neighbor(solution, number_of_vertices):
    """
    Returns a random neighbor for the given solution.

    :param solution: a set of integers, indicating the currently picked vertices
    :param number_of_vertices: the total number of vertices
    :return: a set of integers, representing a neighbor of solution
    """
    mutated_solution = solution.copy()
    random_vertex = random.randint(1, number_of_vertices)
    if random_vertex in mutated_solution:
        mutated_solution.remove(random_vertex)
    else:
        mutated_solution.add(random_vertex)
    return mutated_solution


def evaluate(solution, all_edges):
    """
    Evaluates the given solution by creating a set containing all covered edges,
    and checks whether all edges are covered. If that's the case, the number of elements
    is returned, otherwise infinity.

    :param solution: a set of integers
    :param all_edges: a set of sets containing two integers
    :return: infinity if no valid solution, otherwise number of elements
    """
    solution_edges = set()
    for v in solution:
        for e in all_edges:
            if v in e:
                solution_edges.add(e)
    if solution_edges != all_edges:
        return math.inf
    else:
        return len(solution)


if __name__ == '__main__':
    search(10, {frozenset([1, 2]), frozenset([2, 4]), frozenset([2, 6]),
                frozenset([4, 3]), frozenset([4, 5]),
                frozenset([3, 7]), frozenset([3, 8]),
                frozenset([7, 8]), frozenset([7, 9]), frozenset([7, 10])})
