#!/usr/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <points_csv_file>"
    exit 1
fi

points_csv="$1"

python3 - <<EOF
import numpy as np
import pandas as pd
import sys
import random

points_data = pd.read_csv('$points_csv')
X = points_data['x'].values
Y = points_data['y'].values
Z = points_data['z'].values
n = len(X)

def objective_function(a, b, c):
    dist= np.sum((a*X + b*Y + c*Z - 1)**2)
    return dist/n

a = random.randint(-999, 999)
b = random.randint(-999, 999)
c = random.randint(-999, 999)

print("Initialised:", a, b, c)

threshold = 10e-6
max_epochs = 25

for epoch in range(max_epochs):
    grad_a = (2/n) * np.sum((a*X + b*Y + c*Z - 1) * X)
    grad_b = (2/n) * np.sum((a*X + b*Y + c*Z - 1) * Y)
    grad_c = (2/n) * np.sum((a*X + b*Y + c*Z - 1) * Z)
#    print(grad_a, grad_b, grad_c)
    grad = np.array([grad_a, grad_b, grad_c])
    
    H_aa = (2/n) * np.sum(X**2)
    H_bb = (2/n) * np.sum(Y**2)
    H_cc = (2/n) * np.sum(Z**2)
    H_ab = (2/n) * np.sum(X * Y)
    H_ac = (2/n) * np.sum(X * Z)
    H_bc = (2/n) * np.sum(Y * Z)
    H = np.array([[H_aa, H_ab, H_ac],
                  [H_ab, H_bb, H_bc],
                  [H_ac, H_bc, H_cc]])
    
    delta_theta = np.linalg.inv(H).dot(grad)
    
    a -= delta_theta[0]
    b -= delta_theta[1]
    c -= delta_theta[2]

    error = objective_function(a, b, c)
    if error < threshold:
        break

print("Optimal:", "{:.3f}".format(a), "{:.3f}".format(b), "{:.3f}".format(c))
print("Epochs:", epoch+1)
EOF
