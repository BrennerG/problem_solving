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
array[int, machines_attr] of int: machines_data;

enum locations_attr;
array[int, locations_attr] of int: locations_data; 

enum requests_attr;
array[int, requests_attr] of int: requests_data;

enum technicians_attr;
array[int, technicians_attr] of int: technicians_data;