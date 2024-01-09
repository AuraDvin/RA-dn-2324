# Dokumentacija domače naloge: 
## Prvi korak
Začnemo z iteracijo skozi `izvorna_koda`, dokler ne pridemo do `0`. Pri tem kopiramo znake v `izvorna_koda_pocisceno`. 
Predenj prekopiramo znak preverimo če smo prej zapisali znak `LF` (nova vrstica) ali presledek ("` `") in če je trenuten znak afna ("`@`"). 
Če gre za **novo vrstico ali presledek**, <i> nismo pa še nič vpisali </i>, preskočimo trenuten znak. 
Če je trenuten znak `@`, preskočimo vse do znaka `LF`, saj gre za komentar.

## Drugi korak
V drugem koraku iteriramo skozi `izvorna_koda_pocisceno` in prepisujemo nazaj v `izvorna_koda`. 
Tu preverjamo če sta sosednja znaka presledek in nova vrstica, 2 novi vrstici, ali dvopičje ("`:`") in nova vrstica. 
Če je kateri izmed pogojov izpolnjenih, zapišemo različne znake <br>
&nbsp;&nbsp;&nbsp;&nbsp;- namesto "` \n`" zapišemo <b> le </b> "`\n`" na <b> mestu presledka </b>, <br>
&nbsp;&nbsp;&nbsp;&nbsp;- namesto "`\n\n`" zapišemo en "`\n`", drugega pa <b> preskočimo </b> <br>
&nbsp;&nbsp;&nbsp;&nbsp;- namesto "`:\n`" Zapišemo "`:`", nato presledek in znak "`\n`" preskočimo <br>
 na koncu še zapišemo znak `0`, ki ponazarja <i> konec niza </i>.

## Tretji korak
V tretjem koraku _zopet iteriramo_ skozi `izvorna_koda`, sedaj _štejemo_ koliko "`\n`" srečamo, 
nato ko **zaznamo dvopičje** gremo nazaj _na začetek labele_ in začnemo **prepisovati na tabelo oznak**.
Ko zopet pridemo do dvopičja, preverimo za poravnanost v spominu in zapišemo koliko LF znakov smo opazili do sedaj. <br>
&nbsp;&nbsp;&nbsp;&nbsp;**Potem ne pozabimo preskočiti dvopičje** in iskanje **nadaljujemo**. 

Tako imamo urejeno spremenljivko `izvorna_koda` in tabelo oznak `tabela_oznak`. <br>

Da je koda bolj berljiva uporabljamo skoke na labele zapisane v slovenščini. 
