data InfoEsam = InfoEsam{nomecorso :: String, matricolastud :: Int, giorniimm :: Int, cognomestudente :: String} deriving (Show)

data InfoDatoNome = InfoDatoNome {corso :: String, numP :: Int, somVoti ::Int}deriving (Show)

parse str = let [a,b,c,d] = words str 
            in InfoEsam a (read b :: Int) (read c :: Int) d

prendiesamidiX storico nomeX = [x | x <-storico, (cognomestudente x) ==  nomeX]

calcoladata p pn = (giorniimm pn) - (giorniimm p)

newt (n2,v2) (n1,v1) = (n2,(v2-v1))

_core [] th = []
_core (t:ts) th 
            | t == th   = t:_core ts t 
            | otherwise = (newt t th): _core ts t 

core t = _core t (head t)

uniq l = foldr (\x acc -> if (elem x acc) then acc else x:acc) [] l
flat l = foldr (++) [] l

prendituttinome esami nome = [t | t <- esami, fst t == nome]

sommi l = foldr(\(n,x) acc -> ((fst acc) + x,(snd acc)+1)) (0,0) l

parsestr1 tt = foldr (\(x,y) acc -> (x ++ " "++ (show y) ++ "\n" ++ acc)) [] tt
parsestr2 tt = foldr (\(x,y) acc -> (x ++ " "++ (show y) ++ "\n" ++ acc)) [] tt

main = do 
    inpStr <- readFile "coorte.txt"
    print "=========================="
    print "           ES 1           "
    print "=========================="
    print "Inserire cognome idiota: "
    let liness = lines inpStr
    let storicoEsami = map parse liness
    nomepersona <- getLine 
    let esmidip = prendiesamidiX storicoEsami nomepersona
    let t = zip (map nomecorso esmidip) (map giorniimm esmidip)    
    let tt = core t
    putStrLn (parsestr1 tt)

    print "=========================="
    print "           ES 2           "
    print "=========================="

    let esami = map (\s -> InfoDatoNome s 0 0) (uniq (map nomecorso storicoEsami))
    let nomipersone = uniq (map cognomestudente storicoEsami)

    let tuttiesamievalutati = flat (map (\n -> core (zip (map nomecorso (prendiesamidiX storicoEsami n)) (map giorniimm (prendiesamidiX storicoEsami n)))) nomipersone)
    --print tuttiesamievalutati
    --print (prendituttinome tuttiesamievalutati "Geometria")
    let out = (zip (map corso esami) (map (\nome -> (sommi (prendituttinome tuttiesamievalutati nome))) (map corso esami)))
    let tout = map (\(x,y) -> (x,(read(show (fst y)) :: Float)/(read(show (snd y)) :: Float)) ) out
    putStrLn (parsestr2 tout)
  

