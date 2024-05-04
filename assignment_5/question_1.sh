#!/usr/bin/bash
#pip install antlr4-tools --target ~/local/
#pip install antlr4-python3-runtime --target ~/local/
#pip install --target ~/local/ --upgrade scipy

python3 - "$@" <<END
import sys
sys.path.append('~/local')
import sympy as sp
from sympy.parsing.latex import parse_latex
from sympy import symbols, exp, I, fft, ifft,fourier_transform
from sympy.parsing.sympy_parser import parse_expr, standard_transformations, implicit_multiplication
import warnings
warnings.filterwarnings("ignore")

def latex_to_sympy(latex_str):
    sympex = parse_latex(latex_str)
    sympex_str = str(sympex)

    if 'e**' in sympex_str:
        sympex_str = sympex_str.replace('e**', 'exp')
        sympex = parse_expr(sympex_str, transformations=(standard_transformations + (implicit_multiplication,)))
    return sympex

if __name__ == "__main__":
    file_path = sys.argv[1]
    with open(file_path, 'r') as file:
            lines = file.readlines()
            equation1_str = lines[0].strip()
            equation2_str = lines[1].strip()


    expr1 = latex_to_sympy(equation1_str)
    expr2 = latex_to_sympy(equation2_str)
    x, t = symbols('x t')
    F1 = fourier_transform(expr1, x,t)
    F2 = fourier_transform(expr2, x,t)
    convolved_F = F1 * F2
    convoluted_expr = sp.inverse_fourier_transform(convolved_F,t,x)
    convoluted_expr = sp.simplify(convoluted_expr)
    print(sp.latex(convoluted_expr))
END

