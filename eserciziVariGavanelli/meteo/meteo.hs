-- 16:10
-- 17:50

data Misura = Misura{nomeCitta::String,temperature::[Int]}deriving(Show,Eq)

parse misurazioni = (Misura (head misurazioni) (map (\x -> read x ::Int) (tail misurazioni)))

ms :: Ord a1 => [(a2, a1)] -> [(a2, a1)]
ms [] = [] 
ms [x] = [x]
ms xs = merge (ms left) (ms right)
        where (left,right) = splitAt (div (length xs) 2) xs

merge :: Ord a1 => [(a2, a1)] -> [(a2, a1)] -> [(a2, a1)]
merge xs [] = xs 
merge [] ys = ys 
merge (x:xs) (y:ys) 
            | (snd x) > (snd y)     = x:merge xs (y:ys)
            | otherwise = y:merge (x:xs) ys

outs (x,y) = x ++ " " ++ show y
outs2 (x,y,z) = x ++ " " ++ show y

somma :: (Foldable t, Num b) => t b -> b
somma lista = foldr (\x acc -> acc + x) 0 lista 

media :: (Integral a, Foldable t) => t a -> Float
media lista =  (fromIntegral (somma lista) :: Float) / (fromIntegral (length lista) :: Float)

prendilistacritica :: (Foldable t, Integral b, Num a1, Ord a1) => t (a2, b) -> a1 -> [a2]
prendilistacritica xs med = foldr (\x acc-> if ((fromIntegral (snd x)) >= med) then (fst x):acc else acc ) [] xs 

prendiorecritiche :: (Foldable t, Integral b, Num c, Ord c) => (a1, t (a2, b)) -> c -> (a1, [a2], c)
prendiorecritiche (nome,lista) tmed = (nome,(prendilistacritica lista tmed),tmed)

flat :: Foldable t => t [a] -> [a]
flat = foldr (++) []  

_eanonima :: (Ord t, Num t) => [t] -> t -> [Bool]
_eanonima [] ele       = [False]
_eanonima (l:list) ele 
                    |   l >= ele+5 = True:_eanonima list l
                    |   otherwise  = False:_eanonima list l

verificaanomalia :: (Ord t, Num t) => [t] -> Bool
verificaanomalia ls = or(_eanonima ls (head ls))

--prenditemperatureadorariox [] orario = []
--prenditemperatureadorariox (m:misure) orario = (temperature m) !! orario : prenditemperatureadorariox misure orario
prenditemperatureadorariox :: Foldable t => t Misura -> Int -> [Int]
prenditemperatureadorariox mss orario = foldr (\m acc -> (temperature m) !! orario:acc) [] mss


main = do 
    inpstr <- readFile "misure.txt"
    let liness = lines inpstr
    let lw = map words liness
    let misure = map parse lw 
    --print misure
    putStrLn "1. Escursione termica per stazione: "
    let temp = (map (\(nome,ts)-> (nome,(maximum ts) - (minimum ts))) (zip (map nomeCitta misure) (map temperature misure)))
    let tempord = (ms temp)
    putStrLn (unlines((map outs tempord)))

    putStrLn "2. Ore critiche GENERALE:"
    let mediaa = media (flat (map temperature misure))
    putStrLn ("con media in C:" ++ " " ++(show mediaa))
    let numore = length (temperature (head misure))
    let p = map media (map (\o-> prenditemperatureadorariox misure o) [0..(numore-1)])
    let critiche = map (\(torario,o) -> if (torario > mediaa) then (show o) else "-") (zip p [1..])
    putStrLn (unwords (filter (/="-") critiche))
   
    putStrLn "2. Ore critiche per luogo:"
    putStrLn ("con media in C:" ++ " " ++(show mediaa))
    let temperatureinvariorari =  map (\m-> (nomeCitta m,(zip [1..] (temperature m)))) misure 
    let valorimag = map (\xx -> prendiorecritiche xx mediaa) temperatureinvariorari 
    putStrLn (unlines((map outs2 valorimag)))
    
    --print valorimag
    putStrLn "2b. Stazioni anomale:"
    let anomalie = filter (/= "-") (map (\m-> if (verificaanomalia (temperature m)) then nomeCitta m else "-") misure)
    if (verificaanomalia (flat (map temperature misure))) then (putStrLn (unlines(anomalie))) else print "nessuna anomala"
