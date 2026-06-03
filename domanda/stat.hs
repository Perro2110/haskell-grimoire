data Stat = Stat {nome::String,voti::[Float]}deriving(Show,Eq)

data Classifica = Classifica{numeroDomanda :: Int, nomipersone :: [String] }deriving(Show,Eq)

parse (t:lista) = Stat t (map (read) lista)


prendimassimoadomandaX [] x dummy = dummy
prendimassimoadomandaX (stats:statss) x dummy 
                                                | ( (voti dummy) !! x ) <= ( (voti stats) !! x ) = prendimassimoadomandaX statss x stats 
                                                | otherwise                                      = prendimassimoadomandaX statss x dummy 

datadomandaXdiamoClassifica [] x = []
datadomandaXdiamoClassifica statistiche x = prendimassimoadomandaX statistiche x (head statistiche):datadomandaXdiamoClassifica [y | y <- statistiche, y /= (prendimassimoadomandaX statistiche x (head statistiche))] x 

toString classificazza = ("Domanda: "++show (numeroDomanda classificazza))++"\n"++(unlines (nomipersone classificazza))

main = do
    inpstr <- readFile "stast.txt" 
    let liness = lines inpstr
    --print liness
    let listaperognimerda = map words liness
    --print listaperognimerda
    let statistiche = map parse listaperognimerda
    -- print statistiche
    let numDomande = length (voti (head statistiche))
    --print numDomande

    let numeroDomande = [0..(numDomande-1)]
    
    let sol1 = map (\nd -> datadomandaXdiamoClassifica statistiche nd) numeroDomande
    let solzipposa = zip numeroDomande sol1
    print solzipposa
    
    let test = map nome statistiche
    print "==========="
    
    let classificazza = map (\(numdomanda,lista) -> Classifica (numdomanda+1) (map nome lista)) solzipposa
    
    let insiemedistringhe = map toString classificazza
    putStrLn (unlines insiemedistringhe)


