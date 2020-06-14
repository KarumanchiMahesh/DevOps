import re

# Reads the file
f = open("error.log", "r")

# Extracts id from line using regular expression
def finderror (line):
    result = re.search(r'\[\d+\]',line)
    id = result.group()
    return id 

# Returns the sorted logs based on id
def final_error (id, lines):
    logs = []
    for line in lines:
            result = re.search(r'\[\d+\]',line)
            if id == result.group():
                logs.append(line)
                length = len(logs)
                logs = logs[-4:]    
    logs[-1] = logs[-1]+" -----"
    return length, logs

lines = f.read().splitlines()
ids = []
counts = []
vals = []

for line in lines:
    result = re.search("ERROR",line)
    if result != None:
        error = result.group()
        id = finderror(line)
        
        ids.append(id)   
        count,val = final_error(id,lines)
        counts.append(count)
        vals.append(val)

flatten = lambda l: [item for sublist in l for item in sublist]
output = flatten(vals)
string = " // There are only "+ str(counts[-1]-1) +" messages before this error"
change=output[-1].split(" -----") 
output[-1] = change[0]+string

with open('report.log', 'w') as f:
    for item in output:
        f.write("%s\n" % item)