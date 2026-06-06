double :: Num a => a -> a
double x = 2*x

quadruple :: Num a => a -> a
quadruple x = double(double x)

triple :: Num a => a -> a
triple x = x+x+x

add::(Int,Int) -> Int 
add (x,y) = x+y

zeroto :: Int -> [Int]
zeroto n = [0..n]

abs2 :: (Ord a, Num a) => a -> a
abs2 n  | n>=0 =n
        | otherwise = -n

fibo :: (Eq t, Num t, Num a) => t -> a
fibo 0 = 1
fibo 1 = 1
fibo n = fibo(n-1)+fibo(n-2)

lengthh :: Num a1 => [a2] -> a1
lengthh []=0
lengthh (e:rest)= 1 + lengthh (rest)

bmitTell weight height | bmi <= 18.5 = "underweight"
                       | bmi <= 25.0 = "normal"
                       | bmi <= 30.0 = "fat"
                       | otherwise = "very fat"
                    where bmi = weight/height^2

hd :: [a] -> a
hd (x:rest) = x

tl :: [a] -> [a]
tl (x:rest) = rest

infinity2 :: [Integer]
infinity2 = 2 : infinity2

---------------------------------  ES PARTE 1|----------------------------
-- head [1,2,3]
-- tail [1,2,3]

--ghci> [1,2,3,4,5,6] !! 2
--3

--ghci> take 5[1,2,3,4,5,6]
--[1,2,3,4,5]

------------------------------------------------------------------------------
-- Scrivere la definizione della funzione last che selezione l’ultimo
-- elemento di una lista usando le funzioni di libreria
-- last :: [a] -> a
------------------------------------------------------------------------------

last2 :: [a] -> a 
last2 a = a !! ((length a)-1)

last3 :: [a] -> a 
last3 (a:b) | (length b) /= 0 = last3 b
            | otherwise       = a

last4 :: [a] ->a  
last4 [a] = a
last4 (a:b) = last4 b 


---------------------------------------------------------------------------------------
--Scrivere la definizione della funzione init che rimuove l’ultimo elemento
--di una lista usando le funzioni di libreria
---------------------------------------------------------------------------------------

init2 :: [a] -> [a]
init2 a = (take ((length a)-1) a)

----------------------------------------------------------------------------------------
-- Che data una lista fornisce la lista inversa
-- Senza usare la funzione di libreria reverse 
----------------------------------------------------------------------------------------
inversa :: [a] -> [a]
inversa [] = []
inversa (a:b) = inversa b ++ [a]

zip2 :: [a]->[b]->[(a,b)]
zip2 (a:restDia) (c:restDic) = (a,c):zip2 restDia restDic
zip2 [] a =[]
zip2 a [] =[]
--zip2 [] [] =[]

eliminaPrimi :: [a] -> Int -> [a]
eliminaPrimi a 0 = a
eliminaPrimi (a:b) n = eliminaPrimi b (n-1)

-- [1 2 3 4 5] 3
-- [2 3 4 5] 2
-- [3 4 5] 1
-- [4 5] 0
-- [4 5]

concatena :: [a] -> [a] -> [a]
concatena [] a = a
concatena (a:b) c = a: concatena b c

replicante :: Int -> a -> [a]
replicante 1 a = [a] 
replicante n a = a:replicante (n-1) a  

marge :: Ord a => [a] ->[a]->[a] 
marge a [] = a
marge [] b = b 
marge (a:b) (c:d) | a<c       = a:marge b (c:d)
                  | otherwise = c:marge (a:b) d

msort :: Ord a=>[a]->[a]
msort a | (length a) <=1  =a
        | otherwise = marge (msort (take (div(length a) 2) a)) (msort(drop (div(length a) 2) a))

filterDiv3 :: Eq a =>Integral a => Real a => [a] -> [a]
filterDiv3 []=[]
filterDiv3 (a:b) | (mod a 3 /= 0) = filterDiv3 b
                 | otherwise      = a:filterDiv3 b

factorialll :: Int -> Int
factorialll n= foldr (*)1[1..n]

-------------------------------
-- Some library functions
-------------------------------
-- ▪ Decide if an integer is even:

-- even :: Integral a => a -> Bool
-- even n = n mod 2 == 0

-- ▪ Split a list at the nth element:

-- splitAt :: Int -> [a] -> ([a],[a])
-- splitAt n xs = (take n xs, drop n xs)


-------------------------------------------------------------------------------------------------
--Using library functions, define a function
--halve :: [a] -> ([a],[a])
--that splits an even-lengthed list into two halves. For example:
-- > halve [1,2,3,4,5,6]
-- ([1,2,3],[4,5,6])

halve :: [a] -> ([a],[a])
halve a | even (length a) == True = splitAt (div (length a) 2) a
        | otherwise               = halve (take ((length a)-1) a)   -- halve (concat [[a],[0]])

------------------------------------------------------------------------------------------------
--Define a function third :: [a] -> a that returns the third element in a list that
--contains at least this many elements using:
-- 1. head and tail;
-- 2. list indexing !!;
-- 3. pattern matching.

third0 :: [a] -> a
third0 a = head (reverse (take 3 a))

third1 :: [a] -> a
third1 a | (length a) < 3 = a !! ((length a)-1) --returno il piu vicino 
         | otherwise      = a !! 2

third2 :: [a] -> a 
third2 [a,b,c] = c
third2 a = third2 (take 3 a)

------------------------------------------------------------------------------------------
-- ▪ Define a recursive function sumdown :: Int -> Int that returns the sum of
--the non-negative integers from a given value down to zero. For example,
-- ▪ sumdown 3 should return the result 3+2+1+0 “ 6 .

sumdown :: Int -> Int
sumdown 0 = 0
sumdown a = a+sumdown (a-1)

------------------------------------------------------------------------------------------
-- ▪ Without looking at the definitions from the standard prelude, define the
--   following library functions on lists using recursion.

-- ▪ Decide if all logical values in a list are True:
--   and :: [Bool] -> Bool
-- ▪ Concatenate a list of lists:
--   concat :: [[a]] -> [a]
-- ▪ Select the nth element of a list:
--   (!!) :: [a] -> Int -> a
-- ▪ Decide if a value is an element of a list:
--   elem :: Eq a => a -> [a] -> Bool
-------------------------------------------------------------------------------------------

and2 :: [Bool] -> Bool
and2 [] = True
and2 (a:b) | a == True     = and2 b
           | otherwise     = False

concat2 :: [[a]] -> [a]
concat2 [] = []
concat2 (a:b) = a ++ concat2 b


nth :: (Eq t, Num t) => t -> [a] -> a
nth 0 (a:b) = a 
nth n (a:b) = nth (n-1) b  

elemm :: Eq a => a -> [a] -> Bool
elemm a [] = False
elemm a (b:c) | a == b      = True 
              | otherwise   = elemm a c

              
count :: Eq a => a -> [a] -> Int
count num [] = 0
count num (a:b) | a == num  = 1 + count num b
                | a /= num  = 0 + count num b

-------------------------------------------------------------------------------------------
-- ▪ Verifica se tutti gli elementi di una lista soddisfano un predicato:
--   all :: (a -> Bool) -> [Bool] -> Bool -ES- all (<10) [1,3,5,7,9]
-- ▪ Verifica se almeno un elemento di una lista soddisfa un predicato:
--   any :: (a -> Bool) -> [Bool] -> Bool -ES- any (>10) [1,2,3,4,5]
-- ▪ Seleziona gli elementi da una lista fintanto che soddisfano un predicato:
--   takeWhile :: (a -> Bool) -> [a] -> [a] -ES- takeWhile (odd) [9,5,6,2,12,32] 
-- ▪ Rimuovi gli elementi da una lista fintanto che soddisfano un predicato:
--   dropWhile :: (a -> Bool) -> [a] -> [a] -ES- dropWhile (odd) [9,5,6,2,12,32]
-------------------------------------------------------------------------------------------
dec2int :: [Int] -> Int
dec2int [] = 0
dec2int (a:b) = (a*10^(length(b)))+(dec2int b)

altMap a b [] = []
altMap a b (c:d)   = a c : altMap b a d


indovinoIlNumero :: (Ord a, Num a) => a -> String
indovinoIlNumero n | n < f     = "nop, il numero da indovinare e maggiore  !!"
                   | n == f    = "Hai vinto"
                   | n == 69    = "NOOO !! sporcaccione"
                   | n == 104   = "No il numero non e quello di paolo"
                   | otherwise  = "nop, il numero da indovinare e inferiore !!"
                     where f = 19


Mycount :: List -> Int
Mycount [] = 0 
Mycount [a|tail] = Mycount[tail] + 1 