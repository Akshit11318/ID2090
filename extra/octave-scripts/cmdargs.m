#! /bin/octave -qf
# this script prints the arguments supplied while calling the octave script
# -q to be quiet, not print usual greetings
# -f to avoid reading init files
# -------------------------------------------

printf ("%s", program_name ());

arg_list = argv ();

for i = 1:nargin
    printf (" %s", arg_list{i});
endfor

printf ("\n");

# -------------------------------------------
