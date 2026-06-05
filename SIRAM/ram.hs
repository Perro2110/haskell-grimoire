data Ram = Ram{costruttore :: String, tempoAccesso :: Int, costoInDollari :: Int}deriving (Show,Eq)

parse str = 
    let [a,b,c] = words str 
    in Ram a (read b :: Int) (read c ::Int)

a_domminaSu_b a b 
                    | (tempoAccesso a) <=  (tempoAccesso b) &&  (costoInDollari a) <  (costoInDollari b)    = True 
                    | (costoInDollari a) <=  (costoInDollari b)  &&  (tempoAccesso a) <  (tempoAccesso b)   = True 
                    | otherwise                                                                             = False 

vienemaidominato ram rams = (or (map (\r -> a_domminaSu_b r ram) rams))

prendirammaidominate rams = [r | r <- rams, not(vienemaidominato r rams)]

tostring ram = (costruttore ram)++" "++(show (tempoAccesso ram))++" "++(show (costoInDollari ram))++"\n"

main = do 
    inpStr <- readFile "ram.txt"
    print inpStr
    let liness = lines inpStr
    let rams   = map parse liness
    let o = prendirammaidominate rams 
    let outStr = map tostring o
    putStrLn (unwords outStr)