data Mossa = Mossa {caster :: String, bersaglio :: String, numeroEffetto :: Int, tipo :: String} deriving (Show,Eq)
data Pg = Pg{nome :: String, puntiVita :: Int} deriving (Show,Eq)


createpgdacaster str = 
    let [caster,bersaglio,numeroEffetto,tipo] = words str
    in Pg caster 20 

createpgdabersagli str = 
    let [caster,bersaglio,numeroEffetto,tipo] = words str
    in Pg bersaglio 20 

createstorico str =     
    let [caster,bersaglio,numeroEffetto,tipo] = words str
    in Mossa caster bersaglio (read numeroEffetto :: Int) tipo

creaunicalistanorep pgc pgb = [p | p <- (pgc++pgb)]

stessonome a b 
               | nome a == nome b   = True 
               | otherwise          = False 

rimuoviDuplicati = foldr (\x acc -> x : filter (/= x) acc) []

chifaazzione mossa [] = []
chifaazzione mossa (pg:pgs) 
                            | caster mossa == nome pg = [pg] 
                            | otherwise               = chifaazzione mossa pgs

cura mossa [] = []
cura mossa (pg:pgs) 
                    | (bersaglio mossa) == nome pg  = (Pg (nome pg) (puntiVita pg + numeroEffetto mossa)):cura mossa pgs
                    | otherwise = pg:cura mossa pgs

danneggia mossa [] = []
danneggia mossa (pg:pgs) 
                    | (bersaglio mossa) == nome pg  = (Pg (nome pg) (puntiVita pg - abs(numeroEffetto mossa))):danneggia mossa pgs
                    | otherwise = pg:danneggia mossa pgs

miss mossa pgs = pgs

eseguiturno mossa pgs 
                      | puntiVita (head (chifaazzione mossa pgs)) <= 0 = pgs    -- se non fa nulla non cambia i pgs 
                      | otherwise                                      = eseguimossa mossa pgs 

eseguimossa mossa pgs 
                      | numeroEffetto mossa >= 0 && (lemort (bersaglio mossa) pgs)                    = cura mossa pgs
                      | numeroEffetto mossa <= 0 && (lemort (bersaglio mossa) pgs)                    = danneggia mossa pgs
                      | otherwise                                                                     = miss mossa pgs                                                           


lemort nomepersonaggio [] = False
lemort nomepersonaggio (pg:pgg) 
                                | nome pg == nomepersonaggio && puntiVita pg >= 0 = True 
                                | otherwise                                       = lemort nomepersonaggio pgg


gamplay [] pgg = pgg
gamplay (mossa:storico) pgg = gamplay storico (eseguiturno mossa pgg)

partiziona p = foldr (\x (s,n) -> if p x then (x:s,n) else (s,x:n)) ([],[])

main = do 
    inptStr <- readFile "combattimento.txt" 
    print inptStr
    let liness = lines inptStr
    print liness
    let pgc = map createpgdacaster liness
    let pgb = map createpgdabersagli liness
    print pgc
    print pgb

    print "---------------------------------"
    let pgcd = creaunicalistanorep pgc pgb

    let pgg = rimuoviDuplicati pgcd 
    print pgg

    let storico = map createstorico liness
    print "---------------------------------"
    print  storico
    print "================================="

    let statusfinali = gamplay storico pgg 
    print statusfinali

