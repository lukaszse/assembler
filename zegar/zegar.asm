.model  small

;makro do rysowania linii poziomych
rysuj_linie_poz		macro	wiersz, od_kolumny, do_kolumny, kolor
			local	linia_poz
			mov		ah,		0ch			;rysuj piksel
			mov		bh,		0			;nr strony
			mov		al,		kolor		;kolor
			mov		cx,		od_kolumny	;zacznij od kolumny
			mov		dx,		wiersz		;wiersz
linia_poz:	int		10h				    ;wywołanie przerwania
			inc		cx					;przejscie do następnej kolumny
			cmp		cx,		do_kolumny	;rysuj do kolumny
			jle		linia_poz			
			endm

;makro do rysowania linii pionowych
rysuj_linie_pion	macro	kolumna,od_wiersza,	do_wiersza, kolor
			local	linia_pion
			mov		ah,		0ch			;rysuj piksel
			mov 	bh,		0			;nr strony
			mov		al,		kolor		;kolor
			mov		cx,		kolumna		;kolumna
			mov		dx,		od_wiersza	;zacznij od wiersza
linia_pion:	int		10h					;wywołanie przerwania
			inc		dx					;przejscie do następnego wiersza
			cmp		dx,		do_wiersza	;rysuj do wiersza
			jle		linia_pion								
			endm

.stack  100h

.data               
skocz_do_kol	dw		0				
skocz_do_wier	dw		0				
kolumna1		dw		0		    	
kolumna2		dw		0			    	
wiersz1	        dw		0	    		
wiersz2		    dw		0		    	
wiersz3		    dw		0			    
kolor		    db	    49				
amflag			db		0				
time_buf        db      '000000$'       
new_vec			dw		?, ?
old_vec			dw		?, ?

.code

convert             proc
; konwersja liczby dwucyfrowej na kod ASCII
            xor     ah,     ah      ;zerowanie ah
            mov     dl,     10      ;podzielenie przez 10
            div     dl              ;ah = reszta, al = wynik dzielenia
            or      ax,     3030h   ;suma logiczna - zwraca dwucyfrowy wynik w kodzie ASCII 
            ret
convert             endp


get_time            proc
;pobranie czasu i pzechowanie go w pamięci
            mov     ah,     2ch     ;funkcja pobrania czasu z zegara systemowego
            int 21h                 ;ch = godziny, cl = minuty, dh = sekundy
            mov     al,     ch      ;godziny
			call    convert         ;konwersja na kod ascii
            mov     [bx],   ax      ;zachowaj w buforze
            mov     al,     cl      ;minutuy
            call    convert         ;konwersja na kod ascii
            mov     [bx+3], ax      ;zachowaj w buforze
            mov     al,     dh      ;sekundy
            call    convert         ;konwersja na kod ascii
            mov     [bx+6], ax      ;zachowaj w buforze

            ret
get_time            endp

time_int			proc
;procedura przerwania wywoływana przez timer
			push	ds					;ds na stos
			mov		ax,		@data		;przypisanie danych do segmentu z wykorzystaniem rejestru ax
			mov		ds,		ax
;pobranie czasu
			lea		bx,		time_buf	;ustawienie wskaźnika na bufor w rejestrze bx
			call	get_time			;zachowanie akualnego czasu w buforze

;wypisz pierwszą cyfre godziny
			mov		skocz_do_wier,	65
			mov		skocz_do_kol,	30
			call	rysuj_czarne_tlo
            mov     si, 0
            call    drukuj_cyfre
;wypisz druga cyfre godziny
			mov		skocz_do_wier,	65
			mov		skocz_do_kol,	70
			call	rysuj_czarne_tlo
            mov     si, 1
            call    drukuj_cyfre
;wypisz separator
			mov		skocz_do_wier,	65
			mov		skocz_do_kol,	100
			call	rysuj_separator
;wypisz pierwszą cyfrę minut
			mov		skocz_do_wier,	65
			mov		skocz_do_kol,	120
			call	rysuj_czarne_tlo
            mov     si, 3
            call    drukuj_cyfre
;wypisz drugą cyfrę minut
			mov		skocz_do_wier,	65
			mov		skocz_do_kol,	160
			call	rysuj_czarne_tlo
            mov     si, 4
            call    drukuj_cyfre
			
;wypisz separator
			mov		skocz_do_wier,	65
			mov		skocz_do_kol,	190
			call	rysuj_separator
;wypisz ppierwszą cyfrę sekund
			mov		skocz_do_wier,	65
			mov		skocz_do_kol,	210
			call	rysuj_czarne_tlo
            mov     si, 6
            call    drukuj_cyfre
;wypisz drugą cyfrę sekund
			mov		skocz_do_wier,	65
			mov		skocz_do_kol,	250
			call	rysuj_czarne_tlo
            mov     si, 7
            call    drukuj_cyfre
		
			pop		ds
			iret
time_int			endp

drukuj_cyfre        proc
			mov		al,		'0'
			cmp		[bx+si],	al
			jne		h11
			call	wypisz0
			jmp		h1d
	h11:	inc		al
			cmp		[bx+si],	al
			jne		h12
			call	wypisz1
			jmp		h1d
	h12:	inc		al
			cmp		[bx+si],	al
			jne		h13
			call	wypisz2
			jmp		h1d
	h13:	inc		al
			cmp		[bx+si],	al
			jne		h14
			call	wypisz3
			jmp		h1d
	h14:	inc		al
			cmp		[bx+si],	al
			jne		h15
			call	wypisz4
			jmp		h1d
	h15:	inc		al
			cmp		[bx+si],	al
			jne		h16
			call	wypisz5
			jmp		h1d
	h16:	inc		al
			cmp		[bx+si],	al
			jne		h17
			call	wypisz6
			jmp		h1d
	h17:	inc		al
			cmp		[bx+si],	al
			jne		h18
			call	wypisz7
			jmp		h1d
	h18:	inc		al
			cmp		[bx+si],	al
			jne		h19
			call	wypisz8
			jmp		h1d
	h19:	call	wypisz9
	h1d:
    ret
drukuj_cyfre endp

setup_int           proc
;zapisanie starego wektora i ustawienie nowego
;wejscie:	al = nr przerwania number
;			di = adres bufora dla starego vectora
;			si = adres bufora zawierajacego nowy wektor
;zapis starego wektora przerwania
			mov		ah,		35h		;pobranie wektora
			int		21h				;es:bx = vector
			mov		[di],	bx		;zapis offsetu
			mov		[di+2],	es		;zapis segmentu
;ustawienie nowego wektora
			mov		dx,		[si]	;wpisanie ofsetu do dx
			push	ds				;dx na stos
			mov		ds,		[si+2]	;wpisanie offsetu do ds
			mov		ah,		25h		;funkcja ustawienia wektora
			int		21h
			pop		ds				;poprabie ds ze stosu
			ret
setup_int			endp

start:                
            mov     ax,     @data
            mov     ds,     ax          ;initialize ds

			mov		ah,		0h			;wybor trybu graficznego
			mov		al,		13h			;ustawienie tryby graficznego 320x200 256
			int		10h					;wywolanie funkcji 10h przerwania BIOS

;ustawienie procedury przerwania po przez wstawienie segment:offset dla time_int w  zmiennej new_vec
			mov		new_vec,	offset	time_int
			mov		new_vec+2,	seg		time_int
			lea		di,		old_vec		;ustawienie wskznika do starego vectora w di
			lea		si,		new_vec		;ustawienie wskaznika do nowego wektora w si
			mov		al,		1ch			;przerwanie zegara
			call	setup_int			;wywolanie procedury przerwania
;odczyt z klawiatury
			mov		ah,		0
			int		16h
;przywrócenie starego wektora przerwania
			lea		di,		new_vec		;ustawienie wskaznika na nowy wektor w di 
			lea		si,		old_vec		;ustawienie wskaznika na stary wektor w si
			mov		al,		1ch			;przerwanie zegara
			call	setup_int			;wywolanie procedurt przerwania 
;przywrocenie trybu tekstoweggo
			mov		ah,		0
			mov		al,		3
			int		10h
;wyjscie z programu
            mov     ah,     4ch     
            int 	21h                


wypisz0				proc

			mov		ax,			skocz_do_kol
			mov		kolumna1,	0
			add		kolumna1,	ax
			mov		kolumna2,	30
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	0
			add		wiersz1,	ax
			mov		wiersz2,	25
			add		wiersz2,	ax
			mov		wiersz3,	50
			add		wiersz3,	ax
			rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz3,	kolumna1,	kolumna2,	kolor
			rysuj_linie_pion	kolumna1,	wiersz1,	wiersz3,	kolor
			rysuj_linie_pion	kolumna2,	wiersz1,	wiersz3,	kolor

			ret
wypisz0				endp

wypisz1				proc

			mov		ax,			skocz_do_kol
			mov		kolumna1,	20
			add		kolumna1,	ax
			mov		kolumna2,	30
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	0
			add		wiersz1,	ax
			mov		wiersz2,	25
			add		wiersz2,	ax
			mov		wiersz3,	50
			add		wiersz3,	ax
			rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
			rysuj_linie_pion	kolumna2,	wiersz1,	wiersz3,	kolor

			ret
wypisz1				endp

wypisz2				proc

			mov		ax,			skocz_do_kol
			mov		kolumna1,	0
			add		kolumna1,	ax
			mov		kolumna2,	30
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	0
			add		wiersz1,	ax
			mov		wiersz2,	25
			add		wiersz2,	ax
			mov		wiersz3,	50
			add		wiersz3,	ax
			rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz2,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz3,	kolumna1,	kolumna2,	kolor
			rysuj_linie_pion	kolumna1,	wiersz2,	wiersz3,	kolor
			rysuj_linie_pion	kolumna2,	wiersz1,	wiersz2,	kolor

			ret
wypisz2				endp

wypisz3				proc

			mov		ax,			skocz_do_kol
			mov		kolumna1,	0
			add		kolumna1,	ax
			mov		kolumna2,	30
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	0
			add		wiersz1,	ax
			mov		wiersz2,	25
			add		wiersz2,	ax
			mov		wiersz3,	50
			add		wiersz3,	ax
			rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz2,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz3,	kolumna1,	kolumna2,	kolor
			rysuj_linie_pion	kolumna2,	wiersz1,	wiersz3,	kolor

			ret
wypisz3				endp

wypisz4				proc

			mov		ax,			skocz_do_kol
			mov		kolumna1,	0
			add		kolumna1,	ax
			mov		kolumna2,	30
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	0
			add		wiersz1,	ax
			mov		wiersz2,	25
			add		wiersz2,	ax
			mov		wiersz3,	50
			add		wiersz3,	ax
			rysuj_linie_poz		wiersz2,	kolumna1,	kolumna2,	kolor
			rysuj_linie_pion	kolumna1,	wiersz1,	wiersz2,	kolor
			rysuj_linie_pion	kolumna2,	wiersz1,	wiersz3,	kolor

			ret
wypisz4				endp

wypisz5				proc

			mov		ax,			skocz_do_kol
			mov		kolumna1,	0
			add		kolumna1,	ax
			mov		kolumna2,	30
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	0
			add		wiersz1,	ax
			mov		wiersz2,	25
			add		wiersz2,	ax
			mov		wiersz3,	50
			add		wiersz3,	ax
			rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz2,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz3,	kolumna1,	kolumna2,	kolor
			rysuj_linie_pion	kolumna1,	wiersz1,	wiersz2,	kolor
			rysuj_linie_pion	kolumna2,	wiersz2,	wiersz3,	kolor

			ret
wypisz5				endp

wypisz6				proc

			mov		ax,			skocz_do_kol
			mov		kolumna1,	0
			add		kolumna1,	ax
			mov		kolumna2,	30
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	0
			add		wiersz1,	ax
			mov		wiersz2,	25
			add		wiersz2,	ax
			mov		wiersz3,	50
			add		wiersz3,	ax
			rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz2,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz3,	kolumna1,	kolumna2,	kolor
			rysuj_linie_pion	kolumna1,	wiersz1,	wiersz3,	kolor
			rysuj_linie_pion	kolumna2,	wiersz2,	wiersz3,	kolor

			ret
wypisz6				endp

wypisz7				proc

			mov		ax,			skocz_do_kol
			mov		kolumna1,	0
			add		kolumna1,	ax
			mov		kolumna2,	30
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	0
			add		wiersz1,	ax
			mov		wiersz2,	25
			add		wiersz2,	ax
			mov		wiersz3,	50
			add		wiersz3,	ax
			rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
			rysuj_linie_pion	kolumna2,	wiersz1,	wiersz3,	kolor

			ret
wypisz7				endp

wypisz8				proc

			mov		ax,			skocz_do_kol
			mov		kolumna1,	0
			add		kolumna1,	ax
			mov		kolumna2,	30
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	0
			add		wiersz1,	ax
			mov		wiersz2,	25
			add		wiersz2,	ax
			mov		wiersz3,	50
			add		wiersz3,	ax
			rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz2,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz3,	kolumna1,	kolumna2,	kolor
			rysuj_linie_pion	kolumna1,	wiersz1,	wiersz3,	kolor
			rysuj_linie_pion	kolumna2,	wiersz1,	wiersz3,	kolor

			ret
wypisz8				endp

wypisz9				proc

			mov		ax,			skocz_do_kol
			mov		kolumna1,	0
			add		kolumna1,	ax
			mov		kolumna2,	30
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	0
			add		wiersz1,	ax
			mov		wiersz2,	25
			add		wiersz2,	ax
			mov		wiersz3,	50
			add		wiersz3,	ax
			rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz2,	kolumna1,	kolumna2,	kolor
			rysuj_linie_poz		wiersz3,	kolumna1,	kolumna2,	kolor
			rysuj_linie_pion	kolumna1,	wiersz1,	wiersz2,	kolor
			rysuj_linie_pion	kolumna2,	wiersz1,	wiersz3,	kolor

			ret
wypisz9				endp

rysuj_separator			proc

			mov		ax,			skocz_do_kol
			mov		kolumna1,	9
			add		kolumna1,	ax
			mov		kolumna2,	11
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	17
			add		wiersz1,	ax
			rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
            inc     wiersz1
            rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
            inc     wiersz1
            rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor


			mov		ax,			skocz_do_kol
			mov		kolumna1,	9
			add		kolumna1,	ax
			mov		kolumna2,	11
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	31
			add		wiersz1,	ax
			rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
            inc     wiersz1
            rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
            inc     wiersz1
            rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	kolor
            inc     wiersz1
			ret
rysuj_separator			endp

rysuj_czarne_tlo			proc
			mov		ax,			skocz_do_kol
			mov		kolumna1,	0
			add		kolumna1,	ax
			mov		kolumna2,	30
			add		kolumna2,	ax
			mov		ax,			skocz_do_wier
			mov		wiersz1,	0
			add		wiersz1,	ax
			mov		wiersz2,	25
			add		wiersz2,	ax
			mov		wiersz3,	50
			add		wiersz3,	ax
			rysuj_linie_poz		wiersz1,	kolumna1,	kolumna2,	0
			rysuj_linie_poz		wiersz2,	kolumna1,	kolumna2,	0
			rysuj_linie_poz		wiersz3,	kolumna1,	kolumna2,	0
			rysuj_linie_pion	kolumna1,	wiersz1,	wiersz3,	0
			rysuj_linie_pion	kolumna2,	wiersz1,	wiersz3,	0

			ret
rysuj_czarne_tlo			endp

end start