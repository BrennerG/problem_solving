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
array[int, 1..6] of int: requests_data;
array[int, 1..4+machines] of int: technicians_data;

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
% The row indeces represent the request id
% order | day | truck id
array[1..requests, 1..3] of var int: trucks_assignment;
% order | day | technician id
array[1..requests, 1..3] of var int: technicians_assignment;


/* * * * * * *
  CONSTRAINTS
* * * * * * * * 
* * * * * * * */

/* DOMAIN CONSTRAINTS */

constraint % Domain constraints for truck assignment
  forall(request_id in 1..requests)(
    (trucks_assignment[request_id, 1] >= 1 /\ trucks_assignment[request_id, 1] <= requests) /\
    (trucks_assignment[request_id, 2] >= 1 /\ trucks_assignment[request_id, 2] <= days) /\
    (trucks_assignment[request_id, 3] >= 1 /\ trucks_assignment[request_id, 3] <= requests)
  );

constraint % Domain constraints for technician assignment
  forall(request_id in 1..requests)(
    (technicians_assignment[request_id, 1] >= 1 /\ technicians_assignment[request_id, 1] <= requests) /\
    (technicians_assignment[request_id, 2] >= 1 /\ technicians_assignment[request_id, 2] <= days) /\
    (technicians_assignment[request_id, 3] >= 1 /\ technicians_assignment[request_id, 3] <= technicians)
  );

constraint % orders are unique
  alldifferent(col(trucks_assignment, 1));

constraint % orders are unique
  alldifferent(col(technicians_assignment, 1));

constraint % day interval allowed
  forall(request_id in 1..requests)(
    trucks_assignment[request_id, 2] >= requests_data[request_id, 3] /\ % day assigned has to be greater than delivery_start
    trucks_assignment[request_id, 2] <= requests_data[request_id, 4]    % day assigned has to be less than delivery_end
  );

constraint % installation day has to be after delivery day
  forall(request_id in 1..requests)(
    technicians_assignment[request_id, 2] > trucks_assignment[request_id, 2]
  );
 
constraint % technicans skill set
  forall(req in 1..requests) (
    forall(mac in 1..machines) (
      if requests_data[req,5] = mac
        then technicians_data[technicians_assignment[req,3],4+mac] = 1 
      endif
    )
  );

% SOLVE
% TODO minimize
solve satisfy;

output ["Trucks:\n"] ++ ["\(i): \(row(trucks_assignment, i))\n" | i in 1..requests];
output ["Technicians:\n"] ++ ["\(i): \(row(technicians_assignment, i))\n" | i in 1..requests];
