""" Reduce a multiline file to a matrix csv file

    Useful for Mathematica -> MATLAB conversion
"""
affix = "3"
infile = open("4PAMtiming/output_"+affix+".txt")
outfile = open("4PAMtiming/octave_"+affix+".txt","a")
outfile.write(' '.join([line.strip() for line in infile.readlines()]).replace('}, {','\n').replace('{',' ').replace('}',' '))
