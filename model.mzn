include "globals.mzn";

% DATA FROM .DZN
string: DATASET;
string: NAME;
int: days;
int: truck_capacity;
int: truck_max_distance;
int: truck_distance_cost;
int: truck_day_cost;
int: truck_cost;
int: technician_distance_cost;
int: technician_day_cost;
int: technician_cost;
int: machines;
int: locations;
int: requests;
int: technicians;
enum machines_attr;
enum locations_attr;
enum requests_attr;
enum technicians_attr;
array[int, machines_attr] of int: machines_data;
array[int, 1..3] of int: locations_data; 
array[int, requests_attr] of int: requests_data;
array[int, technicians_attr] of int: technicians_data;

% CUSTOM FUNCTIONS
function float: distance(int:a, int:b) = ( % calculates the distance between location with id a and location with id b
  sqrt( pow(locations_data[a,1]-locations_data[b,1],2) + pow(locations_data[a,2]-locations_data[b,2],2) )
);

/*
SOLUTION VARIABLES
these are the variables that are summed up and need to be minimized by the solver.
we can probably implement methods to calculate these values from our custom data structure.

var int: TRUCK_DISTANCE;
var int: NUMBER_OF_TRUCK_DAYS;
var int: NUMBER_OF_TRUCKS_USED;
var int: TECHNICIAN_DISTANCE;
var int: NUMBER_OF_TECHNICIAN_DAYS;
var int: NUMBER_OF_TECHNICIANS_USED;
var int: IDLE_MACHINE_COSTS;
*/

% DECISION VARIABLES
% request id | day | truck id
array[1..requests, 1..3] of var int: trucks_assignment;
% request id | day | technician id
array[1..requests, 1..3] of var int: technicians_assignment;

/* * * * * * *
  CONSTRAINTS
* * * * * * * * 
* * * * * * * */

/* DOMAIN CONSTRAINTS */

constraint % Domain constraints for truck assignment
  forall(i in 1..requests)(
    (trucks_assignment[i, 1] >= 1 /\ trucks_assignment[i, 1] <= requests) /\
    (trucks_assignment[i, 2] >= 1 /\ trucks_assignment[i, 2] <= days) /\
    (trucks_assignment[i, 3] >= 1 /\ trucks_assignment[i, 3] <= requests)
  );

constraint % Domain constraints for technician assignment
  forall(i in 1..requests)(
    (technicians_assignment[i, 1] >= 1 /\ technicians_assignment[i, 1] <= requests) /\
    (technicians_assignment[i, 2] >= 1 /\ technicians_assignment[i, 2] <= days) /\
    (technicians_assignment[i, 3] >= 1 /\ technicians_assignment[i, 3] <= technicians)
  );

constraint % request ids are unique
  alldifferent(col(trucks_assignment, 1));

constraint % request ids are unique
  alldifferent(col(technicians_assignment, 1));

% SOLVE
% TODO minimize
solve satisfy;

output ["Trucks:\n"] ++ ["\(row(trucks_assignment, i))\n" | i in 1..requests];
output ["Technicians:\n"] ++ ["\(row(technicians_assignment, i))\n" | i in 1..requests];
