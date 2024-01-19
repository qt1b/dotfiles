import csv
from random import randrange
import math

def parseBrList(s: str) -> list():
    inATag = False
    res = [""]
    pos = 0
    for i in range(len(s)):
        if not inATag:
            if s[i] != '<':
                res[pos] += s[i]
            else:
                inATag=True
                if pos == 0:
                    res[0] = "<li id='optionTrue'>"+res[0]+"</li>"
                else:
                    res[pos] = "<li>"+res[pos]+"</li>"
        else:
            if s[i] == '>':
                inATag = False
                res.append("")
                pos += 1
    res[-1] = "<li>"+res[-1]+"</li>"
    return res
    
def shuffleList(l: list()) -> list():
    i = len(l)
    while (i > 0):
        j = math.floor( (randrange(31)/31) * i)
        i -= 1
        (l[i], l[j]) = (l[j], l[i])
    return l

def listToStr(l: list()) -> str:
    res = ""
    for e in l:
        res += e
    return res

# fields...
# 0: Cloze
# 1: FourAnswers
# 2: Notes
# 3: Tags

with open("input.tsv", "r") as file, open("output.tsv", "w") as outFile:
    reader = csv.reader(file, delimiter='\t')
    writer = csv.writer(outFile, delimiter='\t')
    for row in reader:
        row[1] = listToStr(shuffleList(parseBrList(row[1])))          
        writer.writerow(row)

print("done!")
    

