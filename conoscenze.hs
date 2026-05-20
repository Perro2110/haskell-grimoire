-------------------------------------------------------------------------------
--                 generic functions 
-------------------------------------------------------------------------------


double :: Int -> Int 
double x = x + x

quadruple :: Int -> Int
quadruple x = double(double x)

mfactorial :: Int -> Int
mfactorial n = foldr (*) 1 [1..n]

last1 :: [a] -> a 
last1 a = head(reverse(a))

last2 :: [a] -> a 
last2 a = a !! ((length a)-1)

last3 :: [a] -> a 
last3 (a:b) | (length b) /= 0 = last3 b
            | otherwise       = a

last4 :: [a] -> a  
last4 [a]   = a
last4 (a:b) = last4 b 

lengthh []    = 0 
lengthh (a:b) = 1 + lengthh b

concatena :: [a] -> [a] -> [a]
concatena [] b    = b
concatena (a:b) c = a : concatena b c

concatenaTutte :: [[a]] -> [a]
concatenaTutte [] = []
concatenaTutte (a:b) = a ++ concatenaTutte b

andlist :: [Bool] -> Bool
andlist [] = True 
andlist (a:b)   | a          = andlist b 
                | otherwise  = False

ispos :: [Int] -> Bool
ispos [] = True 
ispos (a:b) | a >= 0         = ispos b 
            | otherwise      = False

ispos2 :: [Int] -> Bool
ispos2 [] = True
ispos2 a | head(a) > 0 = ispos2 (tail(a))
         | otherwise   = False

ispos3 :: [Int] -> Bool
ispos3 [] = True
ispos3 a = if head a > 0 then ispos3 (tail a) else False

elin :: Int -> [Int] -> Bool
elin a [] = False
elin a (h:t)    | a == h    = True 
                | otherwise = elin a t 

elemento :: Int -> [Int] -> Int
elemento 0 (x:_)  = x
elemento n (_:xs) = elemento (n - 1) xs

inverti :: [a] -> [a]
inverti [] = []
inverti (l:t) = inverti t ++ [l]

addVect :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVect a b = (fst a + fst b , snd a + snd b) 

abs :: Int -> Int
abs n | n < 0     = -n
      | otherwise = n

safetail :: [a] -> [a]
safetail [] = []
safetail (a:b) = b

or :: Bool -> Bool -> Bool
or True _ = True 
or _ True = True 
or _ _ = False 

orInteligente :: Bool -> Bool -> Bool
orInteligente False False = False
orInteligente _ _ = True

-- and :: Bool -> Bool -> Bool
-- and True True = True 
-- and _ _ = False 

nsucc :: Char -> Int -> Char
nsucc c n = toEnum (fromEnum c + n)

cypher :: [Char] -> Int -> [Char]
cypher a num = map (\x -> nsucc x num) a 

cypher2 :: [Char] -> Int -> [Char]
cypher2 [] n = []
cypher2 (a:b) n = nsucc a n : cypher2 b n

quadList :: [Int] -> [Int]
quadList [] = []
quadList (a:b) = a*a : quadList b

qadListConMap :: [Int] -> [Int]
qadListConMap a = map (\x -> x*x) a

acronimo :: [String] -> [Char]
acronimo [] = []
acronimo (a:b) = head a : acronimo b

acronimoqithmap :: [String] -> [Char]
acronimoqithmap a = map (\x -> head x) a

lunghezze :: [[a]] -> [Int]
lunghezze [] = []
lunghezze (a:b) = (length a) : lunghezze b

lunghezzeconmappa :: [[a]] -> [Int]
lunghezzeconmappa a = map (\x -> length x) a

positivi :: [Int] -> [Int]
positivi [] = []
positivi (a:b) 
    | a > 0     = a : positivi b
    | otherwise = positivi b

positivii :: [Int] -> [Int]
positivii a = filter (\x -> x > 0) a

corte :: [[Char]] -> [[Char]]
corte [] = []
corte (a:b) 
    | (length a) < 4 = a : corte b
    | otherwise      = corte b

cortee :: [[Char]] -> [[Char]]
cortee a = filter (\x -> length x < 4) a

inn :: Char -> [Char] -> Bool
inn _ [] = False
inn x (a:b) 
    | x == a    = True
    | otherwise = inn x b

vocali :: [Char] -> [Char]
vocali [] = []
vocali (a:b) 
    | inn a "aeiou" = a : vocali b
    | otherwise     = vocali b

volaiconfilter :: [Char] -> [Char]
volaiconfilter a = filter (\x -> inn x "aeiou") a

quadMat :: [[Int]] -> [[Int]]
quadMat [] = []
quadMat a = map(\x -> map(\y -> y * y) x) a 

eclama :: [String] -> [String]
eclama [] = []
eclama (a:b) = reverse('!':reverse(a)):eclama b

pollo :: [String] -> [String]
pollo a = map (\x -> reverse('!':reverse(x))) a

verificaPari :: [Int] -> [Bool]
verificaPari a = map (\ x -> mod x 2 == 0) a

incrList :: [Int] -> [Int]
incrList a = map (\x -> x + 1) a

-- Il currying in Haskell è il meccanismo per cui ogni funzione accetta un solo
--  argomento alla volta, restituendo una nuova funzione per ogni argomento 
-- successivo.

-- Moltiplicazione
multiply :: Int -> Int -> Int
multiply x y = x * y

double2 = multiply 2
triple2 = multiply 3

-- Con le funzioni di lista
addOne = map (+1)

greaterThan5 = filter (>5)

-- provo a riscrivere gravity usando il currying
-- Write the function gravity that, given a mass
-- m1, a distance d, and a mass m2, computes the gravitational force
gravity :: Float -> Float -> Float -> Float  
gravity m1 d m2 = ((6.67 * 1/10^(11)) * (m1 * m2)) / (d * d)
-- Write the function earthGravity that, given a mass and a distance, computes 
-- the gravitational force of the Earth on the mass
earthGravity :: Float -> Float -> Float 
earthGravity = gravity (5.972 * 10^24)

-- Write a function earthGravitySurface that
-- computes the weight of a mass on the surface of
-- the Earth
earthGravitySurface = earthGravity 6371000

log2 :: Float -> Float
log2 = logBase 2

-- Sections
rec :: Float -> Float
rec = (1/)

-- uso della zip

corrispondenze listaA listaB = filter (\(x, y) -> x == y) (zip listaA listaB)


-------------------------------------------------------------------------------
--                 foldr (associativita a destra) e foldl 
-------------------------------------------------------------------------------

-- sum []    = 0  
-- sum (a:b) = a + b 

-- prod []    = 1  
-- prod (a:b) = a * b 

foldrr f x [] = x 
foldrr f x (a:b) = f a (foldrr f x b)

sumf a = foldr (+) 0 a 

prod a = foldr (*) 1 a

----------------
s :: [Int] -> Int
s = foldr (+) 0

p :: [Int] -> Int
p = foldr (*) 1

o :: [Bool] -> Bool
o = foldr (||) False

aa :: [Bool] -> Bool
aa = foldr (&&) True

--                         x prende elemento a 
--                           n prende lo 0 
lengthfoldosa a = foldr (\ x n -> n + 1) 0 a

--  Vocali
vocalii :: [Char] -> Int 
vocalii a = foldr (\ x n -> if (elem x "aeiou") then n + 1 else n) 0 a

-- Controllo password
-- 1. Lunghezza maggiore di 15
-- 2. Almeno una lettera minuscola
-- 3. Almeno una lettera maiuscola
-- 4. Almeno un numero

checckers_1 :: [Char] -> Bool
checckers_1 a 
            | (foldr (\ x n -> n + 1) 0 a) > 15 = True 
            | otherwise = False  


checckers_2 :: [Char] -> Bool
checckers_2 a 
            | (foldr (\ x n -> if (elem x ['A'..'Z']) then n + 1 else n) 0 a) > 1 = True 
            | otherwise = False 


checckers_3 :: [Char] -> Bool
checckers_3 a 
            | (foldr (\ x n -> if (elem x ['a'..'z']) then n + 1 else n) 0 a) > 1 = True 
            | otherwise = False 


checckers_4 :: [Char] -> Bool
checckers_4 a 
            | (foldr (\ x n -> if (elem x ['1'..'9']) then n + 1 else n) 0 a) > 1 = True 
            | otherwise = False 

funandmap :: [(a -> Bool)] -> a -> Bool           
funandmap [] b = True
funandmap (a:at) b = a b && funandmap at b 

checker :: [Char] -> Bool
checker a = funandmap [checckers_4,checckers_3,checckers_2,checckers_1] a

checker_lite :: [Char] -> Bool
checker_lite a 
    | ((foldr (\ x n -> n + 1) 0 a) > 15) && (foldr (\ x n -> elem x ['a'..'z'] || n) False a) = True 
    | otherwise = False


checker_litee :: [Char] -> Bool
checker_litee a =  ((foldr (\ x n -> n + 1) 0 a) > 15) &&
                   (foldr (\ x n -> elem x ['a'..'z'] || n) False a) &&
                   (foldr (\ x n -> elem x ['A'..'Z'] || n) False a) &&
                   (foldr (\ x n -> elem x ['0'..'9'] || n) False a) 

--------------------------------------------------------------------------------
--                  foldl (associatività a sinistra)
--------------------------------------------------------------------------------

foldll f v [] = v 
foldll f v (x:xs) = foldll f (f v x) xs


-- notice difference between foldr and foldl

-- FOLD (+) 0 [1,2,3]

foldR f x [] = x 
foldR f x (a:b) = f a (foldR f x b)
-- 1+(2+(3+0)) = 6

foldL f v [] = v
foldL f v (x:xs) = foldL f (f v x) xs
-- ((0+1)+2)+3 = 6 

--------------------------------------------------------------------------------
--- Comongo le funzioni cazzo 
--------------------------------------------------------------------------------

oddd :: Int -> Bool
oddd = not . even


zipWithh :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWithh f [] a = [] 
zipWithh f a [] = [] 
zipWithh f (a:b) (c:d) = f a c : zipWithh f b d 

-- returna se ordinato usando zipWith
-- [1,2,3]
-- [2,3]
ordinato :: (Ord a) => [a] -> Bool
ordinato a = all (\ x -> x == True) (zipWith (<=) a (tail a))

otherordinato :: (Ord a) => [a] -> Bool
otherordinato a = and (zipWith (<=) a (tail a))



maxff f [] a = a 
maxff f (x:xs) a | f x >= a  = maxff f xs x   
                 | otherwise = maxff f xs a 

-- foldrr f x [] = x 
-- foldrr f x (a:b) = f a (foldrr f x b)

maxf f (a:b) = foldr (\x y -> if f x >= f y then x else y) a b 


remdups :: (Eq a) => [a] -> [a]
remdups [] = []
remdups [a] = [a]
remdups (a:b:xs) | a == b    = remdups (b:xs)
                 | otherwise = a : remdups (b:xs)   

remdupsf :: (Eq a) => [a] -> [a]
remdupsf [] = []
remdupsf (a:as) = foldr (\x acc -> if x == head acc then acc else x:acc) [a] as


distanzaTuple :: ((Float, Float),(Float, Float)) -> Float
distanzaTuple (a,b) = sqrt ((((fst a) - (fst b))^2) + (((snd a) - (snd b))^2))

distanza :: [(Float, Float)] -> Float
distanza a = foldr (\x acc -> acc + distanzaTuple x) 0 (zip a (tail a))

-- LIST COMPRENSION

-- [(x,y) | y <- [4,5], x <- [1,2,3]]
-- [(1,4),(2,4),(3,4),(1,5),(2,5),(3,5)] 

-- [(x,y) | x <- [1..3], y <- [x..3]]
-- [(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)]

pitagorica n = [[x*y | x <- [1..n] ]| y <- [1..n]]

merge :: (Ord a) => [a] -> [a] -> [a]
merge a [] = a
merge [] a = a
merge (a:b) (c:d) | a < c       = a : merge b (c:d) 
                  | otherwise   = c : merge (a:b) d 

mergeSort :: (Ord a) => [a] -> [a]
mergeSort [] = []
mergeSort [a] = [a]
mergeSort a = let (l,r) = splitAt (length a `div` 2) a in merge (mergeSort l) (mergeSort r) 

taxicab :: [Int]
taxicab = [ n | n <- [1..] , length (coppie n) >= 2 ]

coppie :: Int -> [(Int,Int)]
coppie n = [ (x,y) | x <- [1..n] , y <- [x+1..n] , x^3 + y^3 == n ]

--------------------------------------------------------------------------------
--                          leazy evaluation                                  --
--------------------------------------------------------------------------------

-- Eager evaluation (or strict evaluation ) è un paradigma di valutazione in cui
-- le espressioni vengono valutate non appena vengono incontrate, 
-- indipendentemente dal fatto che il loro valore sia effettivamente necessario
-- per il risultato finale del programma. In questo modello, tutte le operazioni 
-- vengono eseguite immediatamente, e i risultati vengono memorizzati in variabili 
-- o restituiti direttamente.


uniq [] = []
uniq (a:as) = a : filter (/= a) (uniq as)


-- [x*2 | x -> _hamming]

_hamming = 1 : merge (map (*2) hamming) 
                      (merge (map (*3) hamming) (map (*5) hamming))

hamming = uniq _hamming

seggi :: Int -> [Int] -> [Int]
seggi s voti = map contaSeggi [0..length voti - 1]
  where
    quozienti = [ (fromIntegral v / fromIntegral j, i)
                | (v, i) <- zip voti [0..]
                , j      <- [1..s] ]

    top = take s
        $ foldr (\(q,i) acc -> insertDesc (q,i) acc) [] quozienti

    insertDesc x []     = [x]
    insertDesc x (y:ys)
      | fst x >= fst y  = x : y : ys
      | otherwise        = y : insertDesc x ys

    contaSeggi i = length $ filter ((== i) . snd) top

--------------------------------------------------------------------------------

dHondt h = [ [(div v j, j) | v <- vs, j <- [1..]] | vs <- h ]


seggii :: Int -> [[(Int, Int)]] -> [(Int, Int, Int)]
seggii n h = take n . foldl1 merge $ zipWith tag h [1..]
  where
    tag xs i = map (\(x,j) -> (x,j,i)) xs
    merge [] ys = ys
    merge xs [] = xs
    merge (x:xs) (y:ys)
      | fst3 x >= fst3 y = x : merge xs (y:ys)
      | otherwise         = y : merge (x:xs) ys
    fst3 (v,_,_) = v


--------------------------------------------------------------------------------



--sfnPari c S 
sfnPari 0 x = x
sfnPari 1 'A' = 'B'
sfnPari 1 'B' = 'A' 

mfsPari 1 'A' = 'd'
mfsPari 0 'A' = 'p'
mfsPari 1 'B' = 'p'
mfsPari 0 'B' = 'd'


generic_asf:: [a] -> s -> (a->s->o) -> (a -> s -> s) -> [(o, s)]
generic_asf [] _ _ _ = []
generic_asf (leggo:leggero) stato msf snf = (msf leggo stato, snf leggo stato) : generic_asf leggero (snf leggo stato) msf snf


--------------------------------------------------------------------------------


-- Val :: Int -> Expr
-- Add :: Expr -> Expr -> Expr
-- Mul :: Expr -> Expr -> Expr

data Tree a = Leaf a 
            | Node (Tree a) a (Tree a)

is_binary_trees :: Tree a -> Bool
is_binary_trees (Node (Node _ _ _) _ (Leaf _)) = False
is_binary_trees (Node (Leaf _) _ (Node _ _ _)) = False
is_binary_trees (Node (Leaf _) _ (Leaf _)) = True
is_binary_trees (Node left _ right) = is_binary_trees left && is_binary_trees right

t:: Tree Int
t = Node (Node (Leaf 1) 3 ((Node (Leaf 6) 7 (Leaf 9)))) 5 (Node (Leaf 6) 7 (Leaf 9))


size :: Expr -> Int
size (Val n) = 1
size (Add x y) = size x + size y
size (Mul x y) = size x + size y

eval :: Expr -> Int
eval (Val n) = n
eval (Add x y) = eval x + eval y
eval (Mul x y) = eval x * eval y

data Expr = Val Int
            | Add Expr Expr
            | Mul Expr Expr


add :: Nat -> Nat -> Nat
add m n = int2nat (nat2int m + nat2int n)

mult :: Nat -> Nat -> Nat
mult m n = int2nat (nat2int m * nat2int n)

multy :: Nat -> Nat -> Nat
multy n Zero     = Zero
multy n (Succ m) = add n (multy n m)  


nat2int :: Nat -> Int
nat2int Zero = 0
nat2int (Succ n) = 1 + nat2int n

int2nat :: Int -> Nat
int2nat 0 = Zero
int2nat n = Succ (int2nat (n-1))

data Nat = Zero | Succ Nat
    deriving (Show) 

--------------------------------------------------------------------------------
-- La regola deve essere fatto da un char e una stringa 

data Regola = Regola [Char] [Char]
    deriving (Show)


prendiChar :: Regola -> [Char]
prendiChar (Regola c _) = c

prendiString :: Regola -> [Char]
prendiString (Regola _ s) = s

-- definisco un esmepio di regola
regolaEsempio :: Regola
regolaEsempio = Regola "Z" "zucchero"

genera :: [Regola] -> [Char] -> [Char]
genera [] str = str
genera _ [] = []
genera (r:regole) (a:b)
    | prendiChar r == [a] = prendiString r ++ genera (r:regole) b
    | otherwise           = genera regole (a:b)

-------------------------------------------------------------------------------
--                input output
-------------------------------------------------------------------------------
myecho :: IO ()
myecho = getChar >>= (\c -> putChar c)

myechodup = getChar >>= \c -> putChar c >> putChar c

echotw = myecho >> myecho 

------------------------------------------------------------------------------------------------------------
--                              Alberi di derivazione                         --
------------------------------------------------------------------------------------------------------------



-- leggiInt  :: IO Int
-- stampaInt :: Int -> IO ()

-- (\x -> x+1)
-- bind
-- >>= :: IO a -> (a->IO b) -> IO b

-- return :: a -> IO a

-- >>= ( >>= (leggiInt) (\x -> return x+1) ) stampaInt


-- esdo = do {c1 <- getChar;c2<- getChar; return (c1,c2)}

-- esempio do notation 

main = do
    c <- getChar
    let c1 = succ c -- uso let e non <- perche non monade dio
    putChar c1
    putChar '\n'


repeatN :: Int -> IO () -> IO () 
repeatN 0 a = return ()
repeatN n a = do
  a
  repeatN (n-1) a


for xs fa = sequence (map fa xs) >> return ()

main2 = do
   sequence (map print [1,2])


main3 = do
  putStrLn "quit the program? y/n"
  ans <- getLine
  if ans /= "y" then do
    putStrLn "not quitting"
    main3
  else return ()
