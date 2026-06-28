# 📘 Haskell — Appunti e Concetti Fondamentali

Riassunto spiegazioni e esempi di codice per i concetti chiave di Haskell.
Codice completo presente in conoscenze.hs

> [!TIP]
> Si consiglia di leggere il file `conoscenze.hs` per vedere il codice completo e funzionante, mentre questo file `README.md` contiene spiegazioni e frammenti di codice.

---

## 1. Funzioni di Base

In Haskell ogni funzione ha una **firma dei tipi** e una **definizione**. La sintassi è pulita e dichiarativa.

```haskell
double :: Int -> Int
double x = x + x

quadruple :: Int -> Int
quadruple x = double(double x)
```

Le funzioni sono **pure**: dato lo stesso input, restituiscono sempre lo stesso output, senza effetti collaterali.

---

## 2. Pattern Matching

Il **pattern matching** permette di definire comportamenti diversi in base alla struttura dell'argomento. È uno dei meccanismi più potenti di Haskell.

```haskell
-- Su valori specifici
or :: Bool -> Bool -> Bool
or True _ = True
or _ True = True
or _ _    = False

-- Su liste
last4 :: [a] -> a
last4 [a]   = a
last4 (a:b) = last4 b
```

Il simbolo `_` è un **wildcard**: indica che il valore non ci interessa.

---

## 3. Guardie (Guards)

Le **guardie** sono condizioni booleane che selezionano quale ramo eseguire. Si usano con `|`.

```haskell
abs :: Int -> Int
abs n | n < 0     = -n
      | otherwise = n

last3 :: [a] -> a
last3 (a:b) | (length b) /= 0 = last3 b
            | otherwise       = a
```

`otherwise` equivale a `True` ed è usato come caso di default.

---

## 4. Ricorsione

In Haskell non esistono cicli `for` o `while`. Si usa la **ricorsione** per iterare.

```haskell
mfactorial :: Int -> Int
mfactorial n = foldr (*) 1 [1..n]

inverti :: [a] -> [a]
inverti [] = []
inverti (l:t) = inverti t ++ [l]

lengthh [] = 0
lengthh (a:b) = 1 + lengthh b
```

Il pattern tipico è: **caso base** (lista vuota o valore singolo) + **caso ricorsivo**.

---

## 5. Liste

Le liste sono il tipo di dati più usato in Haskell. Alcune operazioni fondamentali:

| Operazione | Funzione |
|---|---|
| Primo elemento | `head` |
| Resto della lista | `tail` |
| Lunghezza | `length` |
| Concatenazione | `++` |
| Inversione | `reverse` |
| Accesso per indice | `!!` |

```haskell
-- Diverse implementazioni di "ultimo elemento"
last1 a = head(reverse(a))
last2 a = a !! ((length a) - 1)
last4 [a]   = a
last4 (a:b) = last4 b
```

### Sintassi `(a:b)`

Il costrutto `(a:b)` **decostruisce** una lista: `a` è la testa (head) e `b` è il resto (tail).

```haskell
concatena :: [a] -> [a] -> [a]
concatena [] b    = b
concatena (a:b) c = a : concatena b c
```

---

## 6. Funzioni di Ordine Superiore

Haskell tratta le funzioni come valori: possono essere passate come argomenti o restituite.

### `map`
Applica una funzione a ogni elemento di una lista.

```haskell
quadList :: [Int] -> [Int]
quadList a = map (\x -> x * x) a

acronimo :: [String] -> [Char]
acronimo a = map (\x -> head x) a
```

### `filter`
Seleziona gli elementi che soddisfano un predicato.

```haskell
positivi :: [Int] -> [Int]
positivi a = filter (\x -> x > 0) a

vocali :: [Char] -> [Char]
vocali a = filter (\x -> inn x "aeiou") a
```

### `foldr` — riduzione da destra

Riduce una lista a un singolo valore applicando una funzione **da destra**. Struttura: `foldr f valore_iniziale lista`.

**Come funziona internamente:**

```haskell
foldrr f x []    = x
foldrr f x (a:b) = f a (foldrr f x b)
```

La ricorsione scende fino in fondo alla lista **prima** di applicare qualsiasi operazione. Il valore iniziale è l'argomento più a destra dell'intera espressione:

```
foldr (+) 0 [1,2,3]
  → 1 + (foldr (+) 0 [2,3])
  → 1 + (2 + (foldr (+) 0 [3]))
  → 1 + (2 + (3 + 0))          ← si costruisce partendo dal fondo
  → 6
```

Generalizzando: `foldr f z [a,b,c]` diventa `f a (f b (f c z))`.

```haskell
sumf a = foldr (+) 0 a       -- somma
prod a = foldr (*) 1 a       -- prodotto

-- Contare elementi
lengthFold a = foldr (\ x n -> n + 1) 0 a

-- Contare vocali
vocalii :: [Char] -> Int
vocalii a = foldr (\ x n -> if (elem x "aeiou") then n + 1 else n) 0 a
```

### `foldl` — riduzione da sinistra

Come `foldr` ma accumula **da sinistra**. L'accumulatore viene aggiornato ad ogni passo senza aspettare la fine della lista.

**Come funziona internamente:**

```haskell
foldll f v []     = v
foldll f v (x:xs) = foldll f (f v x) xs
```

Ad ogni passo ricorsivo, la funzione viene **applicata subito** sull'accumulatore corrente:

```
foldl (+) 0 [1,2,3]
  → foldl (+) (0+1) [2,3]
  → foldl (+) ((0+1)+2) [3]
  → foldl (+) (((0+1)+2)+3) []
  → ((0+1)+2)+3                ← si accumula partendo da sinistra
  → 6
```

Generalizzando: `foldl f v [a,b,c]` diventa `f (f (f v a) b) c`.

### Confronto `foldr` vs `foldl`

| | `foldr f z [a,b,c]` | `foldl f v [a,b,c]` |
|---|---|---|
| Espansione | `f a (f b (f c z))` | `f (f (f v a) b) c` |
| Associatività | destra | sinistra |
| Valuta prima | il fondo della lista | la testa della lista |
| Liste infinite | funziona (lazy) | non termina |
| Efficienza | meno efficiente su liste lunghe | più efficiente con accumulatore |

> **Regola pratica:** usa `foldr` quando vuoi costruire una nuova lista o lavorare in modo lazy. Usa `foldl` (o meglio `foldl'` da `Data.List`) quando accumuli un valore su liste finite.

### Versioni point-free con `foldr`

```haskell
s :: [Int] -> Int
s = foldr (+) 0

p :: [Int] -> Int
p = foldr (*) 1

o :: [Bool] -> Bool
o = foldr (||) False

aa :: [Bool] -> Bool
aa = foldr (&&) True
```

---

## 7. Lambda (Funzioni Anonime)

Le **lambda** si scrivono con `\x -> espressione`. Sono utili con `map`, `filter`, `foldr`, ecc.

```haskell
map (\x -> x * x) [1,2,3]          -- [1,4,9]
filter (\x -> x > 0) [-1,2,-3,4]   -- [2,4]
```

---

## 8. Currying e Applicazione Parziale

In Haskell ogni funzione accetta **un solo argomento alla volta** e restituisce una nuova funzione per ogni argomento successivo. Questo si chiama **currying**.

```haskell
multiply :: Int -> Int -> Int
multiply x y = x * y

double2 = multiply 2   -- funzione parzialmente applicata
triple2 = multiply 3

-- Con le funzioni di lista
addOne       = map (+1)     -- aggiunge 1 a ogni elemento
greaterThan5 = filter (>5)  -- filtra valori > 5

-- Esempio con la gravità
gravity :: Float -> Float -> Float -> Float
gravity m1 d m2 = ((6.67 * 1/10^11) * (m1 * m2)) / (d * d)

earthGravity :: Float -> Float -> Float
earthGravity = gravity (5.972 * 10^24)   -- m1 fissata alla massa della Terra

earthGravitySurface = earthGravity 6371000  -- d fissata al raggio terrestre

-- Sections
log2 :: Float -> Float
log2 = logBase 2

rec :: Float -> Float
rec = (1/)
```

---

## 9. `zip` e Corrispondenze

`zip` unisce due liste in una lista di coppie. Utile per confrontare elementi in posizione corrispondente. Si ferma alla lista più corta.

```haskell
-- zip [1,2,3] ["a","b","c"] → [(1,"a"),(2,"b"),(3,"c")]

corrispondenze listaA listaB =
    filter (\(x, y) -> x == y) (zip listaA listaB)
```

---

## 10. Tuple

Le **tuple** raggruppano un numero fisso di valori, anche di tipi diversi.

```haskell
addVect :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVect a b = (fst a + fst b, snd a + snd b)
```

- `fst` restituisce il primo elemento di una coppia
- `snd` restituisce il secondo elemento

---

## 11. Tipi e Polimorfismo

Haskell è **fortemente tipizzato** ma supporta il **polimorfismo**: funzioni generiche che operano su qualsiasi tipo.

```haskell
-- [a] significa "lista di qualsiasi tipo"
last4 :: [a] -> a
inverti :: [a] -> [a]

-- (Num a) è un vincolo: a deve essere un tipo numerico
addVect :: (Num a) => (a, a) -> (a, a) -> (a, a)
```

---

## 12. Caratteri e Stringhe

In Haskell una `String` è semplicemente una lista di `Char` (`[Char]`).

```haskell
nsucc :: Char -> Int -> Char
nsucc c n = toEnum (fromEnum c + n)

-- Cifrario di Cesare
cypher :: [Char] -> Int -> [Char]
cypher a num = map (\x -> nsucc x num) a
```

- `fromEnum` converte un `Char` nel suo codice numerico (ASCII/Unicode)
- `toEnum` fa il contrario

---

## 13. Funzioni su Liste di Funzioni

In Haskell le funzioni sono valori di prima classe e possono essere messe in lista. Questo permette di applicare più controlli in sequenza in modo elegante.

```haskell
funandmap :: [(a -> Bool)] -> a -> Bool
funandmap [] b     = True
funandmap (a:at) b = a b && funandmap at b

-- Esempio: checker che combina più validatori
checker :: [Char] -> Bool
checker a = funandmap [check_cifre, check_lower, check_upper, check_lung] a
```

---

## 14. Esempio Completo — Validatore Password

Requisiti: lunghezza > 15, almeno una minuscola, almeno una maiuscola, almeno un numero.

```haskell
-- Versione modulare (4 checker separati)
checckers_1 :: [Char] -> Bool
checckers_1 a = (foldr (\ x n -> n + 1) 0 a) > 15

checckers_2 :: [Char] -> Bool
checckers_2 a = (foldr (\ x n -> if elem x ['A'..'Z'] then n+1 else n) 0 a) > 1

checckers_3 :: [Char] -> Bool
checckers_3 a = (foldr (\ x n -> if elem x ['a'..'z'] then n+1 else n) 0 a) > 1

checckers_4 :: [Char] -> Bool
checckers_4 a = (foldr (\ x n -> if elem x ['0'..'9'] then n+1 else n) 0 a) > 1

checker :: [Char] -> Bool
checker a = funandmap [checckers_4, checckers_3, checckers_2, checckers_1] a

-- Versione compatta (tutto in una funzione)
checker_litee :: [Char] -> Bool
checker_litee a =
    ((foldr (\ x n -> n + 1) 0 a) > 15) &&
    (foldr (\ x n -> elem x ['a'..'z'] || n) False a) &&
    (foldr (\ x n -> elem x ['A'..'Z'] || n) False a) &&
    (foldr (\ x n -> elem x ['0'..'9'] || n) False a)
```

---

## 15. Composizione di Funzioni

L'operatore `.` compone due funzioni: `(f . g) x` equivale a `f (g x)`. Permette di costruire pipeline eleganti senza nominare gli argomenti (stile **point-free**).

```haskell
-- Senza composizione
isOdd x = not (even x)

-- Con composizione
oddd :: Int -> Bool
oddd = not . even
-- oddd 3 → not (even 3) → not False → True

-- Pipeline più lunga
inizialeMaiuscola :: String -> Char
inizialeMaiuscola = toUpper . head
-- prima head, poi toUpper
```

L'operatore `.` si legge "dopo": `not . even` significa "not *dopo* even". La lettura va **da destra a sinistra**.

---

## 16. `zipWith` — zip con Funzione

`zipWith` è la generalizzazione di `zip`: invece di creare coppie, applica una funzione agli elementi corrispondenti delle due liste.

```haskell
zipWithh :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWithh f [] _        = []
zipWithh f _ []        = []
zipWithh f (a:b) (c:d) = f a c : zipWithh f b d

-- Esempi
zipWith (+) [1,2,3] [10,20,30]   -- [11,22,33]
zipWith (*) [1,2,3] [4,5,6]      -- [4,10,18]

-- Controlla se una lista è ordinata
ordinato :: (Ord a) => [a] -> Bool
ordinato a = and (zipWith (<=) a (tail a))
-- [1,2,3] → zipWith (<=) [1,2,3] [2,3] → [True,True] → True

-- Versione con all
otherordinato :: (Ord a) => [a] -> Bool
otherordinato a = all (== True) (zipWith (<=) a (tail a))
```

`zip` è il caso speciale `zipWith (,)`.

---

## 17. List Comprehension

La **list comprehension** è una sintassi compatta per generare liste, ispirata alla notazione matematica degli insiemi. `{ x² | x ∈ [1..5] }` diventa `[x*x | x <- [1..5]]`.

```haskell
-- Sintassi base: [espressione | generatore, guardia]

-- Quadrati dei pari
[x*x | x <- [1..10], even x]
-- [4,16,36,64,100]

-- Coppie (x,y) con x <= y
[(x,y) | x <- [1..3], y <- [x..3]]
-- [(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)]

-- Tavola pitagorica n×n
pitagorica n = [[x*y | x <- [1..n]] | y <- [1..n]]

-- Prodotto cartesiano: l'ordine dei generatori conta!
[(x,y) | y <- [4,5], x <- [1,2,3]]
-- [(1,4),(2,4),(3,4),(1,5),(2,5),(3,5)]
-- y varia più lentamente (è il generatore esterno)
```

Le list comprehension possono sempre essere riscritte con `map` e `filter`:

| Comprehension | Equivalente |
|---|---|
| `[f x \| x <- xs]` | `map f xs` |
| `[x \| x <- xs, p x]` | `filter p xs` |
| `[f x \| x <- xs, p x]` | `map f (filter p xs)` |

### List comprehension su liste infinite

La lazy evaluation permette di usare le list comprehension su sequenze infinite. Il trucco è abbinare un generatore `[1..]` a un predicato costoso: Haskell calcola solo gli elementi effettivamente richiesti.

```haskell
-- Numeri di Taxicab: esprimibili come somma di due cubi in almeno 2 modi
taxicab :: [Int]
taxicab = [ n | n <- [1..], length (coppie n) >= 2 ]

coppie :: Int -> [(Int,Int)]
coppie n = [ (x,y) | x <- [1..n], y <- [x+1..n], x^3 + y^3 == n ]

-- take 3 taxicab → [1729, 4104, 13832]
```

---

## 18. Lazy Evaluation

Haskell usa la **valutazione pigra** (lazy): le espressioni vengono calcolate solo quando il loro valore è effettivamente necessario. Questo permette di definire strutture dati potenzialmente infinite.

```haskell
-- Lista infinita dei numeri di Hamming (divisibili solo per 2, 3 o 5)
_hamming = 1 : merge (map (*2) hamming)
                     (merge (map (*3) hamming) (map (*5) hamming))

hamming = uniq _hamming

-- take 10 hamming → [1,2,3,4,5,6,8,9,10,12]
```

La funzione `uniq` rimuove duplicati adiacenti (necessaria perché le tre sequenze `*2`, `*3`, `*5` possono produrre lo stesso valore):

```haskell
uniq [] = []
uniq (a:as) = a : filter (/= a) (uniq as)
```

La lista `hamming` si definisce **in termini di se stessa**: è possibile perché Haskell non valuta l'intera lista, ma costruisce ogni elemento solo quando viene richiesto con `take`, `head`, ecc.

**Eager vs lazy**: nella valutazione eager ogni espressione viene calcolata subito; in quella lazy viene creato un "thunk" (promessa di calcolo) che viene forzato solo quando necessario. Il vantaggio è poter lavorare con strutture infinite; lo svantaggio è un overhead di memoria se i thunk si accumulano senza essere consumati.

> [!IMPORTANT]
> si noti che foldr può lavorare con liste infinite se la funzione combinatrice è **non-strict** (cioè non valuta subito il secondo argomento). Ad esempio, `foldr (&&) True` può terminare su una lista infinita di `False` senza scorrere tutta la lista.
---

## 19. Rimozione di Duplicati

### Duplicati consecutivi — `remdups`

Rimuove solo i duplicati **adiacenti** (la lista deve essere ordinata perché sia utile come deduplicazione completa).

```haskell
remdups :: (Eq a) => [a] -> [a]
remdups [] = []
remdups [a] = [a]
remdups (a:b:xs) | a == b    = remdups (b:xs)
                 | otherwise = a : remdups (b:xs)

-- remdups [1,1,2,2,2,3] → [1,2,3]
-- remdups [1,2,1,2]     → [1,2,1,2]  (non ordinate rimangono!)
```

Versione con `foldr`:

```haskell
remdupsf :: (Eq a) => [a] -> [a]
remdupsf [] = []
remdupsf (a:as) = foldr (\x acc -> if x == head acc then acc else x:acc) [a] as
```

---

## 20. Massimo con Funzione di Ordinamento

`maxf` trova l'elemento che massimizza il valore prodotto da una funzione `f`, usando `foldr`:

```haskell
maxf :: (Ord b) => (a -> b) -> [a] -> a
maxf f (a:b) = foldr (\x y -> if f x >= f y then x else y) a b

-- Esempio: parola più lunga
maxf length ["gatto","elefante","bue"]   -- "elefante"

-- Numero con valore assoluto maggiore
maxf abs [-10, 3, -5, 8]               -- -10
```

---

## 21. Algoritmi di Ordinamento — Merge Sort

Il **merge sort** è un algoritmo divide-et-impera: divide la lista a metà, ordina ricorsivamente ciascuna metà, poi le fonde mantenendo l'ordine.

```haskell
merge :: (Ord a) => [a] -> [a] -> [a]
merge a [] = a
merge [] a = a
merge (a:b) (c:d) | a < c     = a : merge b (c:d)
                  | otherwise = c : merge (a:b) d

mergeSort :: (Ord a) => [a] -> [a]
mergeSort []  = []
mergeSort [a] = [a]
mergeSort a   = let (l,r) = splitAt (length a `div` 2) a
                in merge (mergeSort l) (mergeSort r)

-- mergeSort [5,1,3,2,4] → [1,2,3,4,5]
```

`splitAt n xs` divide `xs` in due metà: i primi `n` elementi e il resto.

---

## 22. Calcolo di Distanze

`distanza` calcola la lunghezza totale di un percorso dato come lista di punti `(Float, Float)`:

```haskell
distanzaTuple :: ((Float,Float),(Float,Float)) -> Float
distanzaTuple (a,b) = sqrt (((fst a - fst b)^2) + ((snd a - snd b)^2))

distanza :: [(Float,Float)] -> Float
distanza a = foldr (\x acc -> acc + distanzaTuple x) 0 (zip a (tail a))

-- distanza [(0,0),(3,0),(3,4)] → 7.0  (3 + 4)
```

`zip a (tail a)` produce le coppie di punti consecutivi; su ciascuna coppia si calcola la distanza euclidea, poi si sommano con `foldr`.

---

## 23. Automi a Stati Finiti Generici

`generic_asf` modella un automa a stati finiti in modo generico: data una lista di input, uno stato iniziale, una **funzione di output** (Moore) e una **funzione di transizione di stato**, produce la lista di coppie `(output, nuovo_stato)`.

```haskell
generic_asf :: [a] -> s -> (a -> s -> o) -> (a -> s -> s) -> [(o, s)]
generic_asf [] _ _ _                    = []
generic_asf (leggo:leggero) stato msf snf =
    (msf leggo stato, snf leggo stato)
    : generic_asf leggero (snf leggo stato) msf snf
```

- `a` è il tipo dell'input (simbolo letto)
- `s` è il tipo dello stato
- `o` è il tipo dell'output
- `msf` (Moore State Function) calcola l'output dato input e stato corrente
- `snf` (State Next Function) calcola il nuovo stato

Esempio di utilizzo con le funzioni `sfnPari` e `mfsPari` definite nel codice:

```haskell
sfnPari 0 x   = x      -- stato 0: rimane nello stesso stato
sfnPari 1 'A' = 'B'    -- stato 1 con 'A': va in 'B'
sfnPari 1 'B' = 'A'    -- stato 1 con 'B': va in 'A'
```

---

## 24. Tipi di Dati Algebrici

Haskell permette di definire nuovi tipi con la parola chiave `data`. Questi tipi possono essere **ricorsivi** e hanno **costruttori** che fungono da pattern.

### Espressioni aritmetiche — `Expr`

```haskell
data Expr = Val Int
          | Add Expr Expr
          | Mul Expr Expr

-- Esempio: (2 + 3) * 4
esempio :: Expr
esempio = Mul (Add (Val 2) (Val 3)) (Val 4)

eval :: Expr -> Int
eval (Val n)   = n
eval (Add x y) = eval x + eval y
eval (Mul x y) = eval x * eval y

size :: Expr -> Int
size (Val n)   = 1
size (Add x y) = size x + size y
size (Mul x y) = size x + size y

-- eval esempio → 20
-- size esempio → 3  (numero di Val nella struttura)
```

Il tipo `Expr` è ricorsivo: `Add` e `Mul` contengono a loro volta altri `Expr`. Il pattern matching sui costruttori permette di navigare la struttura ad albero in modo naturale.

### Alberi binari — `Tree`

```haskell
data Tree a = Leaf a
            | Node (Tree a) a (Tree a)

-- Controlla se l'albero è bilanciato (ogni nodo ha 0 o 2 figli dello stesso tipo)
is_binary_trees :: Tree a -> Bool
is_binary_trees (Node (Node _ _ _) _ (Leaf _)) = False
is_binary_trees (Node (Leaf _) _ (Node _ _ _)) = False
is_binary_trees (Node (Leaf _) _ (Leaf _))     = True
is_binary_trees (Node left _ right)            =
    is_binary_trees left && is_binary_trees right
```

### Numeri naturali alla Peano — `Nat`

Una rappresentazione puramente strutturale dei numeri naturali: `Zero` corrisponde a 0, `Succ n` corrisponde a `n + 1`.

```haskell
data Nat = Zero | Succ Nat
    deriving (Show)

nat2int :: Nat -> Int
nat2int Zero     = 0
nat2int (Succ n) = 1 + nat2int n

int2nat :: Int -> Nat
int2nat 0 = Zero
int2nat n = Succ (int2nat (n-1))

-- Addizione ricorsiva
add :: Nat -> Nat -> Nat
add m n = int2nat (nat2int m + nat2int n)

-- Moltiplicazione ricorsiva (senza conversione)
multy :: Nat -> Nat -> Nat
multy n Zero     = Zero
multy n (Succ m) = add n (multy n m)
-- n * (Succ m)  =  n + n*m   (definizione ricorsiva standard)
```

`multy` mostra come si possa definire la moltiplicazione ricorsivamente senza mai convertire in `Int`: `n * 0 = 0` e `n * (m+1) = n + n*m`.

---

## 25. Applicazione: Metodo D'Hondt

Il **metodo D'Hondt** è un algoritmo proporzionale per l'assegnazione di seggi parlamentari. Per ogni partito si calcolano i quozienti `voti / 1`, `voti / 2`, `voti / 3`, … e si assegnano i seggi ai quozienti più alti.

```haskell
-- Genera la sequenza infinita di quozienti per ciascun partito
dHondt h = [ [(div v j, j) | v <- vs, j <- [1..]] | vs <- h ]

-- Assegna n seggi dato un insieme di quozienti (lista di liste ordinate)
seggii :: Int -> [[(Int, Int, Int)]] -> [(Int, Int, Int)]
seggii n h = take n . foldl1 merge $ zipWith tag h [1..]
  where
    tag xs i = map (\(x,j) -> (x,j,i)) xs
    merge [] ys = ys
    merge xs [] = xs
    merge (x:xs) (y:ys)
      | fst3 x >= fst3 y = x : merge xs (y:ys)
      | otherwise        = y : merge (x:xs) ys
    fst3 (v,_,_) = v
```

La funzione `seggi` nel codice usa un approccio alternativo con `foldr` per costruire una classifica ordinata dei quozienti, poi conta quanti seggi finiscono a ciascun partito.

---

## Riepilogo — Funzioni Utili

| Funzione | Descrizione |
|---|---|
| `head` / `tail` | Primo elemento / resto della lista |
| `reverse` | Inverte una lista |
| `length` | Lunghezza di una lista |
| `map f xs` | Applica `f` a ogni elemento |
| `filter p xs` | Mantiene gli elementi che soddisfano `p` |
| `foldr f z xs` | Riduzione da destra (`z` = valore iniziale) |
| `foldl f v xs` | Riduzione da sinistra (`v` = accumulatore) |
| `zip xs ys` | Unisce due liste in lista di coppie |
| `zipWith f xs ys` | Applica `f` agli elementi corrispondenti |
| `splitAt n xs` | Divide la lista al punto `n` |
| `elem x xs` | `True` se `x` appartiene a `xs` |
| `fst` / `snd` | Primo / secondo elemento di una coppia |
| `fromEnum` / `toEnum` | Conversione `Char` ↔ `Int` |
| `logBase b x` | Logaritmo di `x` in base `b` |
| `(f . g)` | Composizione: applica `g` poi `f` |
| `all p xs` | `True` se tutti gli elementi soddisfano `p` |
| `and xs` / `or xs` | AND / OR su lista di booleani |
| `take n xs` | Primi `n` elementi |
| `drop n xs` | Lista senza i primi `n` elementi |

---

```
Haskell è un linguaggio funzionale puro dove:
  - Tutto è una funzione
  - Non ci sono variabili mutabili
  - La ricorsione sostituisce i cicli
  - Il pattern matching rende il codice leggibile
  - Il currying permette l'applicazione parziale
  - I tipi garantiscono correttezza a compile-time
  - foldr costruisce dal fondo: f a (f b (f c z))
  - foldl accumula da sinistra: f (f (f v a) b) c
  - zip/zipWith permettono di lavorare su coppie di liste in parallelo
  - (.) compone funzioni in stile point-free
  - Le list comprehension combinano map e filter in sintassi leggibile
  - La lazy evaluation permette liste e strutture infinite
  - I tipi algebrici (data) modellano strutture ricorsive come alberi ed espressioni
  - I numeri di Peano mostrano come l'aritmetica possa derivare dalla struttura
```

> [!CAUTION]
> si noti tutto è stato scritto da zero, e poi rielaborato attraverso uso di LLM

