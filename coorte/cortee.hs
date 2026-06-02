data EsameStudente = EsameStudente{
    nomedelcorso :: String,
    matricolastudente :: Int,
    numGiornidaImmatricolazione :: Int,
    cognome :: String 
}deriving(Show,Eq)

data Studente = Studente{
    cogn :: String,
    matr :: Int
}deriving(Show,Eq)

data Corsi = Corsi{
    nomecors :: String,
    sommavoti :: Int,
    numeroPartecipanti :: Int 
}deriving(Show,Eq)

data Output = Output{
    cors :: String,
    num :: Int
}deriving(Show,Eq)

data Output2 = Output2{
    corss :: String,
    numm :: Float
}deriving(Show,Eq)


popolastudenti str = let [nomedelcorso, matricolastudente,numGiornidaImmatricolazione,cognome] = words str 
    in Studente cognome (read matricolastudente :: Int)

popolacorsi str = let [nomedelcorso, matricolastudente,numGiornidaImmatricolazione,cognome] = words str 
    in Corsi nomedelcorso 0 0 


parser str = 
    let [nomedelcorso, matricolastudente,numGiornidaImmatricolazione,cognome] = words str 
    in EsameStudente nomedelcorso (read matricolastudente :: Int) (read numGiornidaImmatricolazione :: Int) cognome

prendiesamisostenuti cognomeStudente esamestudenti =  [x| x <- esamestudenti, cognome x == cognomeStudente]


core [] h prec = []
core (x:xs) h prec 
                    | x == h    = (Output (nomedelcorso x) (numGiornidaImmatricolazione x)):core xs h x 
                    | otherwise = (Output (nomedelcorso x) (numGiornidaImmatricolazione x - numGiornidaImmatricolazione prec)):core xs h x 


uniq list = foldr (\x acc -> x: filter(/= x) acc) [] list

appiattisci list = foldr (++)[] list 


updatelista corso [] = []
updatelista corso (l:listacorsi) 
                                    | cors corso == nomecors l    = (Corsi (nomecors l)(sommavoti l + num corso)(numeroPartecipanti l + 1)):updatelista corso listacorsi
                                    | otherwise                   = l:updatelista corso listacorsi


core2 [] listacorsi = listacorsi
core2 (corso:corsi) listacorsi  = core2 corsi (updatelista corso listacorsi)


mediastrana [] = [] 
mediastrana (l:listacorsii) = (Output2 (nomecors l) ((read (show(sommavoti l)) :: Float)/(read (show(numeroPartecipanti l)) :: Float))):mediastrana listacorsii

main = do

    ------------------------------------
    --      Eso                       -- 
    ------------------------------------

    inpStr <- readFile "cortee.txt" 
    print inpStr
    let liness = lines inpStr
    print liness
    let esamestudenti = map parser liness
    print esamestudenti

    ------------------------------------
    --      Es1                       -- 
    ------------------------------------

    print "Inserire nome studente da visualizzare"
    cognomeStudente <- getLine 
    print cognomeStudente
    let esamidistudente = prendiesamisostenuti cognomeStudente esamestudenti
    print esamidistudente
    
    let outputs = core esamidistudente (head esamidistudente) (head esamidistudente)
    print outputs

    ------------------------------------
    --      Es2                       -- 
    ------------------------------------
    print "====="

    let studentinonuniq = uniq (map popolastudenti liness)
    print studentinonuniq

    print "************************************"
    let corsi = uniq (map popolacorsi liness)
    print corsi
    print "************************************"

    print "====="
    let exss = map (\x -> prendiesamisostenuti (cogn x) esamestudenti) studentinonuniq
    print exss
    print "====="

    let outputss = map (\x -> core x (head x) (head x)) exss
    print outputss

    let tempoesamidiognistudente = appiattisci outputss

    let listacorsii = core2 tempoesamidiognistudente corsi
    print listacorsii

    let oout = mediastrana listacorsii
    print oout

    let strdastamp = map (\s -> unwords [corss s, show (numm s)]) oout
    putStrLn (unlines strdastamp)