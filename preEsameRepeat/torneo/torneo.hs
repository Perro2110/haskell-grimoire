-- 8.40
-- 9.40 - pre refactoring
-- 10.10 se volessi fare refactor 

data Partita = Partita{scasa ::String, gcasa :: Int, sospite ::String, gospite :: Int}deriving(Show,Eq)
data RisultatoClassifica = RisultatoClassifica {nomesquadra :: String, punti :: Int, numReti::Int}deriving(Show,Eq)

parse :: [Char] -> Partita
parse str = let [a,b,c,d] = words str
            in Partita a (read b::Int) c (read d::Int)

uniq :: (Foldable t, Eq a) => t a -> [a]
uniq lista = foldr (\x acc -> if (elem x acc) then acc else x:acc) [] lista 

prendirisdatonome :: [RisultatoClassifica] -> String -> RisultatoClassifica
prendirisdatonome risultati nome = head [r | r <- risultati, nomesquadra r == nome]

partecipanti :: Partita -> [String]
partecipanti p = scasa p : sospite p : []

havefgol :: (Int -> Int -> Bool) -> Partita -> String
havefgol f partita 
                | f (gcasa partita) (gospite partita) = scasa partita
                | otherwise                           = sospite partita 

gol :: (Int -> Int -> Bool) -> Partita -> Int
gol f partita  -- se vuoi vincitore V == (>)
            | f (gcasa partita) (gospite partita) = gcasa partita
            | otherwise = gospite partita 

parity :: Partita -> Bool
parity partita = (gcasa partita == gospite partita)

newr :: RisultatoClassifica -> Int -> Int -> Int -> RisultatoClassifica
newr ris modif retif retis = RisultatoClassifica (nomesquadra ris) (punti ris+modif) ((numReti ris)+(retif - retis))

_aggris :: Partita -> [RisultatoClassifica] -> [RisultatoClassifica]
_aggris p risultati       = (newr (prendirisdatonome risultati (havefgol (<) p)) 0 (gol (<) p) (gol (>) p)):(newr (prendirisdatonome risultati (havefgol (>) p)) 3 (gol (>) p) (gol (<) p)):[r | r<-risultati, not (elem (nomesquadra r) (partecipanti p))]

_aggrisparity :: Partita -> [RisultatoClassifica] -> [RisultatoClassifica]
_aggrisparity p risultati = (newr (prendirisdatonome risultati (scasa p)) 1 (gcasa p) (gospite p)):(newr (prendirisdatonome risultati (sospite p)) 1 (gospite p) (gcasa p)):[r | r <- risultati, not (elem (nomesquadra r) (partecipanti p))] 

core :: Foldable t => t Partita -> [RisultatoClassifica] -> [RisultatoClassifica]
core partite risultati = foldr (\p acc-> if (parity p) then (_aggrisparity p acc) else (_aggris p acc)) risultati partite 

ms :: [RisultatoClassifica] -> [RisultatoClassifica]
ms []  = [] 
ms [x] = [x]
ms xs = merge (ms left) (ms right)
        where (left,right) = splitAt (div (length xs) 2) xs 

merge :: [RisultatoClassifica] -> [RisultatoClassifica] -> [RisultatoClassifica]
merge xs [] = xs 
merge [] ys = ys 
merge (x:xs) (y:ys) 
            | punti x > punti y = x:merge xs (y:ys)
            | punti x < punti y = y:merge (x:xs) ys
            | otherwise         = if (numReti x > numReti y) then x:merge xs (y:ys)
                                  else y:merge (x:xs) ys

parseout :: RisultatoClassifica -> [Char]
parseout ris = (nomesquadra ris) ++ " " ++(show(punti ris)) ++ " " ++ (show(numReti ris))

main :: IO ()
main = do 
    inpStr <- readFile "torneo.txt"
    let liness = lines inpStr
    let partite = map parse liness
        
    let nomisquadrec = map scasa partite
    let nomisquadreo = map sospite partite
    let nomisquadre = uniq (nomisquadrec ++ nomisquadreo)

    let ris = map (\s -> RisultatoClassifica s 0 0) nomisquadre
    let out = map parseout (ms (core partite ris))
    putStrLn (unlines out)