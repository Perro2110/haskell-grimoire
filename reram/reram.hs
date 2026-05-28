data Ram = Ram {costruttore :: String, tempoaccesso :: Int, costoindollar :: Int} deriving(Show)

parseSingleRam :: String -> Ram
parseSingleRam ram = 
    let [a,b,c] = words ram 
    in Ram a (read b :: Int) (read c :: Int)

firstIsBetter n m | tempoaccesso n <= tempoaccesso m  = False 
                  | costoindollar n <= costoindollar m = False 
                  | otherwise = True 


firstisBadder n m = not (firstIsBetter n m) 

isdominate x rams = and[b | y<-rams, costruttore x /= costruttore y ,let b = firstisBadder x y]

-- core, controlla 
core [] ram = []
core (r:rs) ram | not(isdominate r ram) = core rs ram
                | otherwise = r:core rs ram


main = do
    instr <- readFile "memory.txt"
    --print instr
    let lin = lines instr
    let rams = map parseSingleRam lin
    --print rams
    let cr = core rams rams 
    print cr 
    writeFile "output.txt" (unlines (map show cr))
