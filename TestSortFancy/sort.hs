import Data.Binary.Get (label)
marge :: Ord a => [a] ->[a]->[a] 
marge a [] = a
marge [] b = b 
marge (a:b) (c:d) | a<c       = a:marge b (c:d)
                  | otherwise = c:marge (a:b) d

msort :: Ord a=>[a]->[a]
msort a | (length a) <=1  =a
        | otherwise = marge (msort (take (div(length a) 2) a)) (msort(drop (div(length a) 2) a))


minore :: Ord t => t -> [t] -> t
minore m [] = m
minore m (a:b) | m > a      = minore a b
               | otherwise  = minore m b

  -- BINGO
ssort :: (Ord a, Num a) => [a] -> [a]
ssort [] = []
ssort a = minore 90000 a : ssort (filter (/= minore 90000 a) a ) 


--balgo :: Ord a => [a] -> Bool
--balgo (a:[]) = False
--balgo (a:b:c) | a < b     = True
--              | otherwise = False

--bSORT :: Ord a => [a] -> [a]   -- QUELLO CHE USERAI
--bSORT a = bBsortInterno 1000 a

--bBsortInterno :: (Num t, Ord a, Eq t) => t -> [a] -> [a]
--bBsortInterno 0 a = bsort a
--bBsortInterno n a = bBsortInterno (n-1) (bsort a)

hd :: [a] -> a
hd (x:[]) = x
hd (x:r) = x

balgo2 :: Ord a => [a] -> Bool -- CONTROLLA SE IN ORDINE 
balgo2 [] = True
balgo2 (a:[])=True
balgo2 (a:b) | a < (b !! 0) = balgo2 b
             | otherwise  = False


bsort :: Ord a => [a] -> [a] -- PROVA A ORDINARE
bsort  [] = []
bsort [a] = [a]
bsort  a       |  balgo2 a       == True = (a)!!0 : bsort (filter(/= ((a)!!0)) a)
               |  otherwise              = (a)!!1 : bsort (filter(/= ((a)!!1)) a)

bSORT2 :: Ord a => [a] -> [a] -- ORDINA 
bSORT2 a | balgo2 a == True = a
         | otherwise        = bSORT2 (bsort a)


--------------------------------------------------------------------------
--------- [1,65,3,2,100,4]                                               |
--------- [100,2,3,65,1,4]                                               |
--------- [100,65,3,2,1,4]                                               |
--------- [100,65,4,1,2,3]                                               |
--------- [100,65,4,3,2,1]                                               |
--                                                                       |
--                                                                       |                                                              
--                                                                       |                 
--                                      ██▒▒▒▒██▒▒████                   |                 
--                                  ████▒▒▒▒      ▒▒██████               |                 
--                                ████▒▒▒▒        ▒▒▒▒████               |                 
--                                ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██               |                 
--                                ░░▒▒▒▒██████▒▒██████▒▒▒▒               |                 
--                            ▒▒▒▒██▒▒▒▒░░░░▒▒▒▒░░░░░░░░▒▒▒▒▒▒           |                 
--                          ▒▒▒▒▒▒░░██▒▒▒▒██▒▒▒▒████████▒▒▒▒▒▒▒▒         |                 
--                          ▒▒▒▒▒▒██░░▒▒▒▒░░░░▒▒░░░░░░░░██▒▒▒▒▒▒         |                 
--                          ▒▒▒▒▒▒░░██▒▒██████▒▒████████░░▒▒▒▒▒▒         |                 
--                          ▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░▒▒░░░░░░░░▒▒▒▒▒▒▒▒         |                 
--                          ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒         |                 
--                            ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒           |                 
--                              ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒             |                
--                                                                       |
--------------------------------------------------------------------------


isOrd :: Ord a => [a] -> Bool  -- CONTROLLA SE IN ORDINE 
isOrd  []     = True
isOrd  (a:[]) =True
isOrd  (a:b) | a < (b !! 0) = isOrd  b
             | otherwise  = False

maxN :: (Num t1, Ord t2, Eq t1) => t1 -> t1 -> t2 -> [t2] -> t1
maxN d c m [] | d == 0    = 0
              | otherwise = (d)
maxN d c m (a:b) | m < a      = maxN (c+1) (c+1) a b
                 | otherwise  = maxN d (c+1) m b


iMaxN :: (Ord t, Num t) => Int -> [t] -> t
iMaxN i l = maxN 0 0 (-42) (take i l)             


flipAt :: Int -> [a] -> [a]
flipAt i lista = reverse(take i lista) ++ drop i lista

gIsort :: [Int] -> [Int]
gIsort l = flipAt (iMaxN ((length l)) l) l


panSort :: (Eq t, Num t) => t -> [Int] -> [Int]
panSort 0 a = a
panSort n a = head (gIsort a): panSort (n-1) (tail (gIsort a))  

panckake_sort :: [Int] -> [Int]
panckake_sort l = panSort (length l) l



