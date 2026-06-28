faidomanda :: (String, String) -> IO ()
faidomanda (d, r) = do
    print d
    h <- getLine
    print r

main :: IO ()
main = do
    inpStrDom <- readFile "domande.txt"
    inpStrRisposte <- readFile "risposte.txt"
    let liness_dom = lines inpStrDom
    let liness_ris = lines inpStrRisposte
    let copp = zip liness_dom liness_ris
    mapM_ faidomanda copp
    print "end"