#!/usr/bin/bash

python3 - "$@" <<END
import sys
from sympy import symbols, diff

# Define symbols
z = symbols('z')

filename = sys.argv[1]
with open(filename, 'r') as file:
    func_z = file.readline().strip()

func_expr = eval(func_z)
Pdiff = diff(func_expr, z)
cpp_code = f'''
#include<iostream>
#include<cmath>
using namespace std;


double calculate_v_z(double r) {{
    double Pdiff = {Pdiff};
    return (Pdiff / 4.0) * (1 - pow(r, 2));
}}

int main(int argc, char* argv[]) {{

double radius = stod(argv[1]);
    double v_z = calculate_v_z(radius);
    cout <<v_z << endl;
    return 0;
}}

'''


with open('vel2.cpp', 'w') as file:
    file.write(cpp_code)


import subprocess
subprocess.run(["g++", "-o", "vel.cpp", "vel2.cpp"])
END

rm vel2.cpp
