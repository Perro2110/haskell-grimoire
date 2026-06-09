### Descrizione del problema

Un'azienda logistica traccia gli spostamenti di un drone automatico all'interno di un magazzino piano diviso in celle. La mappa del magazzino presenta degli ostacoli fissi le cui coordinate $(X, Y)$ sono salvate nel file `ostacoli.txt` (ogni riga contiene due interi separati da uno spazio).

I movimenti pianificati per il drone sono registrati nel file `percorso.txt`, dove la prima riga indica le coordinate di partenza `X Y`, e le righe successive contengono un singolo carattere che rappresenta la direzione dello spostamento:
- `'U'` (Up, $Y+1$)
- `'D'` (Down, $Y-1$)
- `'L'` (Left, $X-1$)
- `'R'` (Right, $X+1$)

---

### Esercizio 1 (punti 15)

Si scriva un programma Haskell che esegua le seguenti operazioni:

1. Chieda all'utente l'inserimento da tastiera delle dimensioni massime della griglia del magazzino sotto forma di limite massimo $N$ per le $X$ e $M$ per le $Y$ (assumendo che la griglia parta da $(0,0)$ fino a $(N,M)$).
2. Legga i file `ostacoli.txt` e `percorso.txt`.
3. Verifichi se il percorso del drone è **sicuro**, ossia se il drone non esce mai dai confini della griglia
```(0 <= X <= N, 0 <= Y <= M)``` e non transita mai sopra una cella contenente un ostacolo.
4. Visualizzi a schermo un messaggio finale:
   - In caso di esito positivo stampi: `"Percorso sicuro. Distanza di Manhattan totale percorsa: ..."`
   - In caso di violazione stampi: `"Collisione o uscita dai confini alla cella (X,Y)"` interrompendo l'analisi.

#### Esempio di file `percorso.txt`:
```
0 0
U
R
U
```

Se non ci sono ostacoli nelle celle (0,1), (1,1), e (1,2), il drone si muoverà in sicurezza.

### Esercizio 2 (punti 2)
Si modifichi il programma precedente affinché, al termine di un percorso sicuro, generi un file di output chiamato `tracciato.txt` contenente l'elenco ordinato di tutte le coordinate uniche visitate dal drone durante il tragitto.
Esempio di output:
```
(0,0)
(0,1)
(1,1)
(1,2)
```