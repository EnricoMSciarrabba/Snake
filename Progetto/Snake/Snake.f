HEX

\-------------------
\    VARIABILI
\-------------------

: JF-CREATE CREATE ;
: JF-WORD WORD ;
: CREATE JF-WORD JF-CREATE DOCREATE , ;

\ Contiene l'indirizzo del registro del pixel di 
\ partenza in una stampa
VARIABLE PIXEL
: GPIXEL PIXEL @ ;								\ (    -- b1 )
: SPIXEL PIXEL ! ;								\ ( a1 --    )
: INC_PIXEL_O  4    * GPIXEL + SPIXEL ;			\ ( a1 --    )
: INC_PIXEL_V  1000 * GPIXEL + SPIXEL ;			\ ( a1 --    )

\ Contiene il valore rgb del colore
\ scelto per la stampa
VARIABLE COLOR
: GCOLOR COLOR @ ;								\ (    -- b1 )
: SCOLOR COLOR ! ;							 	\ ( a1 --    )

\ Contiene la dimensione di un pixel
VARIABLE PIXEL_SIZE
: GPIXEL_SIZE PIXEL_SIZE @ ;					\ (    -- b1 )
: SPIXEL_SIZE PIXEL_SIZE ! ;					\ ( a1 --    )

\ Contiene la dimensione di un carattere
VARIABLE CHAR_SIZE
: GCHAR_SIZE CHAR_SIZE @ ;						\ (    -- b1 )
: SCHAR_SIZE CHAR_SIZE ! ;						\ ( a1 --    )

\ Contiene la codifica della prima
\ parte di una lettera
VARIABLE CHAR1
: GCHAR1 CHAR1 @ ;								\ (    -- b1 )
: SCHAR1 CHAR1 ! ;								\ ( a1 --    )

\ Contiene la codifica della seconda
\ parte di una lettera
VARIABLE CHAR2
: GCHAR2 CHAR2 @ ;								\ (    -- b1 )
: SCHAR2 CHAR2 ! ;								\ ( a1 --    )

\ Variabile temporanea usata
\ dal metodo PRINT_NUMBER
VARIABLE NUM_TEMP
: GNUM_TEMP NUM_TEMP @ ;						\ (    -- b1 )
: SNUM_TEMP NUM_TEMP ! ;						\ ( a1 --    )



\-----------------
\      METODI
\-----------------

\ Subroutine in assembly per stampare a
\ schermo un rettangolo
CREATE PRINT_PIXEL_ASSEMBLY
e92d5000 , e59f0060 , e5900000 , e59f105c , e5911000 ,
e1a02001 , e59f3054 , e0011003 , e59f3050 , e0022003 ,
e1a02622 , e59f3048 , e5933000 , eb000001 , e8bd5000 ,
e12fff1e , e1a04002 , e1a02004 , e4803004 , e2522001 ,
1afffffc , e1a02104 , e0500002 , e2800a01 , e2511001 ,
1afffff6 , e12fff1e , 0001e4e0 , 0001e5f0 , 00000fff ,
00fff000 , 0001e598 ,

\ Interfaccia Forth di PRINT_PIXEL_ASSEMBLY
: PRINT_PIXEL 1000 * + SPIXEL_SIZE PRINT_PIXEL_ASSEMBLY JSR DROP ;	\ ( a1 a2 -- )

\ Subroutine in assembly per stampare a
\ schermo un carattere
CREATE PRINT_CHAR_ASSEMBLY
e92d4010 , e59f0144 , e5900000 , e59f1140 , e5911000 , 
e59f213c , e5922000 , e59f3138 , e5933000 , e59f4134 , 
e5944000 , e1833404 , eb000001 , e8bd4010 , e12fff1e , 
e92d0030 , e92d00c0 , e92d4100 , e1a04000 , e1a05001 , 
e1a06002 , e3a07000 , e3c380ff , e1a08428 , e20330ff , 
e3a02020 , e1a00006 , e3a01001 , e0000001 , e3500000 , 
0a000005 , e1a00004 , e1a01003 , e92d000c , e1a03008 , 
eb00001b , e8bd000c , e0844103 , e2422001 , e1a060a6 , 
e0820007 , e3a01005 , eb000022 , e3500002 , 1a000005 , 
e3a01014 , e0000391 , e0444000 , e3a01a01 , e0000391 , 
e0844000 , e1a00002 , e3500000 , 1affffe3 , e3570002 , 
0a000003 , e3a07002 , e3a02008 , e1a06005 , eaffffdd , 
e8bd4100 , e8bd00c0 , e8bd0030 , e12fff1e , e92d1010 , 
e1a02001 , e1a04002 , e1a02004 , e4803004 , e2522001 , 	
1afffffc , e1a02104 , e0500002 , e2800a01 , e2511001 , 
1afffff6 , e8bd1010 , e12fff1e , e1500001 , ba000002 , 
e0400001 , e1500001 , aafffffc , e12fff1e , 0001e4e0 , 
0001e6b8 , 0001e710 , 0001e654 , 0001e598 , 

\ Interfaccia Forth di PRINT_PIXEL_ASSEMBLY
: PRINT_CHAR SCHAR2 SCHAR1 PRINT_CHAR_ASSEMBLY JSR DROP ;		\ ( a1 a2 -- )

\ Effettua l'elevazione a potenza
: EXP															\ ( a1 a2 -- b1 )
	DUP 0 =  IF  DROP DROP 1  ELSE
	DUP 1 =  IF  DROP 	      ELSE
		SWAP DUP ROT
		BEGIN
			1 -  ROT ROT SWAP DUP ROT * ROT
		DUP 1 =  UNTIL
		DROP SWAP DROP
	THEN THEN
;

\ Codifica il numero in input
: CODE_NUMBER													\ ( a1 -- b1 b2 b3 )
	DUP 0 =  IF  74 6318C62E  ELSE
	DUP 1 =  IF  F9 084210E4  ELSE
	DUP 2 =  IF  F8 4444462E  ELSE
	DUP 3 =  IF  74 6106422E  ELSE
	DUP 4 =  IF  42 3E952988  ELSE
	DUP 5 =  IF  7C 2107843F  ELSE
	DUP 6 =  IF  74 6317862E  ELSE
	DUP 7 =  IF  21 0844421F  ELSE
	DUP 8 =  IF  74 6317462E  ELSE
				 74 610F462E  
	THEN THEN THEN THEN THEN THEN THEN THEN THEN
;

\ Stampa il numero in input
: PRINT_NUMBER 													\ ( a1 -- )
	DUP SNUM_TEMP  -1 SWAP
	BEGIN
		SWAP 1 +  SWAP A /
	DUP 0 =  UNTIL
	DROP
	BEGIN
		DUP A SWAP EXP  GNUM_TEMP SWAP /
		CODE_NUMBER  PRINT_CHAR  GCHAR_SIZE 6 * INC_PIXEL_O
		SWAP DUP  A SWAP EXP  ROT * GNUM_TEMP SWAP - SNUM_TEMP  1 -
	DUP -1 =  UNTIL
	DROP
;

\ Stampa le lettere in input
: PRINT_WORD										\ ( a1 ... an an+1 -- )
	DUP 6 * GCHAR_SIZE * INC_PIXEL_O
	BEGIN
		GCHAR_SIZE -6 * INC_PIXEL_O
		ROT ROT PRINT_CHAR
		1 -
	DUP 0 =  UNTIL
	DROP
;


\-----------------
\   COLORI
\-----------------

00FFFFFF CONSTANT WHITE
00FFFFFE CONSTANT WHITE1
00FF0000 CONSTANT RED
00000000 CONSTANT BLACK


\-----------------
\   CARATTERI
\-----------------

\ ( -- b1 b2 )
: .A. 8C 7F18C62E ;			
: .B. 7C 6317C62F ;
: .C. F0 4210843E ;
: .D. 7C 6318C62F ;
: .E. F8 4217843F ;
: .F. 08 4217843F ;
: .G. 74 6316843E ;
: .H. 8C 631FC631 ;
: .I. 71 0842108E ;
: .J. 32 5084211C ;
: .K. 8C 63149D31 ;
: .L. F8 42108421 ;
: .M. 8C 631AD771 ;
: .N. 8C 639ACE31 ;
: .O. 74 6318C62E ;
: .P. 08 42F8C62F ;
: .Q. 20 CA94A526 ;
: .R. 8A 4AF8C62F ;
: .S. 74 6107062E ;
: .T. 21 0842109F ;
: .U. 74 6318C631 ;
: .V. 21 14A54631 ;
: .W. 55 6B5AC631 ;
: .X. 8A 94422951 ;
: .Y. 21 08452A31 ;
: .Z. F8 4222221F ;
: .0. 74 6318C62E ;
: .1. F9 084210E4 ;
: .2. F8 4444462E ;
: .3. 74 6106422E ;
: .4. 42 3E952988 ;
: .5. 7C 2107843F ;
: .6. 74 6317862E ;
: .7. 21 0844421F ;
: .8. 74 6317462E ;
: .9. 74 610F462E ;
: .DP. 0 40008000 ;
: .SPACE. 0 0 ;


\------------------------
\   RIFERIMENTI SCHERMO
\------------------------

3E8FA000 CONSTANT HL
3E8FAFFC CONSTANT HR
3EBF9000 CONSTANT LL
3EBF9FFC CONSTANT LR
3EAB9800 CONSTANT CENTER
HEX

\-------------------------
\   AUTOCONFIGURAZIONE
\------------------------

\ Autoconfigurazione base_register 
: AUTOCONFIG							\ (  -- b1 )
	3F003004 @
	5 DROP
	3F003004 @ =  IF
		FE000000		
	ELSE
		3F000000
	THEN
;
AUTOCONFIG CONSTANT BASE_REGISTER

\---------------
\   COSTANTI
\---------------

\ Legge il bit del pin 9 (output del ricevitore)
BASE_REGISTER 200034 +  CONSTANT GPLEV0
: INPUT GPLEV0 @ 400000 * 80000000 / ;			\ (    -- b1 )

\ Indirizzo del registro dove sono
\ memorizzati i microsendi passati dall'avvio della macchina
BASE_REGISTER 3004 +  CONSTANT CLO
: GCLOCK CLO @ ;								\ (    -- b1 )


\------------------
\   VARIABILI
\------------------

\ Primo punto di campionamento
VARIABLE SAMPLE_POINT1		
: GSAMPLE_POINT1 SAMPLE_POINT1 @ ;				\ (    -- b1 )
: SSAMPLE_POINT1 SAMPLE_POINT1 ! ;				\ ( a1 --    )

\ Secondo punto di campionamento
VARIABLE SAMPLE_POINT2		
: GSAMPLE_POINT2 SAMPLE_POINT2 @ ;				\ (    -- b1 )
: SSAMPLE_POINT2 SAMPLE_POINT2 ! ;				\ ( a1 --    )

\ Terzo punto di campionamento
VARIABLE SAMPLE_POINT3		
: GSAMPLE_POINT3 SAMPLE_POINT3 @ ;				\ (    -- b1 )
: SSAMPLE_POINT3 SAMPLE_POINT3 ! ;				\ ( a1 --    )

\ Contiene la codifica del pulsante 2 
VARIABLE P2		
: GP2 P2 @ ;									\ (    -- b1 )
: SP2 P2 ! ;									\ ( a1 --    )

\ Contiene la codifica del pulsante 4
VARIABLE P4		
: GP4 P4 @ ;									\ (    -- b1 )
: SP4 P4 ! ;									\ ( a1 --    )

\ Contiene la codifica del pulsante 6 
VARIABLE P6		
: GP6 P6 @ ;									\ (    -- b1 )
: SP6 P6 ! ;									\ ( a1 --    )

\ Contiene la codifica del pulsante 8 
VARIABLE P8		
: GP8 P8 @ ;									\ (    -- b1 )
: SP8 P8 ! ;									\ ( a1 --    )

\ Contiene la codifica del pulsante PLAY
VARIABLE PP		
: GPP PP @ ;									\ (    -- b1 )
: SPP PP ! ;									\ ( a1 --    )

\ Contiene lo stato del metodo
\ CONTROL_RECEIVER
VARIABLE STATE_RECEIVER		
: GSTATE_RECEIVER STATE_RECEIVER @ ;			\ (    -- b1 )
: SSTATE_RECEIVER STATE_RECEIVER ! ;			\ ( a1 --    )

\ Variabile temporanea usata in CONTROL_RECEIVER
VARIABLE TIMESAMPLE
: GTIMESAMPLE TIMESAMPLE @ ;					\ (    -- b1 )
: STIMESAMPLE TIMESAMPLE ! ;					\ ( a1 --    )

\ Contiene il valore campionato
VARIABLE SAMPLE
: GSAMPLE SAMPLE @ ;							\ (    -- b1 )
: SSAMPLE SAMPLE ! ;							\ ( a1 --    )



\-----------------
\      METODI
\-----------------

\ Caricano sullo stack i valori di campionamento
\ personali
: ENRICO    							\ (     -- b1 b2 b3 b4 b5 b6 b7 b8 )
	A410  A85C  B0F4  
	0 3 4 2 5	
;			

: GIULIANO  							\ (     -- b1 b2 b3 b4 b5 b6 b7 b8 )
	B284  BB99  BFFE 
	1 6 2 0 5 
;					

\ Imposta i punti di campionamento e le 
\ codifiche dei campioni
: SET_RECEIVER 							\ ( a1 a2 a3 a4 a5 a6 a7 a8 --     )
	SP8  SP6  SPP  SP4  SP2
	SSAMPLE_POINT3
	SSAMPLE_POINT2
	SSAMPLE_POINT1
;

\ Decodifica i bit ricevuti
: DECODE 								\ ( a1 a2 a3 --  b1 )
	SWAP 2 * +
	SWAP 4 * +
	DUP GP2 =  IF  2  ELSE 
	DUP GP4 =  IF  4  ELSE 
	DUP GPP =  IF  5  ELSE 
	DUP GP6 =  IF  6  ELSE 
	DUP GP8 =  IF  8  ELSE 
				  -1 
	THEN THEN THEN THEN THEN 
	SWAP DROP
;

\ Secondo metodo che permette la ricezione
\ di un valore tramite infrarossi
: CONTROL_RECEIVER1												\ (    --    )
	GSTATE_RECEIVER 
	DUP   0 =  IF
		INPUT  0 =  IF  1 SSTATE_RECEIVER  THEN
	ELSE
		DUP 2 =  IF
			GCLOCK GTIMESAMPLE - GSAMPLE_POINT1 1388 - >  IF
				BEGIN  GCLOCK GTIMESAMPLE - GSAMPLE_POINT1 >  UNTIL  INPUT
				BEGIN  GCLOCK GTIMESAMPLE - GSAMPLE_POINT2 >  UNTIL  INPUT
				BEGIN  GCLOCK GTIMESAMPLE - GSAMPLE_POINT3 >  UNTIL  INPUT

				DECODE SSAMPLE 3 SSTATE_RECEIVER  GCLOCK STIMESAMPLE
			THEN
		ELSE
			DUP 1 =  IF
				BEGIN  INPUT  1 =  UNTIL
				GCLOCK STIMESAMPLE  2 SSTATE_RECEIVER
			ELSE
				GCLOCK GTIMESAMPLE - 13880 >  IF  0 SSTATE_RECEIVER  THEN 
	THEN THEN THEN
	DROP
;

\ Interfaccia che sfrutta CONTROL_RECEIVER1 
\ e blocca il flusso di esecuzione
: CONTROL_RECEIVER2								\ (  --  )
	1 SSTATE_RECEIVER
	BEGIN  INPUT 0 =  UNTIL
	BEGIN
		CONTROL_RECEIVER1 
	GSTATE_RECEIVER 0 =  UNTIL
;



\-----------------------
\        EXTRA
\-----------------------

\ Variabile temporanea usata in RECEIVE_BITS
VARIABLE TIME
: GTIME TIME @ ;								\ (    -- b1 )
: STIME TIME ! ;								\ ( a1 --    )

\ Contatore utilizzato in SAMPLES
VARIABLE COUNT
: GCOUNT COUNT @ ;								\ (    -- b1 )
: SCOUNT COUNT ! ;								\ ( a1 --    )
: INC_COUNT GCOUNT 1 + SCOUNT ;					\ (    --    )

\ Contiene il range selezionato
\ per il campionamento
VARIABLE RANGE
: GRANGE RANGE @ ;								\ (    -- b1 )
: SRANGE RANGE ! ;								\ ( a1 --    )

\ Campiona i bit del range selezionato
: SAMPLES 										\ (    --    )
    0 SCOUNT 
	0 SSAMPLE 
	BEGIN  INPUT 1 <>  UNTIL
	GCLOCK STIME  2710 GRANGE * 
	BEGIN  DUP  GCLOCK GTIME -  <  UNTIL 
	DROP 

    BEGIN 
        INPUT 
        DUP GSAMPLE <>  IF  
            DUP SSAMPLE  INC_COUNT  GCLOCK GTIME -
        ELSE
            DROP
        THEN 
    GCLOCK GTIME - 2710 GRANGE 1 + * >  UNTIL 

    GCOUNT 2 * SCOUNT 
    BEGIN  
        DECIMAL . HEX
        GCOUNT 2 MOD 1 =  IF  CR  THEN 
        GCOUNT 0 <>  IF  GCOUNT  1 - SCOUNT  THEN
    GCOUNT 0 = UNTIL 
;
HEX

\-------------------------
\   AUTOCONFIGURAZIONE
\------------------------

\ Autoconfigurazione base_register 
: AUTOCONFIG										\ (  -- b1 )
	3F003004 @
	5 DROP
	3F003004 @ =  IF
		FE000000		
	ELSE
		3F000000
	THEN
;
AUTOCONFIG CONSTANT BASE_REGISTER

\------------------
\   COSTANTI
\------------------

\ Indirizzo del registro dove sono
\ memorizzati i microsendi passati dall'avvio della macchina
BASE_REGISTER 3004 +  CONSTANT CLO
: GCLOCK CLO @ ;									\ (    -- b1 )


\--------------------
\	VARIABILI
\--------------------

\ Contiene il valore rgb del colore
\ scelto per il timer
VARIABLE TIMER_COLOR
: GTIMER_COLOR TIMER_COLOR @ ;						\ (    -- b1 )
: STIMER_COLOR TIMER_COLOR ! ;						\ ( a1 --    )

\ Contiene l'indirizzo del pixel di 
\ partenza in cui stampare il timer
VARIABLE TIMER_PIXEL
: GTIMER_PIXEL TIMER_PIXEL @ ;						\ (    -- b1 )
: STIMER_PIXEL TIMER_PIXEL ! ;						\ ( a1 --    )

\ Contiene la dimensione del timer
VARIABLE TIMER_SIZE
: GTIMER_SIZE TIMER_SIZE @ ;						\ (    -- b1 )
: STIMER_SIZE TIMER_SIZE ! ;						\ ( a1 --    )

\ Contiene i decimi di secondo passati
\ dall'avvio della macchina
VARIABLE TIMER
: GTIMER TIMER @ ;									\ (    -- b1 )
: STIMER TIMER ! ;									\ ( a1 --    )
: SAVE_TIMER GCLOCK 186A0 / STIMER ;				\ (    --    )

\ Contiene i minuti
VARIABLE MINUTES
: GMINUTES MINUTES @ ;								\ (    -- b1 )
: SET_MINUTES 0 MINUTES ! ;							\ (    --    )
: UPDATE_MINUTES 									\ (    --    )
	GMINUTES 1 +  DUP MINUTES ! 
	GTIMER_PIXEL SPIXEL  
	BLACK SCOLOR 
	GCHAR_SIZE 8 *  GCHAR_SIZE C *  PRINT_PIXEL
	GTIMER_COLOR SCOLOR
	DUP  A /  0 =  IF  0 PRINT_NUMBER  THEN
	PRINT_NUMBER
;

\ Contiene i secondi
VARIABLE SECONDS
: GSECONDS SECONDS @ ;								\ (    -- b1 )
: SET_SECONDS 0 SECONDS ! ;							\ (    --    )
: UPDATE_SECONDS 									\ (    --    )
	GSECONDS 1 + 
	DUP 3C =  IF  
		SET_SECONDS  
		UPDATE_MINUTES  
		DROP GSECONDS
	ELSE 
		DUP SECONDS ! 
	THEN 

	GTIMER_PIXEL SPIXEL
	E GCHAR_SIZE * INC_PIXEL_O  
	BLACK SCOLOR
	GCHAR_SIZE 8 *  GCHAR_SIZE C *  PRINT_PIXEL
	GTIMER_COLOR SCOLOR
	DUP  A / 0 =  IF  0 PRINT_NUMBER  THEN
	PRINT_NUMBER
;

\ Contiene i decimi di secondo
VARIABLE DECSECONDS
: GDECSECONDS DECSECONDS @ ;						\ (    -- b1 )
: SET_DECSECONDS 0 DECSECONDS ! ;					\ (    --    )
: UPDATE_DECSECONDS 								\ (    --    )
	GDECSECONDS 1 + 
	DUP A =  IF  
		SET_DECSECONDS 
		UPDATE_SECONDS  
		DROP GDECSECONDS
	ELSE 
		DUP DECSECONDS ! 
	THEN 

	GTIMER_PIXEL SPIXEL
	1C GTIMER_SIZE * INC_PIXEL_O  
	BLACK SCOLOR 
	GCHAR_SIZE 8 *  GCHAR_SIZE 5 *  PRINT_PIXEL
	GTIMER_COLOR SCOLOR
	PRINT_NUMBER
;

\--------------------
\       METODI
\--------------------

\ Inizializza il timer e lo stampa 
: SET_TIMER												\ (    --    )
	SET_MINUTES
	SET_SECONDS
	SET_DECSECONDS
	GTIMER_COLOR  SCOLOR
	GTIMER_PIXEL  SPIXEL 
	GTIMER_SIZE   SCHAR_SIZE
	GMINUTES	 DUP PRINT_NUMBER PRINT_NUMBER  .DP. PRINT_CHAR  GCHAR_SIZE 2 * INC_PIXEL_O
	GSECONDS 	 DUP PRINT_NUMBER PRINT_NUMBER  .DP. PRINT_CHAR  GCHAR_SIZE 2 * INC_PIXEL_O
	GDECSECONDS      PRINT_NUMBER 
;

\ Controlla se è il momento di 
\ aggiornare il timer
: CONTROL_TIMER									\ (    --    )
	GCLOCK 186A0 /
	DUP GTIMER <>  IF
		STIMER
		GTIMER_COLOR SCOLOR
		GTIMER_SIZE SCHAR_SIZE
		UPDATE_DECSECONDS
	ELSE
		DROP
	THEN
;
\------------------------
\   RIFERIMENTI SCHERMO
\------------------------

3E97E010 CONSTANT BHL
3E97EFEC CONSTANT BHR
3EBF5010 CONSTANT BLL
3EBF5FEC CONSTANT BLR


\-------------------
\    VARIABILI
\-------------------

\ Contiene l'indirizzo del pixel in cui
\ si trova la testa in ongi istante
VARIABLE  HEAD
: GHEAD   HEAD @ ;                                      \ (    -- b1 )
: SHEAD   HEAD ! ;                                      \ ( a1 --    )

\ Contiene l'indirizzo del pixel in cui
\ si trova la coda in ongi istante
VARIABLE  TAIL
: GTAIL   TAIL @ ;                                      \ (    -- b1 )
: STAIL   TAIL ! ;                                      \ ( a1 --    )

\ Contiene lo stato del serpente
\ 0 -> vivo ,  1 -> morto
VARIABLE DEAD
: GDEAD   DEAD @ ;                                      \ (    -- b1 )
: SDEAD   DEAD ! ;                                      \ ( a1 --    )

\ Contiene le direzioni di testa e coda
VARIABLE SNAKE_DIR
: GSNAKE_DIR   SNAKE_DIR @ ;                            \ (    -- b1 )
: SSNAKE_DIR   SNAKE_DIR ! ;                            \ ( a1 --    )

\ Consentono di accedere in maniera diretta 
\ ai bit memorizzati nella variabile SNAKE_DIR
: GHEAD_DIR   GSNAKE_DIR 3 AND ;                        \ (    -- b1 )
: GTAIL_DIR   GSNAKE_DIR C AND 4 / ;                    \ (    -- b1 )
: SHEAD_DIR   GSNAKE_DIR C AND +  SSNAKE_DIR ;          \ ( a1 --    )
: STAIL_DIR   4 * GSNAKE_DIR 3 AND +  SSNAKE_DIR ;      \ ( a1 --    )


\ Contiene il punteggio
VARIABLE SCORE
: GSCORE   SCORE @ ;                                            \ (  -- b1 )
: SET_SCORE   0 SCORE ! ;                                       \ (  --    )
: UPDATE_SCORE                                                  \ (  --    )
	3E9142A8 SPIXEL  BLACK SCOLOR  GSCORE DUP PRINT_NUMBER
	3E9142A8 SPIXEL  WHITE SCOLOR  1 +    DUP PRINT_NUMBER
	SCORE !
;

\ Contiene l'indirizzo del pixel in cui si trova la mela 
VARIABLE APPLE                                  
: GAPPLE  APPLE @ ;                                 \ (    -- b1 )
: SAPPLE  APPLE ! ;                                 \ ( a1 --    )

\ Contiene lo stato di CHECK_APPLE
VARIABLE STATE_APPLE                                  
: GSTATE_APPLE  STATE_APPLE @ ;                     \ (    -- b1 )
: SSTATE_APPLE  STATE_APPLE ! ;                     \ ( a1 --    )


\---------------
\    METODI 
\---------------

\ Incrementa orizzontalmente un indirizzo
\ del numero di pixel passati in input
: INC_O                                             \ ( a1 a2 -- b1 )
    4 * + 
    DUP   FFFFF000 AND   
    SWAP  00000FFF AND 
    DUP  FEC >  IF  FE0 -  ELSE 
    DUP  010 <  IF  FE0 +  THEN THEN + 
;

\ Incrementa verticalmente un indirizzo
\ del numero di pixel passati in input
: INC_V                                             \ ( a1 a2 -- b1 )
    1000 * +  
    DUP   FF000FFF AND
    SWAP  00FFF000 AND 
    DUP   BF5000 >  IF  278000 - ELSE
    DUP   97E000 <  IF  278000 + THEN THEN + 
;  

\ Controlla il colore dei pixel di fronte al serpente 
: CHECK_FORWARD                                                             \ (  -- b1 )
	GHEAD  GHEAD_DIR   
	DUP  0 =  IF  DROP  4 INC_O  DUP  -3 INC_V @  SWAP  3 INC_V @  ELSE 
	DUP  1 =  IF  DROP  4 INC_V  DUP  -3 INC_O @  SWAP  3 INC_O @  ELSE
	DUP  2 =  IF  DROP -4 INC_O  DUP  -3 INC_V @  SWAP  3 INC_V @  ELSE 
	              DROP -4 INC_V  DUP  -3 INC_O @  SWAP  3 INC_O @   
	THEN  THEN  THEN 
    GCOLOR =  SWAP  GCOLOR =  OR
;


\------------
\    MELA
\------------

\ Stampa la mela 7x7 in un punto casuale libero dello schermo
: PRINT_APPLE                                                               \ (  -- b1 )
    GCLOCK       
    BEGIN                                                 
		GHEAD GCLOCK DUP INC_O -1 * INC_V  BLR BHL -  MOD  BHL +  DUP SAPPLE
		DUP @                   BLACK <>                  IF  0  ELSE
		DUP 1C   + @            BLACK <>                  IF  0  ELSE
		DUP 7000 + DUP @        BLACK <>  SWAP BLR >  OR  IF  0  ELSE
		DUP 1C +  7000 + DUP @  BLACK <>  SWAP BLR >  OR  IF  0  ELSE
		                                                     -1  
        THEN  THEN  THEN  THEN
    NIP DUP ROT  GCLOCK SWAP -  2BC >  OR  UNTIL

 	IF GAPPLE SPIXEL  RED SCOLOR  7 7 PRINT_PIXEL  0  ELSE  1  THEN
;

\ Incrementa la lunghezza del serpente e cancella
\ la mela appena mangiata
: EAT   GTAIL GTAIL_DIR                                                     \ (  --  ) 
    DUP  0 =  IF  DROP -7 INC_O DUP  -3 INC_O -3 INC_V SPIXEL  ELSE
    DUP  1 =  IF  DROP -7 INC_V DUP  -3 INC_V -3 INC_O SPIXEL  ELSE
    DUP  2 =  IF  DROP  7 INC_O DUP  -4 INC_O -3 INC_V SPIXEL  ELSE
                  DROP  7 INC_V DUP  -4 INC_V -3 INC_O SPIXEL   
    THEN THEN THEN 
    STAIL
    WHITE1 SCOLOR  7 7 PRINT_PIXEL

    GAPPLE SPIXEL  BLACK SCOLOR  7 7 PRINT_PIXEL   
;

\ In base al suo stato consente al serpente di
\ mangiare la mela e incrementare il punteggio
\ o stampa una nuova mela   
: CHECK_APPLE                                           \ (  --  )
    GSTATE_APPLE  0 = IF
        RED SCOLOR  CHECK_FORWARD  IF 
            EAT  UPDATE_SCORE  1 SSTATE_APPLE  
        THEN
    ELSE
        PRINT_APPLE  SSTATE_APPLE
    THEN
;

\-------------------
\     SERPENTE
\-------------------

\ Stampa il serpente sullo schermo
: PRINT_SNAKE                                           \ (  --  )
	WHITE1 SCOLOR  
	3EAB9670 SPIXEL  7 C8 PRINT_PIXEL 
	3EABC980 SHEAD
	3EABC67C STAIL
	0 SDEAD
	0 SSNAKE_DIR
    0 SSTATE_APPLE
;

\ Controlla se il serpente ha sbattuto su se stesso
: CHECK_DEAD   WHITE1 SCOLOR  CHECK_FORWARD  IF  1 SDEAD  THEN ;        \ (  --  )

\ Muove la testa o la coda del serpente stampando 
\ delle righe o colonne bianche o nere
: MOVE                                                                  \ ( a1 a2 a3 a4 --   )
    0 = IF  SHEAD  ELSE  STAIL  THEN
    SWAP
    DUP  0 =  SWAP  2 =  OR  IF  
        -4 INC_V  7
        BEGIN
            SWAP 1 INC_V DUP GCOLOR SWAP ! 
            SWAP 1 - DUP
        0 =  UNTIL  DROP DROP  
    ELSE  
        -4 INC_O  7
        BEGIN
            SWAP 1 INC_O DUP GCOLOR SWAP ! 
            SWAP 1 - DUP
        0 =  UNTIL  DROP DROP  
    THEN 
;

\ Lascia sullo stack tutti i dati necessari a MOVE per
\ muovere la testa e stampare una riga o colonna bianca
: HEAD                                                                  \ (  -- b1 b2 b3 b4 )
    GHEAD GHEAD_DIR
    DUP 0 =  IF  SWAP  1 INC_O  DUP  3 INC_O   ELSE
    DUP 1 =  IF  SWAP  1 INC_V  DUP  3 INC_V   ELSE
    DUP 2 =  IF  SWAP -1 INC_O  DUP -3 INC_O   ELSE
                 SWAP -1 INC_V  DUP -3 INC_V    
    THEN THEN THEN  

    WHITE1 SCOLOR  SWAP  0
;

\ Lascia sullo stack tutti i dati necessari a MOVE per
\ muovere la coda e stampare una riga o colonna nera
: TAIL                                                                  \ (  -- b1 b2 b3 b4 )                  
    0
    GTAIL  4 INC_O @  WHITE1 =  IF  1 +  0 SWAP  THEN 
    GTAIL  4 INC_V @  WHITE1 =  IF  1 +  1 SWAP  THEN
    GTAIL -4 INC_O @  WHITE1 =  IF  1 +  2 SWAP  THEN
    GTAIL -4 INC_V @  WHITE1 =  IF  1 +  3 SWAP  THEN
    
    2 =  IF  2DROP  GTAIL_DIR  THEN 

    GTAIL SWAP 
    DUP 0 = IF  SWAP  DUP -3 INC_O  SWAP  1 INC_O  ELSE
    DUP 1 = IF  SWAP  DUP -3 INC_V  SWAP  1 INC_V  ELSE
    DUP 2 = IF  SWAP  DUP  3 INC_O  SWAP -1 INC_O  ELSE
                SWAP  DUP  3 INC_V  SWAP -1 INC_V  
    THEN  THEN  THEN 

    ROT DUP STAIL_DIR  ROT ROT  BLACK SCOLOR  1
;


\ Controlla il valore contenuto nella variabile SAMPLE 
\ e in base a questo modifica la direzione del serpente
: CONTROL_DIRECTION                                                         \ (  --  )
    GHEAD_DIR  GSAMPLE
    DUP 2 = IF  DROP DUP  0 =  SWAP  2 =  OR IF  3 SHEAD_DIR  THEN  ELSE
    DUP 4 = IF  DROP DUP  1 =  SWAP  3 =  OR IF  2 SHEAD_DIR  THEN  ELSE
    DUP 6 = IF  DROP DUP  1 =  SWAP  3 =  OR IF  0 SHEAD_DIR  THEN  ELSE
    DUP 8 = IF  DROP DUP  0 =  SWAP  2 =  OR IF  1 SHEAD_DIR  THEN  ELSE
                2DROP
    THEN THEN THEN THEN
;

\ Svolge tutti i controlli necessari 
\ e muove il serpente
: CONTROL_SNAKE                                     \ (  --  )                          
    CONTROL_DIRECTION
    CHECK_APPLE
    CHECK_DEAD
    HEAD MOVE
    TAIL MOVE
;
\-------------------
\    	METODI
\-------------------

\ Colora tutti i pixel dello scermo di nero
: CLEAR														\ (    --    )
    HL SPIXEL  BLACK SCOLOR  300 400 PRINT_PIXEL
;

\ Crea un borso di spessore 4 intorno allo schermo
: BORDER													\ (    --    )
	HL SPIXEL  				   4   400  PRINT_PIXEL
	HL SPIXEL  				   300 4    PRINT_PIXEL
	HR SPIXEL -3 INC_PIXEL_O   300 4    PRINT_PIXEL
	LL SPIXEL -3 INC_PIXEL_V   4   400  PRINT_PIXEL 
;

\ Crea un contorno al pulsante PLAY
: SEL_PLAY													\ (    --    )
	3EAF8674 SPIXEL  2  C0 PRINT_PIXEL
	3EAF8674 SPIXEL  59 2  PRINT_PIXEL
	3EB4F67C SPIXEL  2  C0 PRINT_PIXEL
	3EAF8974 SPIXEL  59 2  PRINT_PIXEL
;

\ Crea un contorno al pulsante EXIT
: SEL_EXIT													\ (    --    )
	3EB62674 SPIXEL  2  C0 PRINT_PIXEL
	3EB62674 SPIXEL  59 2  PRINT_PIXEL
	3EBB967C SPIXEL  2  C0 PRINT_PIXEL
	3EB62974 SPIXEL  59 2  PRINT_PIXEL
;


\ Stampa pulsanti PLAY ed EXIT
: PRINT_BUTTONS												\ (    --    )
	6 SCHAR_SIZE
	3EB0C6EC SPIXEL  .P. .L. .A. .Y. 4 PRINT_WORD
	3EB766EC SPIXEL  .E. .X. .I. .T. 4 PRINT_WORD
	SEL_PLAY
;

\ Permette la selezione del pulsante PLAY o EXIT
: CONTROL_BUTTONS											\ (    --    )
	0
	BEGIN
		CONTROL_RECEIVER2  GSAMPLE
		DUP 2 =  IF
			SWAP DUP  1 =  IF
				1 - BLACK SCOLOR  SEL_EXIT
					WHITE SCOLOR  SEL_PLAY
			THEN
			SWAP
		ELSE
			DUP 8 =  IF
				SWAP DUP  0 =  IF
					1 + BLACK SCOLOR  SEL_PLAY
						WHITE SCOLOR  SEL_EXIT
				THEN
				SWAP
			THEN
		THEN
		GCLOCK STIME
		BEGIN  13880 GCLOCK GTIME - <  UNTIL
	5 = UNTIL
;

\ Inizializazione di SELECTION
: INITIALIZE_SELECTION										\ (    --    )
    CLEAR   WHITE SCOLOR   BORDER
    18 SCHAR_SIZE  3E9B6290 SPIXEL
	.S. .N. .A. .K. .E. 5 PRINT_WORD
	PRINT_BUTTONS 
;

\ Inizializzazione di PLAY								\ (    --    )
: INITIALIZE_PLAY
    CLEAR   WHITE SCOLOR   BORDER

	3E97A000 SPIXEL  4 400 PRINT_PIXEL
	
	4 SCHAR_SIZE
	3E914068 SPIXEL  .S. .C. .O. .R. .E. .DP.  6 PRINT_WORD
	3E9142A8 SPIXEL   SET_SCORE   0 PRINT_NUMBER

    3E946068 SPIXEL  .T. .I. .M. .E. .DP. 5 PRINT_WORD  
	3E946248 STIMER_PIXEL
	WHITE STIMER_COLOR   4 STIMER_SIZE   SET_TIMER

    PRINT_SNAKE  PRINT_APPLE  DROP

	0 SSTATE_RECEIVER
	BEGIN  CONTROL_RECEIVER2  GSAMPLE 5 =  UNTIL
    6 SSAMPLE
	SAVE_TIMER
;

\ Blocca il flusso di esecuzione e attende il comando
\ per ricominciare 
: PAUSE_INTERFACE											\ (    --    )
	3E9145E0 SPIXEL  WHITE SCOLOR  A SCHAR_SIZE
	.P. .A. .U. .S. .E. 5 PRINT_WORD

	BEGIN  CONTROL_RECEIVER2 GSAMPLE 5 =  UNTIL

	3E9145E0 SPIXEL  BLACK SCOLOR
	.P. .A. .U. .S. .E. 5 PRINT_WORD
	
	GHEAD_DIR
	DUP 0 =  IF 6 SSAMPLE  ELSE
	DUP 1 =  IF 8 SSAMPLE  ELSE
	DUP 2 =  IF 4 SSAMPLE  ELSE
				2 SSAMPLE
	THEN THEN THEN
    DROP
;

\ Inizializzazione di GAME_OVER
: INITIALIZE_GAME_OVER														\ (    --    )
	CLEAR  WHITE SCOLOR  BORDER

	3E973234 SPIXEL  E SCHAR_SIZE   
	.G. .A. .M. .E. .SPACE. .O. .V. .E. .R.  9 PRINT_WORD

	3EA38604 SPIXEL  4 SCHAR_SIZE   .T. .I. .M. .E. .DP.  5 PRINT_WORD
	3EA387E4 SPIXEL 

	GMINUTES  DUP A / 0 =  IF  0 PRINT_NUMBER  THEN
	PRINT_NUMBER  .DP. PRINT_CHAR  8 INC_PIXEL_O
	
	GSECONDS  DUP A / 0 =  IF  0 PRINT_NUMBER  THEN
	PRINT_NUMBER  .DP. PRINT_CHAR  8 INC_PIXEL_O

	GDECSECONDS PRINT_NUMBER

	3EA7C604 SPIXEL  .S. .C. .O. .R. .E. .DP. 6 PRINT_WORD
	3EA7C844 SPIXEL  GSCORE PRINT_NUMBER
	
	PRINT_BUTTONS
;
\-------------------
\       METODI
\-------------------

\ Struttura GAME_OVER
: GAME_OVER											\ (    --    )
	INITIALIZE_GAME_OVER
	CONTROL_BUTTONS
	0 = IF  INITIALIZE_PLAY  THEN
;

\ Struttura SELECTION
: SELECTION											\ (    --  b1 )
    INITIALIZE_SELECTION
    CONTROL_BUTTONS
;

\ Struttura PLAY
: PLAY												\ (    --    )
	INITIALIZE_PLAY
	BEGIN 
		GCLOCK
		CONTROL_RECEIVER1
		BEGIN  DUP GCLOCK SWAP - 7D0 >  UNTIL

		GSAMPLE 5 = IF  PAUSE_INTERFACE  THEN

        CONTROL_SNAKE
		CONTROL_TIMER
        GDEAD 1 = IF  GAME_OVER  THEN
        BEGIN  DUP GCLOCK SWAP - FA0 >  UNTIL
		
		DROP
	GDEAD 1 =  UNTIL
;

\ Struttura END_GAME
: END_GAME											\ (    --    )
	CLEAR		
;

\ Struttura GAME
: GAME												\ (    --    )
	SELECTION
	0 =  IF  PLAY  THEN
	END_GAME
;
