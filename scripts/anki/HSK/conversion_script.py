"""
this is a python script to add zhuyin and remove the content of 
the simplified fields if they are the same as traditional fields.
made for the following anki deck : https://www.reddit.com/r/ChineseLanguage/comments/7mjmjc/best_anki_deck_for_hsk_ive_come_across/
the modified deck is available here : 

to use it you must first export the notes of the deck to the txt format, 
rename it to input.tsv and execute this script in the right folder.

please see the comments at line 176, use the vim commands if you meet the same problem

then you can import the content with the import button, and update the notes

you must install dragonmapper to use this script, please use the following command:
`pip install dragonmapper`

some logging features have been disabled, please enable them if you need to
"""

from dragonmapper import transcriptions
from dragonmapper import hanzi
import csv

# to remove html tags
def remove_div(s: str) -> str:
    i = 0
    res = ""
    while i != len(s):
        if s[i] == '<':
            while s[i] != '>':
                i += 1
            i+=1
        else:
            res += s[i]
            i+=1
    return res

# to remove unwanted characters
def remove_etc(s: str) -> str:
    res = ""
    for i in range(len(s)):
        if s[i] not in " \'\",.!?…《》“”":
            res+= s[i]
    return res
 
def remove_both(s : str) -> str:
    return remove_div(remove_etc(s))
       
# only useful when having to deal with hanzi
def nuke_ascii(s: str) -> str:
    res = ""
    nuked = ''.join(chr(i) for i in range(128))
    nuked += "《》“”！。，？、"
    for i in range(len(s)):
        if s[i] not in nuked:
            res += s[i]
    return res

def replace(s: str, to_be_rep: str, replacement: str) -> str:
    res = ""
    v = 0
    for i in range(len(s)):
        if v == len(to_be_rep):
            res += replacement + s[i:]
            break
        elif s[i] == to_be_rep[v]:
            v += 1
        else:
            v = 0
            res += s[i]
    return res
        
# fieldNames = ["index","simpl","trad","py1","py2","zhu","en","grammar","sound","homophone","homograph","sentencesimpl","sentencetrad","clozeSimpl","clozeTrad","sentpy1","sentpy2","sentZhuyin","sentMeaning","sentAudio","sentImage"]
# fields...
# 0: key (~= index)
# 1: simplified
# 2: traditional
# 3: pinyin 1
# 4: pinyin 2
# 5: zhuyin (that we want to fill)
# 8: audio
# 11: sentence simlified
# 12: sentence traditional
# 13: cloze simplified
# 14: cloze traditional
# 15: sentence pinyin 1
# 16: sentence pinyin 2
# 17: sentence zhuyin
# 19: sentence audio
# 20: image

empty_sentences = 0
not_working_words_list = []
not_working_sentences_list = []
#same_words = []
#same_sentences = []
#same_cloze = []

with open("input.tsv", "r") as file, open("output.tsv", "w") as outFile:
    reader = csv.reader(file, delimiter='\t')
    writer = csv.writer(outFile, delimiter='\t')
    for row in reader:
        colValues = row
        
        # getting the zhuyin for the word
        try:
            colValues[5] = transcriptions.to_zhuyin(colValues[4])          
        except:
            try:
                # print(colValues[4], "colValue[4]")
                colValues[5] = transcriptions.to_zhuyin(remove_etc(colValues[4]))
                # print("ok, word state 2")
            except:
                try:
                    # print(colValues[3], "colValue[3]")
                    colValues[5] = transcriptions.to_zhuyin(remove_etc(colValues[3]))
                    # print("ok, word state 3")
                except:
                    try:
                    # we will now try from the word as a hanzi
                        # print(nuke_ascii(colValues[1]))
                        colValues[5] = hanzi.to_zhuyin(nuke_ascii(colValues[2]))
                    except:
                        if (colValues[2] == "哦"):
                            colValues[5] = "ㄛˋ,ㄛˊ,˙ㄛ, ㄜˊ"
                        else:
                            not_working_words_list.append(colValues[0])
                            print("invalid word")
                            print(colValues[2])
                            print(colValues[3]+":"+colValues[4])

                    
        # getting the zhuyin for the sentences
        try:
            if (colValues[15] == "" or colValues[16] == ""):
                empty_sentences += 1
            else:
                colValues[17] = transcriptions.to_zhuyin(remove_both(colValues[16]))
        except:
            try:
                #print(":" + colValues[16] + ":colValue[16]")
                #print(":" + colValues[15] + ":colValue[15]")
                #print(remove_both(colValues[16]))
                colValues[17] = transcriptions.to_zhuyin(remove_both(colValues[15]))
                #print("ok, sentence state 2")
            except:
                try:
                    # print(nuke_ascii(colValues[11]))
                    colValues[17] = hanzi.to_zhuyin(nuke_ascii(colValues[11]))
                except:
                    if remove_div(colValues[12]) == "哦！太好了！":
                        colValues[17] = "ㄛˋ" + transcriptions.to_zhuyin("tai4hao3le5")
                    else:
                        not_working_sentences_list.append(colValues[0])
                        print("invalid sentence")
                        print(colValues[12])
                        print(colValues[15]+":"+colValues[16])
        
        
        
        # checking if the traditional and the simplified words and/or sentences are the same.
        # if it is the case, we remove the simplified
        if colValues[1] == colValues[2]:
            colValues[1] = ""
            #same_words.append(colValues[0])
        if colValues[11] == colValues[12]:
            colValues[11] = ""
            #same_sentences.append(colValues[0])
        if colValues[13] == colValues[14]:
            colValues[13] = ""
            #same_cloze.append(colValues[0])
            
        # replacing mp3 by opus and jpg by avif
        colValues[8] = colValues[8].replace(".mp3",".opus")        
        colValues[19] = colValues[19].replace(".mp3",".opus")
        
        colValues[20] = colValues[20].replace(".jpg",".avif")
        # it is needed to modify the output file a bit because for some strange reason, there have been added quotes that break the paths.
        # you can use the following commands with vim:
        # %s,""",,g
        # :%s,"<,<,g  
        # :%s,>",>,g  
        # :%s,"" /," /,g
        # :%s,"">,">,g
        
        # writing the modified row to the output file
        writer.writerow(colValues)

# logging the results
logger = open("log.txt", "w")

if len(not_working_words_list) == 0:
    logger.write("all words are working\n")
elif len(not_working_words_list) == 1:
    logger.write("the following word is not working: "+not_working_words_list[0]+'\n')
else:
    logger.write(str(len(not_working_words_list)) + " words are not working:\n")
    logger.write(str(not_working_words_list) +'\n')
    
if len(not_working_sentences_list) == 0:
    logger.write("all sentences are working\n")
elif len(not_working_sentences_list) == 1:
    logger.write("the following sentence is not working: "+not_working_sentences_list[0]+'\n')
else:
    logger.write(str(len(not_working_sentences_list)) + " sentences are not working:\n")
    logger.write(str(not_working_sentences_list) +'\n')
    
logger.write(str(empty_sentences)+ " empty sentences\n")

"""
logger.write(str(len(same_words))+ " same words:\n")
logger.write(str(same_words)+'\n')
logger.write(str(len(same_sentences))+ " same sentences\n")
logger.write(str(same_sentences)+'\n')
logger.write(str(len(same_cloze))+ " same cloze\n")
logger.write(str(same_cloze)+'\n')
"""

print("done! please see log.txt for more details")
    

