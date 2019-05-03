# VeRoLog 2019

# Parser

```
python3 parser.py input.txt output.dzn
```

```
python3 parser.py VSC2019_EX01.txt ex1.dzn
```

# Constraints
## Delivery Constraints
* delivery window (P)
* truck load (truck has limited capacity) (D)
* truck ends on base and same day (G)
* truck travel distance limit (P)
* machine installation not on delivery day (D)
## Technician Constraints
* technician and skill set of machine (G)
* 5 workdays in sequence for technician (P)
* after 5 day sequence: 2 days off (D)
* technician route ends at his home location (G)
* technician max travel distance (P)
* technician: max requests per day (D)

## Optional
* maximum idle days for machines (?)

# Target Function (G)
* distance travelled by truck
* truck use for day
* truck use at all
* distance travelled by technician
* technician use for a day
* technician use at all
* idle machine per day

# Datenstrukturen
## Truck-Array
[
 [Truck, Location, Request],
 ...
]
## Technician-Array
[
 [Technician, Location, Request],
 ...
]
