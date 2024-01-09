.text
.org 0x20

izvorna_koda: .asciz " \n\n stev1: .var 0xf123 @ komentar 1\n @prazna vrstica \n stev2: .var 15\nstev3: .var 128\n_start:\n mov r1, #5 @v r1 premakni 5\nmov r2, #1\nukaz3: add r1, #1\nb _start"
.align
izvorna_koda_pocisceno: .space 120
.align
tabela_oznak: .space 100

.align
.global _start
_start:
    adr r1, izvorna_koda_pocisceno
    adr r2, izvorna_koda
    mov r4, #0 @ zacnemo z vrednost 0, te ne bomo zapisali v nov niz
               @ tukaj bo tudi prej vpisani znak, da bomo z njim primerjali -> ni " " ali "\n" za "\n" ali " "

zanka: 
    ldrb r3, [r2]

    cmp r3, #0  @ Ali je konec niza -> gremo na prekopiranje v originalen niz
    beq konec

    cmp r3, #10 @ primerjamo z naslednjo vrstico 
        bne ni_nasl_vrstica

        cmp r4, #0 @ ali smo sploh kaj ze zapisali???
            beq premik @ ce nismo, ne bomo zaceli z "\n"
        cmp r3, r4 @ -> ali je prej "\n" ????
            beq premik @ ce je, ne bomo pisali ampak se le premaknimo 

ni_nasl_vrstica:
    cmp r3, #32 @ primerjamo s presledkom 
        bne ni_presledek

        cmp r4, #0 @ ali se nismo pisali
            beq premik
        cmp r4, #10 @ -> ali je prejsnji "\n"
            beq premik
        cmp r3, r4 @ -> ali je prejsnji tudi presledek
            beq premik

ni_presledek: 

    cmp r3, #64 @ primerjamo za komentar -> v zanko ki isce "\n" Nic ne pisemo do takrat v niz
        bne pisemo
		cmp r4, #10 @ prejšnji "\n"
			subeq r1, r1, #1
		cmp r4, #32 @ prejšnji " " 
			subeq r1, r1, #1
		b isci_konec_vrstice 
    

pisemo:
    mov r4, r3 @ vrednost damo v "prejsnjega"
    strb r4, [r1], #1 @ zapisemo na pomnilnik, in se premaknemo za 1

premik:
    add r2, r2, #1 @ premaknimo se za en bajt
    b zanka

isci_konec_vrstice:
    ldrb r3, [r2]
    cmp r3, #10           @ ali je konec vrstice
        beq pisemo        @ zapisimo konec vrstice
    add r2, r2, #1        @ premaknimo se po nizu
    b isci_konec_vrstice  @ ponovi zanko

konec: 
	strb r3, [r2] @ na koncu damo 0

    adr r1, izvorna_koda_pocisceno
    adr r2, izvorna_koda
druga_zanka:
    ldrb r3, [r1]
    cmp r3, #0
		strb r3, [r2]
        beq drugi_konec
    strb r3, [r2]
    add r2, r2, #1
    add r1, r1, #1
    b druga_zanka
drugi_konec:


_end: b _end
