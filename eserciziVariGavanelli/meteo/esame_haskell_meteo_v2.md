Esame simulato
Programmazione Funzionale — Haskell
1 esercizio
90 minuti · 15 punti base + 4 bonus · Consegna: file .hs
Esercizio 1 — Monitoraggio di una rete meteorologica
15 pt
Descrizione del problema
Una rete di stazioni meteorologiche raccoglie misurazioni di temperatura durante la giornata. I dati sono salvati nel
file misure.txt; ogni riga contiene il nome della stazione seguito da una sequenza di temperature (valori interi, in °C)
rilevate nelle ore della giornata:

Milano 12 15 17 20 22 21 18 14
Roma 15 18 22 26 28 27 24 19
Torino 9 11 14 18 20 19 15 10
Bologna 13 16 19 23 25 24 20 15
Il numero di rilevazioni per ogni stazione è lo stesso per tutte le stazioni, ma non è noto a priori.

Cosa deve fare il programma
Il programma deve produrre su standard output tre sezioni distinte:

1. Escursione termica per stazione

Per ogni stazione, calcola e stampa la differenza tra la temperatura massima e quella minima rilevata. Le stazioni sono
elencate in ordine di escursione decrescente.

Escursioni termiche:
Roma 13
Bologna 12
Torino 11
Milano 10

2. Ore critiche

Si dice che un'ora è critica se la sua temperatura media tra tutte le stazioni è strettamente superiore alla media
generale di tutte le misurazioni. Il programma stampa gli indici (da 1) delle ore critiche.

Ore critiche: 4 5 6 7
Media generale = 18.09°C. Medie orarie: ora 4 → 21.75, ora 5 → 23.75, ora 6 → 22.75, ora 7 → 19.25. Tutte strettamente
superiori a 18.09.

3. Stazioni anomale

Una stazione è anomala se almeno una coppia di ore consecutive presenta un calo brusco: una diminuzione di 5°C o più tra
un'ora e la successiva. Il programma elenca i nomi delle stazioni anomale (oppure nessuna).