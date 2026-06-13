# Esercizio: Analisi Temperature Vicine 

## Descrizione

Una griglia N×M di sensori di temperatura è salvata nel file `temperature.txt`, una riga di valori interi per riga della griglia.

## Obiettivo

Trovare le "Celle Calde": una cella `(r,c)` è una Cella Calda se la sua temperatura è strettamente maggiore della media dei suoi vicini diretti esistenti (Sopra, Sotto, Destra, Sinistra — per le celle di bordo si considerano solo i vicini presenti).

## Output

Per ogni Cella Calda, stampare (indici a partire da 1):

```
(r,c) Temperatura: T Media vicini: M
```

## Dati per il test (`temperature.txt`)

```
12 15 10
18 14 16
11 13 12
```

## Output atteso

```
(1,2) Temperatura: 15 Media vicini: 14.67
(2,1) Temperatura: 18 Media vicini: 13.67
```