""" Reduce a multiline file to a matrix csv file

    Useful for Mathematica -> MATLAB conversion
"""
infile = open("4PAM/output_-3.txt")
outfile = open("4PAM/octave_-3.txt","a")
outfile.write(' '.join([line.strip() for line in infile.readlines()]).replace('}, {','\n').replace('{',' ').replace('}',' '))
