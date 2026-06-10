-- 8:30
-- 9.30
data TipoAutoVettura = TipoAutoVettura{identificativo::Int,haAriaCondizionata::Bool,haTettuccio::Bool,numRichiesto::Int}deriving(Show,Eq)
data QuantiOgniTipo = QuantiOgniTipo{idd :: Int, num :: Int}deriving(Show,Eq)

parse :: [Char] -> TipoAutoVettura
parse str = let [id,har,hat,num] = words str 
            in TipoAutoVettura (read id :: Int) (read har:: Bool) (read hat::Bool) (read num::Int)

tipoDatoId :: Int -> [TipoAutoVettura] -> TipoAutoVettura
tipoDatoId id tipiautovetture = head [a | a<-tipiautovetture, (identificativo a) == id]

quantiHanno :: (Foldable t1, Num b) => t1 t2 -> (t2 -> Bool) -> b
quantiHanno tipiAutovettura c = foldr (\t acc -> if c t then acc+1 else acc) 0 tipiAutovettura

tipiautovettureinseq seq tipiautovetture = map (\s -> tipoDatoId (read s :: Int) tipiautovetture) seq

--------------------------------------------------------------------------------
_controllo :: (Ord t, Num t) => [TipoAutoVettura] -> [String] -> Int -> t -> (TipoAutoVettura -> Bool) -> [Bool]
_controllo tipiautovetture [] numAutoCons nonPiuDiN condizione = [True]
_controllo tipiautovetture seqAuto numAutoCons nonPiuDiN condizione 
                                                        |  ((quantiHanno (map (\x -> tipoDatoId x tipiautovetture) (map (\s -> read s ::Int) (take numAutoCons seqAuto))) condizione) <= nonPiuDiN) = True:_controllo tipiautovetture (tail seqAuto) numAutoCons nonPiuDiN condizione 
                                                        |  otherwise                                                                                                                                = False:_controllo tipiautovetture (tail seqAuto) numAutoCons nonPiuDiN condizione 

controllo :: (Ord t, Num t) => [TipoAutoVettura] -> [String] -> Int -> t -> (TipoAutoVettura -> Bool) -> Bool
controllo tipiautovetture seqAuto numAutoCons nonPiuDiN condizione = and (_controllo tipiautovetture seqAuto numAutoCons nonPiuDiN condizione)
--------------------------------------------------------------------------------

uniq :: (Foldable t, Eq a) => t a -> [a]
uniq lista   = foldr(\l acc -> if (elem l acc) then acc else l:acc)[] lista 

conta :: (Foldable t, Num b) => Int -> t String -> b
conta id seq = foldr (\l acc -> if (read l ::Int) == id then acc+1 else acc) 0 seq

controllonum :: Foldable t => [TipoAutoVettura] -> t QuantiOgniTipo -> Bool
controllonum tipiautovetture qot = all (\q -> if ((num q) <= (numRichiesto (tipoDatoId (idd q) tipiautovetture))) then True else False) qot

main :: IO ()
main = do 
    -- Prendiamo diversi tipi
    inpStr <- readFile "richiesteAuto.txt"
    let liness = lines inpStr
    let tipiautovetture = map parse liness
    print tipiautovetture

    -- Prendiamo richieste
    inpStr2 <- readFile "sequenzaAuto.txt"
    let liness2 = lines inpStr2
    let seqAuto = map (\str -> last (words str)) liness2
    print seqAuto

    -- controlliamo i vincoli di capacita 
    let res1 = controllo tipiautovetture seqAuto 5 3 haAriaCondizionata
    let res2 = controllo tipiautovetture seqAuto 3 1 haTettuccio
    print res1
    print res2
    -- controllo numero di auto prodotte per ogni tipo coincide con le richieste
    let _qot = uniq(map (\i-> QuantiOgniTipo (read i :: Int) 0) seqAuto)
    let qot = map (\id -> QuantiOgniTipo id (conta id seqAuto)) (map idd _qot)

    let res3 = controllonum tipiautovetture qot
    print res3

    if res1 && res2 then 
        print "Controlli vincoli capacita SUPERATI"
    else
        print "Controlli vincoli capacita NON SUPERATI"
    
    if res3 then 
        print "Controllo numero di auto prodotte per ogni tipo coincide con le richieste SUPERATO"  
    else 
        print "Controllo numero di auto prodotte per ogni tipo coincide con le richieste NON SUPERATO"  
