""" Reduce a multiline file to a matrix csv file

    Useful for Mathematica -> MATLAB conversion
"""
folders = ["tikhonov/"+num for num in map(str,range(1,6))]
symbols = ['0.00'+num for num in map(str,range(1,10))]
symbols.append('0.01')
runs = map(str,{1,3})

for folder in folders:
    for symbol in symbols:
        for run in runs:
            infile = open("4PAM/"+folder+"/output_"+symbol+"_"+run+".txt")
            outfile = open("4PAM/"+folder+"/octave_"+symbol+"_"+run+".txt","a")
            outfile.write(' '.join([line.strip() for line in infile.readlines()]).replace('{',' ').replace('}',' ').replace('\n',' ').replace('\r',' '))
