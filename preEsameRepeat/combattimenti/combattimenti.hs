
data Personaggio = Personaggio{nome :: String, puntiVita :: Int}deriving(Show,Eq)
data Turno = Turno{caster::String,target::String,modificatorePv::Int,tipoAzione::String}deriving(Show,Eq)

parse str = let [c,o,m,t] = words str 
            in Turno c o (read m :: Int) t 

takepersonaggioconnome personaggi n = head [x | x<- personaggi, nome x == n]
islive p = (puntiVita p) > 0

modificaPv p modificatore = Personaggio (nome p) (puntiVita p + modificatore)

azioneValida t personaggi = (islive (takepersonaggioconnome personaggi (caster t))) && (islive (takepersonaggioconnome personaggi (target t)))

--- esplicita 
--effetuaAzione t [] = []
--effetuaAzione t (p:personaggi) 
--                    | ((nome p) == (target t)) = (modificaPv p (modificatorePv t)) : (effetuaAzione t personaggi)
--                    | otherwise                = p:effetuaAzione t personaggi 
-- foldr 
effetuaAzione t personaggi = foldr (\p acc -> if ((nome p) == (target t)) then (modificaPv p (modificatorePv t)):acc else p:acc) [] personaggi

--- esplicita 
-- combattimento [] personaggi = personaggi
-- combattimento (t:turni) personaggi  
--                     | azioneValida t personaggi = combattimento turni (effetuaAzione t personaggi)
--                     | otherwise                 =  combattimento turni personaggi  
-- foldl
combattimento turni personaggi = foldl (\acc t -> if (azioneValida t acc) then (effetuaAzione t acc) else acc) personaggi turni 

--------------------------------------------------------------------------------
--                      Utils varie generiche 
--------------------------------------------------------------------------------

uniqStr personaggiconripetizioni = foldr (\x acc -> x:filter(/=x) acc) [] personaggiconripetizioni

main = do
    -------------Estraggo info dal file 
    inpStr <- readFile "combattimento.txt"
    let liness = lines inpStr

    -------------Genero turni 
    let turni = map parse liness
    print "===Turni==="
    print turni 

    ------------Da turni a personaggi 
    let casters   = map caster turni  
    let obiettivi = map target turni 
    let nomipersonaggiconripetizioni = obiettivi++casters
    let uniqnomipersonaggi = uniqStr nomipersonaggiconripetizioni
    let personaggi = map (\x -> Personaggio x 20) uniqnomipersonaggi
    print "===Personaggi==="
    print personaggi
    print "================"

    let personaggiPostCombattimento = combattimento turni personaggi
    print personaggiPostCombattimento
