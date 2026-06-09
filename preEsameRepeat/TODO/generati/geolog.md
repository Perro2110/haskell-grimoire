# Esercizio: Analisi dei Centri di Pressione (15 punti)

## Descrizione

In un esperimento di geologia, una lastra rettangolare di materiale viene monitorata tramite una griglia di sensori N×M. I dati sulla pressione rilevata sono salvati nel file `pressione.txt`, dove ogni riga del file corrisponde a una riga della griglia e i valori (interi) sono separati da spazi.

## Obiettivo

Il programma deve identificare i "Punti Critici" della lastra.

## Criteri

Un sensore in posizione `(r,c)` è considerato un **Punto Critico** se soddisfa entrambi i seguenti criteri:

1. **Criterio del Picco**: La sua pressione è strettamente superiore a quella dei suoi 4 vicini diretti (Sopra, Sotto, Destra, Sinistra).

2. **Criterio di Rilevanza**: La sua pressione è superiore alla media globale di tutte le celle della lastra.

## Area di Stress

Per ogni Punto Critico individuato, il programma deve calcolare l'**Area di Stress**, definita come il numero di vicini (tra i 4 adiacenti) che hanno una pressione superiore all'80% della pressione del Punto Critico stesso.

## Output

Il programma deve stampare per ogni Punto Critico:

- Le sue coordinate `(r,c)` (con indici che partono da 1)
- Il valore della pressione rilevata
- Il valore dell'Area di Stress (un intero da 0 a 4)

## Requisito aggiuntivo (4 punti)

In tutti i punti in cui è possibile, si usino funzioni di ordine superiore (come `map`, `filter`, `fold`, `zipWith`) o list comprehensions.

## Dati per il test (`pressione.txt`)

Crea un file chiamato `pressione.txt` con questo contenuto:
10 12 11 10 15 12
15 30 14 12 10 11
11 13 12 25 22 10
10 10 10 18 40 15
22 20 12 11 14 10
10 11 15 12 10 12

L'**output** risultante è:
(1,5) Pressione: 15 Area di stress: 0
(2,2) Pressione: 30 Area di stress: 0
(3,4) Pressione: 25 Area di stress: 1
(4,5) Pressione: 40 Area di stress: 0
(5,1) Pressione: 22 Area di stress: 1
(6,3) Pressione: 15 Area di stress: 0

