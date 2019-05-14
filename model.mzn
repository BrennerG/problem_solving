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
array[int, 1..3] of int: machines_data;
array[int, 1..3] of int: locations_data;
array[int, 1..6] of int: requests_data;
array[int, 1..4+machines] of int: technicians_data;
array[1..locations, 1..locations] of int: distances;

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
% days
array[1..technicians, 1..days] of var 0..1: technicians_workdays;
% order
array[1..requests] of var 1..requests: requests_order;

int: max_valid_workdays = 5;

% CUSTOM FUNCTIONS
function int: distance(int:a, int:b) = ( % calculates the distance between location with id a and location with id b
  round(sqrt( pow(locations_data[a,1]-locations_data[b,1],2) + pow(locations_data[a,2]-locations_data[b,2],2) ) + 1)
);

function var int: technician_max_travel(var int:id) = technicians_data[id, 3];
function var int: technician_max_requests(var int:id) = technicians_data[id, 4];

function var int: truck_max_capacity(var int:id) = technicians_data[id, 4];

function var int: request_installation_day(var int:request_id) = technicians_assignment[request_id, 2];
function var int: request_technician(var int:request_id) = technicians_assignment[request_id, 3];

function var int: request_delivery_order(var int:request_id) = trucks_assignment[request_id, 1];
function var int: request_delivery_day(var int:request_id) = trucks_assignment[request_id, 2];
function var int: request_delivery_truck(var int:request_id) = trucks_assignment[request_id, 3];

function var int: request_delivery_size(var int:request_id) = machines_data[requests_data[request_id, 5], 2] * requests_data[request_id, 6];


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
  forall(request_id in 1..requests)(
     requests_order[trucks_assignment[request_id, 1]] = request_id
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
    request_installation_day(request_id) > trucks_assignment[request_id, 2] /\
    technicians_workdays[request_technician(request_id), request_installation_day(request_id)] = 1
  );

constraint % technicians has to be 2 days off after a 5 days series
  if days <= max_valid_workdays
    then true
    else forall(technician_id in 1..technicians)(
      forall(day in 1..days-max_valid_workdays-2) (
        sum (s in 1..max_valid_workdays)(technicians_workdays[technician_id, day+s]) = max_valid_workdays /\ sum (h in 1..2)(technicians_workdays[technician_id, day+max_valid_workdays+h]) == 0
      )
    )
  endif;

constraint % technicians max requests per day
  forall(request_id in 1..requests)(
    sum ([ 1 | r in 1..requests where request_installation_day(r) = request_installation_day(request_id) ]) <= technician_max_requests(request_technician(request_id))
  );


constraint % truck max load per day
  forall(request_id in 1..requests)(
    sum (r in 1..requests where request_delivery_day(r) = request_delivery_day(request_id) /\ request_delivery_truck(r) = request_delivery_truck(request_id))
                                                          (machines_data[requests_data[r, 5], 2] * requests_data[r, 6]) <= truck_capacity
  );

constraint % truck max travel distance per day
  forall(request_id in 1..requests)(
    sum (request_order in 1..requests-1 where trucks_assignment[request_id, 1] = request_order /\
                                              trucks_assignment[request_order, 3] = trucks_assignment[request_id, 3] /\
                                              trucks_assignment[request_order, 2] = trucks_assignment[request_id, 2])
        (distance(requests_data[request_id, 2], requests_data[request_order, 2])) <= truck_max_distance
/*
            % subtract depot to first location
            - distance(1, min (request_order in 1..requests)(
                            if trucks_assignment[request_order, 3] = trucks_assignment[request_id, 3] /\
                               trucks_assignment[request_order, 2] = trucks_assignment[request_id, 2]
                            then request_order
                            else zero
                            endif
                            ))  -
            % subtract depot to last location
            distance(1, max (request_order in 1..requests)(
                            if trucks_assignment[request_order, 3] = trucks_assignment[request_id, 3] /\
                               trucks_assignment[request_order, 2] = trucks_assignment[request_id, 2]
                            then request_order
                            else zero
                            endif
                            ))
*/
  );


constraint % technicans skill set
  forall(request_id in 1..requests) (
    forall(machine_id in 1..machines) (
      if requests_data[request_id, 5] = machine_id
        then technicians_data[request_technician(request_id), 4 + machine_id] = 1
      endif
    )
  );

% SOLVE
% TODO minimize
solve satisfy;

output ["Trucks:\n"] ++ ["\(i): \(row(trucks_assignment, i))\n" | i in 1..requests];
output ["Technicians:\n"] ++ ["\(i): \(row(technicians_assignment, i))\n" | i in 1..requests];
output ["Workdays:\n"] ++ ["\(i): \(row(technicians_workdays, i))\n" | i in 1..technicians];
output ["Order:"] ++ [show(requests_order)];

