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

@#######################################################
    adr r1, izvorna_koda_pocisceno
    adr r2, izvorna_koda
druga_zanka:
    ldrb r3, [r1] @ kar bomo prepisali
    ldrb r4, [r1, #1] @ naslednji znak 

    cmp r3, #0
        streqb r3, [r2]
        beq drugi_konec
    
    cmp r3, #':' @ zapisujemo :
        cmpeq r4, #10 @ naslednji je "\n"
            bne else
            strb r3, [r2]
			mov r3, #32
			strb r3, [r2, #1]
            add r1, r1, #2 @ Preskočimo "\n"
            add r2, r2, #2 @ gremo na naslednji znak
            b druga_zanka
else:
    strb r3, [r2]
    add r2, r2, #1
    add r1, r1, #1
    b druga_zanka
drugi_konec:

@#######################################################
    adr r1, izvorna_koda
    adr r3, tabela_oznak
    mov r4, #0

tretja_zanka:
    ldrb r2, [r1]
    cmp r2, #0 
        beq _end

    cmp r2, #':'
        beq nasli_oznako
    
    cmp r2, #10
        addeq r4, r4, #1

    add r1, r1, #1
    b tretja_zanka
    
nasli_oznako:
        ldrb r2, [r1]
        cmp r2, #10 @ find if "\n"
            addeq r1, r1, #1
            beq do_konca_oznake
        cmpne r1, #0x20 @ ali je prišel do origin
            beq do_konca_oznake

        sub r1, r1, #1
        b nasli_oznako
    do_konca_oznake:
        ldrb r2, [r1]
        cmp r2, #':'
            moveq r2, #0
            streqb r2, [r3] @ asciz 0 na koncu niza
            addeq r3, r3, #1 @ premaknimo na nasl naslov
            beq konec_oznake
        strb r2, [r3]
        add r1, r1, #1
		add r3, r3, #1
        b do_konca_oznake

    konec_oznake:
        @ r3 je naslov v pomnilniku kjer se je zdaj končal niz
        tst r3, #1 
        bne liho
        strh r4, [r3]
        add r3, r3, #2
		add r1, r1, #1
        b tretja_zanka
    liho: 
        strb r2, [r3]
        add r3, r3, #1
        b konec_oznake
_end: b _end
