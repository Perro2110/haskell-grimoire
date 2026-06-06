
ultimo1 :: [a] -> a
ultimo1 a = head (reverse a)

ultimo2 :: [a] -> a
ultimo2 a = a !! ((length a)-1)

rimuoviUltimo :: [a] -> [a]
rimuoviUltimo a = take ((length a)-1) a

inversa :: [a] -> [a]
inversa [] = []
inversa (a:b) = inversa b ++ [a]

zippp :: [a] -> [b] -> [(a,b)]
zippp [] [] = []
zippp a []  = []
zippp [] a  = []
zippp (a:b) (c:d) = [(a,c)] ++ zippp b d

eliminaPrimi :: [a] -> Int -> [a]
eliminaPrimi a num = drop ((length a) - (num-1)) a

eliminaPrimiN :: [a] -> Int -> [a]
eliminaPrimiN a 0 = a
eliminaPrimiN (a:b) num = eliminaPrimiN b (num-1)

concatena :: [a] -> [a] -> [a]
concatena a [] = a
concatena [] a = a
concatena (a:b) c = a:concatena b c

replicatee :: Int -> a -> [a]
replicatee 1 v = [v]
replicatee n v = v : replicatee (n-1) v

mergeSimpson :: Ord a=> [a] -> [a] -> [a]
mergeSimpson [] a = a
mergeSimpson a [] = a
mergeSimpson (a:b) (aa:bb)   | a < aa    = a:(mergeSimpson b (aa:bb))
                             | otherwise = aa:(mergeSimpson (a:b) bb)

msort1 :: Ord a=> [a] -> [a]
msort1 a | (length a <= 1) = a
         | otherwise       = mergeSimpson (msort1 (take (div (length a) 2) a)) (msort1 (drop (div (length a) 2) a))


filterDiv3 :: Eq a =>Integral a => Real a => [a] -> [a]
filterDiv3 [] = []
filterDiv3 (a:b) | mod a 3 /= 0         = filterDiv3 b
                 | otherwise            = a:filterDiv3 b

factoriall :: Int -> Int
factoriall 0 = 1
factoriall 1  = 1
factoriall n = n*factoriall (n-1)

factoriale :: Int -> Int
factoriale 0 = 1
factoriale 1 = 1
factoriale a = product [2..a]


---------------------------------
-- Decide if an integer is even:
pari :: Integral a => a -> Bool

pari n | (mod n 2) == 0 = True
       | otherwise      = False

--Split a list at the nth element:
splitAtt :: Int -> [a] -> ([a],[a])
splitAtt n a = (take n a , drop n a)

halvee :: [a] -> ([a],[a])
halvee a = splitAtt 2 a

halve2 :: [a] -> ([a],[a])
halve2 a = (take 2 a , drop 2 a)

third1 :: [a] -> a
third1 a = a !! 2

third2 :: [a] -> a
third2 a = head (tail (tail a))

third3 :: [a] -> a
third3 (a:b:c:d) = c

sumdown :: Int -> Int
sumdown 0 = 0
sumdown n = n + sumdown (n-1)

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

and1 :: [Bool] -> Bool
and1 [] = True
and1 (a:b) | a == True = and1 b
           | otherwise = False

concat1 :: [[a]] -> [a]
concat1 (a:b) = a ++ concat b


puntiEscalmativi :: (Eq t, Num t) => t -> [a] -> a
puntiEscalmativi 0 a = head a
puntiEscalmativi n (a:b) = puntiEscalmativi (n-1) b

elemm :: Eq a => a -> [a] -> Bool
elemm e []                 = True
elemm e (a:b) | e == a     = elemm e b
              | otherwise  = False

-- define a function that counts the number of times that a given value
-- occurs in a list, for any type whose values can be compared for equality

count :: (Num a, Eq t) => t -> [t] -> a
count e []                 = 0
count e (a:b) | e == a     = 1+count e b
              | otherwise  = 0+count e b


-- Without looking at the definitions from the standard prelude, define the
--  following higher-order library functions on lists.
-- • Decide if all elements of a list satisfy a predicate:
--     all :: (a -> Bool) -> [Bool] -> Bool

alll :: (t -> Bool) -> [t] -> Bool
alll p []     = True
alll p (a:b)  | p a = alll p b
              | otherwise = False

-- • Decide if any element of a list satisfies a predicate:
--     any :: (a -> Bool) -> [Bool] -> Bool



anyy :: (t -> Bool) -> [t] -> Bool
anyy p []     = False
anyy p (a:b)  | p a == False = anyy p b
              | otherwise    = True

-- • Select elements from a list while they satisfy a predicate:
--     takeWhile :: (a -> Bool) -> [a] -> [a]


takeWhile1 :: (a -> Bool) -> [a] -> [a]
takeWhile1 p [] = []
takeWhile1 p (a:b) | p a       = a:takeWhile1 p b
                   | otherwise =   takeWhile1 p b


-- • Remove elements from a list while they satisfy a predicate:
--     dropWhile :: (a -> Bool) -> [a] -> [a]

dropWhile1 :: (a -> Bool) -> [a] -> [a]
dropWhile1 p [] = []
dropWhile1 p (a:b) | p a == False = a: dropWhile1 p b
                   | otherwise    = dropWhile1 p b

-- Using foldl, define a function dec2int :: [Int] -> Int that converts a
-- decimal number into an integer. For example:
-- > dec2int [2,3,4,5]
-- 2345

dec2int :: Num a => [a] -> a
dec2int [] = 0
dec2int (a:b) = a*10^length (b) + dec2int b


decTwoInt :: (Foldable t, Num b) => t b -> b
decTwoInt a = foldl (\x y -> 10*x + y) 0 a

-- 0 [1,2,3]
-- 0*10 +1     = 1 [2,3]
-- 1*10 +2     = 12 [3]
-- 12*10+3     = 123 []

-- altMap (+10) (+100) [0,1,2,3,4]
-- [10,101,12,103,14]
altMap1 :: (a -> b) -> (a -> b) -> [a] -> [b]
altMap1 p q [] = []
altMap1 p q (a:b) = p a : altMap1 q p b







