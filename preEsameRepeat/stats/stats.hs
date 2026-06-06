data Statistiche = Statistiche {cognome :: String, risposte :: [Float]}deriving(Show,Eq)


parse (c:r) = Statistiche c (map read r)

dammiMax stats id = foldr (\s acc -> if (((risposte acc) !! id ) <= ((risposte s) !! id)) then s else acc) (head stats) stats



daiclassificatatoid [] idD = []                                                 -- averi potuto usare anche una filter rispetto list comprehensions
daiclassificatatoid (s:stats) idD = (dammiMax (s:stats) idD): daiclassificatatoid [stati | stati <- (s:stats), stati /= (dammiMax (s:stats) idD)] idD


generaoutputstr nd classifica = "Domanda " ++ (show nd) ++ ": " ++ (unwords (map cognome classifica))

main = do 
    -- Input
    -- Estraggo info da file txt 
    inpStr <- readFile "stats.txt"
    let liness = lines inpStr
    let ww = map words liness
    let sta = map parse ww
    
    -- Solo per comodita preferisco tenermi in lista apparte il numero di domande
    -- ed elenco di queste 
    let numDomande = length (risposte (head sta))
    let idDomande = [1..numDomande]

    -- Genero con funzione di ordine superiore (map) per ogni idDomanda in idDomande
    -- la sua classifica e metto questa in una lista di classifiche 
    let classificheperdomanda = map (\ids -> daiclassificatatoid sta (ids-1)) idDomande

    -- Ad ogni classifica salvo a quale domanda appartiene (utile per stampa)
    -- Se avessi dovito fare piu che solo stampare sarebbe stato comoda una seconda 
    -- struttura probabilmente fatta da id e lista di stat
    let zcd = zip idDomande classificheperdomanda
    
    -- per ogni tupla (domanda) e sua classifica usando funzione di ordine superiore (map)
    -- genero la stringa adatta al output e la inserisco in lista apposita 
    let o = map (\(nd,classifica) -> generaoutputstr nd classifica) zcd

    -- Output
    putStrLn (unlines o)