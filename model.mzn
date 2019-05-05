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
array[int, locations_attr] of int: locations_data; 
array[int, requests_attr] of int: requests_data;
array[int, technicians_attr] of int: technicians_data;

% SOLUTION VARIABLES
/*
these are the variables that are summed up and need to be minimized by the solver.
we can probably implement methods to calculate these values from our custom data structure.
*/
var int: TRUCK_DISTANCE;
var int: NUMBER_OF_TRUCK_DAYS;
var int: NUMBER_OF_TRUCKS_USED;
var int: TECHNICIAN_DISTANCE;
var int: NUMBER_OF_TECHNICIAN_DAYS;
var int: NUMBER_OF_TECHNICIANS_USED;
var int: IDLE_MACHINE_COSTS;


% CUSTOM DATA STRUCTURE
/* TODO */


% CONSTRAINTS
constraint TRUCK_DISTANCE >= 0;
constraint NUMBER_OF_TRUCK_DAYS >= 0;
constraint NUMBER_OF_TRUCKS_USED >= 0;
constraint TECHNICIAN_DISTANCE >= 0;
constraint NUMBER_OF_TECHNICIAN_DAYS >= 0;
constraint NUMBER_OF_TECHNICIANS_USED >= 0;
constraint IDLE_MACHINE_COSTS >= 0;

% SOLVE
% TODO calculate idle machine costs
solve minimize TRUCK_DISTANCE * truck_distance_cost + NUMBER_OF_TRUCK_DAYS * truck_day_cost + NUMBER_OF_TRUCKS_USED * truck_cost + TECHNICIAN_DISTANCE * technician_distance_cost + NUMBER_OF_TECHNICIAN_DAYS * technician_day_cost + NUMBER_OF_TECHNICIANS_USED * technician_cost + IDLE_MACHINE_COSTS;