import re
import sys
from math import sqrt, ceil


def distance(x1, y1, x2, y2):
    return sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)


def distance_by_loc(a, b):
    [a_id, a_x, a_y] = a
    [b_id, b_x, b_y] = b
    return str(ceil(distance(int(a_x), int(a_y), int(b_x), int(b_y))))


def parse_lines(lines):
    out = []
    dicts = {}
    last_heading = ""

    for line in lines:
        splitted_var = re.split("\s+=\s+", line)

        if len(splitted_var) == 2:
            s0 = splitted_var[0]
            s1 = splitted_var[1]
            last_heading = s0

            if not s1.isdigit():
                out.append("%s = \"%s\";\n" % (s0, s1))
            else:
                out.append("%s = %s;\n" % (s0.lower(), s1))
        else:
            splitted_array = re.split("\s+", line)
            if "" in splitted_array:
                splitted_array.remove("")

            if len(splitted_array) > 1:
                if not last_heading in dicts:
                    dicts[last_heading] = []

                dicts[last_heading].append(splitted_array)

    for key in dicts.keys():
        data = dicts[key]

        c = ''
        for a in data:
            c = "%s| %s,\n" % (c, ", ".join(a))

        out.append("\n%s_data = [|\n%s|];\n" % (key.lower(), c[2:-2]))

    distances = {}
    for loc_1 in dicts["LOCATIONS"]:
        cur = loc_1[0]
        distances[cur] = []
        for loc_2 in dicts["LOCATIONS"]:
            distances[cur].append(distance_by_loc(loc_1, loc_2))

    dc = ''
    for loc_1 in distances.keys():
        data = distances[loc_1]
        o = ", ".join(data)
        dc = "%s| %s,\n" % (dc, o)

    out.append("\ndistances = [|\n%s|];\n" % (dc[2:-2]))

    return out


def parse_txt(file_name):
    lines = []
    with open(file_name) as log:
        lines = log.read().splitlines()
    return parse_lines(lines)


def write_data(file_name, out):
    f = open(file_name, "w")
    for o in out:
        f.write(o)
    f.close()


if __name__ == "__main__":

    if len(sys.argv) < 3:
        print("No log file passed. e.g.: python3 parser.py source.txt out.dzn")
        exit()

    write_data(sys.argv[2], parse_txt(sys.argv[1]))
