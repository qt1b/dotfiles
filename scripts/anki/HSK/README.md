- [origin of the deck](https://www.reddit.com/r/ChineseLanguage/comments/7mjmjc/best_anki_deck_for_hsk_ive_come_across/) 
- [uploaded deck with the modifications](), please go to this page to download the modified deck
- [python script who does the modifications](conversion_script.py)


## Commands used for conversion
audio conversion: `ffmpeg -i "$file" -ar 48000 -ac 2 -acodec libopus -ab 128k "${file%.*}.opus"`

image conversion: `magick convert "$file" -quality 60% "${file%.*}.avif"`


# recommended card formatting:
here are some suggestions for formatting the cards as you wish, please note that I'm not a web dev so some formatting might have been done the wrong way. 

## Mix of traditional and simplified Chinese (default)
### front
```
<span class="front" lang="zh">

<span class="tradHanzi">{{Traditional}}</span>
{{#Simplified}}
<span class="simplHanzi">・{{Simplified}}</span>
{{/Simplified}}

<span class=homograph>{{Homograph}}</span>

<div class=pinyin><br></div>
<div class=zhuyin><br></div>

<div class=meaning><br></div>
<div class=description><br></div>

<hr>

<div class="tradSen">{{SentenceTraditional}}</div>
{{#SentenceSimplified}}
<div class="simplSen">{{SentenceSimplified}}</div>
{{/SentenceSimplified}}

</span>
```

### back
```
<span class="back" lang="zh">

<div class=tradHanzi>{{Traditional}}</div>
{{#Simplified}}
<div class=simplHanzi>{{Simplified}}</div>
{{/Simplified}}

<span class=homograph>{{Homograph}}</span>
{{#Homophone}}
<span class=homophone>　・　{{Homophone}}</span>
{{/Homophone}}

<div class=pinyin>{{Pinyin.1}}</div>
<div class=zhuyin>{{Zhuyin}}</div>

<div class=meaning>{{hint:Meaning}}</div>
<div class=description>{{Part of speech}}</div>

<hr>

<div class=tradSen>{{SentenceTraditional}}</div>
{{#SentenceSimplified}}
<div class=simplSen>{{SentenceSimplified}}</div>
{{/SentenceSimplified}}

<div class=pinyinSen>{{SentencePinyin.1}}</div>
<div class="zhuyinSen">{{SentenceZhuyin}}</div>

<div class=meaningSent>{{hint:SentenceMeaning}}</div>

{{Audio}} {{SentenceAudio}}
<br>

<span class=image>{{SentenceImage}}</span>

</span>
```

## Only traditional
### Front
```
<span class="front" lang="zh">

<span class="tradHanzi">{{Traditional}}</span>

<span class=homograph>{{Homograph}}</span>

<div class=pinyin><br></div>
<div class=zhuyin><br></div>

<div class=meaning><br></div>
<div class=description><br></div>

<hr>

<div class="tradSen">{{SentenceTraditional}}</div>

</span>
```

### Back
```
<span class="back" lang="zh">

<div class=tradHanzi>{{Traditional}}</div>

<span class=homograph>{{Homograph}}</span>
{{#Homophone}}
<span class=homophone>　・　{{Homophone}}</span>
{{/Homophone}}

<div class=pinyin>{{Pinyin.1}}</div>
<div class=zhuyin>{{Zhuyin}}</div>

<div class=meaning>{{hint:Meaning}}</div>
<div class=description>{{Part of speech}}</div>

<hr>

<div class=tradSen>{{SentenceTraditional}}</div>

<div class=pinyinSen>{{SentencePinyin.1}}</div>
<div class="zhuyinSen">{{SentenceZhuyin}}</div>

<div class=meaningSent>{{hint:SentenceMeaning}}</div>

{{Audio}} {{SentenceAudio}}
<br>

<span class=image>{{SentenceImage}}</span>

</span>
```


## Only simplified
### front
```
<span class="front" lang="zh">

{{#Simplified}}
<span class="simplHanzi">{{Simplified}}</span>
{{/Simplified}}
{{^Simplified}}
<span class="simplHanzi">{{Traditional}}</span>
{{/Simplified}}

<span class=homograph>{{Homograph}}</span>

<div class=pinyin><br></div>
<div class=zhuyin><br></div>

<div class=meaning><br></div>
<div class=description><br></div>

<hr>

{{#SentenceSimplified}}
<div class="simplSen">{{SentenceSimplified}}</div>
{{/SentenceSimplified}}
{{^SentenceSimplified}}
<div class="simplSen">{{SentenceTraditional}}</div>
{{/SentenceSimplified}}

</span>
```

### Back
```
<span class="back" lang="zh">

{{#Simplified}}
<span class="simplHanzi">{{Simplified}}</span>
{{/Simplified}}
{{^Simplified}}
<span class="simplHanzi">{{Traditional}}</span>
{{/Simplified}}

<span class=homograph>{{Homograph}}</span>
{{#Homophone}}
<span class=homophone>　・　{{Homophone}}</span>
{{/Homophone}}

<div class=pinyin>{{Pinyin.1}}</div>
<div class=zhuyin>{{Zhuyin}}</div>

<div class=meaning>{{hint:Meaning}}</div>
<div class=description>{{Part of speech}}</div>

<hr>

{{#SentenceSimplified}}
<div class="simplSen">{{SentenceSimplified}}</div>
{{/SentenceSimplified}}
{{^SentenceSimplified}}
<div class="simplSen">{{SentenceTraditional}}</div>
{{/SentenceSimplified}}

<div class=pinyinSen>{{SentencePinyin.1}}</div>
<div class="zhuyinSen">{{SentenceZhuyin}}</div>

<div class=meaningSent>{{hint:SentenceMeaning}}</div>

{{Audio}} {{SentenceAudio}}
<br>

<span class=image>{{SentenceImage}}</span>

</span>

```

## CSS theme for all cards
```
.card {
	font-family: SimSun;
	font-size: 20px;
	text-align: left;
}

.tradHanzi, .simplHanzi {font-family: Kaiti;  font-size: 5rem;}

.homophone, .homograph {
	font-family: SimSun; 
	font-size: 1rem;
}
.homophone {color: green;}
.homograph {color: red;}

.tradSen, .simplSen {font-family: SimSun; font-size: 2.5rem; text-align:left}

.pinyin, .pinyinSen {font-family: Gentium Plus; font-size: 1rem; color: #bbb; }

.zhuyin, .zhuyinSen {font-family: SimSun; font-size: 1.6rem; color: #bbb;}

.meaning, .meaningSent {font-family: Georgia; font-size: 1rem;}

.description{
	font-family: Georgia;
	font-size: 16px;
	color: #ddd;
}

img {
	display: block;
	margin-left: auto; 
	margin-right: auto;
	max-width: 80%
}

```
