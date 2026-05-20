primi ws     = take 3 ws 
rimanenti ws = tail (tail (tail ws))


tresplit [] = []
tresplit ws = primi ws : tresplit (rimanenti ws)


prenditempo tripletta  =  read ( tripletta !! 1 )  :: Int
prendicosto tripletta  =  read ( tripletta !! 2 )  :: Int


dominata _ [] = False
dominata xs (h:ts)  |  (prenditempo xs < prenditempo h) && (prendicosto xs < prendicosto h) = True
                    |  otherwise                                                             = dominata xs ts


dominantiunici xs = [h | h <- xs, not (dominata h xs)]

main = do 
    inpStr <- readFile "memory.txt"
    let ws = words inpStr
    let diverseram = tresplit ws
    let output = unlines (map show (dominantiunici diverseram))
    writeFile "output.txt" output