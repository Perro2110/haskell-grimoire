data Campione = Campione{identificativo ::String, componenti :: String}deriving (Show,Eq)

parse str = let [a,b] = words str 
            in Campione a b

calcolo str = (read (show ((foldr(\c acc-> if elem c "GC" then acc+1 else acc) 0 str))) :: Float)/(read (show(length str)) :: Float)

eval genoma = identificativo genoma ++" "++ (show (calcolo (componenti genoma)*100))++"%\n"

main = do
    inpStr <- readFile "genoma.txt"
    let liness = lines inpStr
    let campioni = map parse liness
    print campioni
    print "============"
    let evals = map eval campioni 
    putStrLn (unwords evals)

