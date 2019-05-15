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
- [x] delivery window (P)
- [x] truck load (truck has limited capacity) (D)
- [x] truck ends on base and same day (G)
- [x] truck travel distance limit (P)
- [x] machine installation not on delivery day (D)
## Technician Constraints
- [x] technician and skill set of machine (G)
- [x] 5 workdays in sequence for technician (P)
- [x] after 5 day sequence: 2 days off (D)
- [x] technician route ends at his home location (G)
- [x] technician max travel distance (P)
- [x] technician: max requests per day (D)

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
