data Partito = Partito {numero :: Int, listaVoti :: [Float]}deriving (Show,Eq)

parse (numpart,voti) = Partito numpart voti 

dHondt v [] = []
dHondt v (j:js) = v / j : dHondt v js

mergep xs [] = xs 
mergep [] xs = xs
mergep (x:xs) (y:ys) 
            | numero x <= numero y    = x:mergep xs (y:ys)
            | otherwise               = y:mergep (x:xs) ys

mspart [] = []
mspart [x] = [x]
mspart ps = mergep (mspart left) (mspart right) where (left,right) = splitAt (div (length ps) 2) ps


--_inchepos n [] = [False]
--_inchepos n (l:lista)
--                    | n == l     = True:_inchepos n lista
--                    | otherwise  = False:_inchepos n lista
_inchepos n lista = foldr (\x acc -> if n == x then True:acc else False:acc) [False] lista

_trovaTrue lista n 
                    | lista !! n = n
                    | n >= (length lista) = -1
                    | otherwise  = _trovaTrue lista (n+1)

trovaTrue lista = _trovaTrue lista 0 

massimoelemento lista = foldr (\x acc -> if x >= acc then x else acc) 0 lista 
    
dovemassimoelemento [] = -1
dovemassimoelemento lista = (trovaTrue (_inchepos (massimoelemento lista) lista))

daiseggioapartitox partiti p = mspart ((Partito (numero p) (tail (listaVoti p))):[ps | ps <- partiti, p /= ps])

core partiti 0 = []
core partiti n = dovemassimoelemento (map head (map listaVoti partiti)): core (daiseggioapartitox partiti (partiti !! ( dovemassimoelemento (map head (map listaVoti partiti))))) (n-1)

parseout seggioapart ns = foldr (\x acc -> if x == ns then acc + 1 else acc) 0 seggioapart

main = do 
    let num_seggi   = 8 
    let voti        = [100000,80000,30000,20000] 
    let num_partiti = length voti 
    --print num_partiti
    let votiperpartito =  (map (\v -> take num_seggi (dHondt v [1..])) voti)
    print votiperpartito 
    let partiti = map parse (zip [1..] votiperpartito)
    let listadasom1 = core partiti num_seggi
    let seggioapart =  map (+1) listadasom1
    let out = map (\ns -> parseout seggioapart ns) [1..num_partiti]
    print out