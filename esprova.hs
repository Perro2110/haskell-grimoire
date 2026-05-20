primi ws     = take 3 ws 
rimanenti ws = tail (tail (tail ws))

tresplit [] = []
tresplit ws = primi ws : tresplit (rimanenti ws)


prenditempo tripletta  =  read ( tripletta !! 1 )  :: Int
prendicosto tripletta  =  read ( tripletta !! 2 )  :: Int


returndominatore f s | prenditempo f > prenditempo s = f
                     | prendicosto f > prendicosto s = f 
                     | otherwise = s

controlloallversusall ll = [returndominatore xs s | xs <- ll, s <- ll, xs /= s, returndominatore xs s == xs]

uniq [] = []
uniq (x:xs) | x `elem` xs = uniq xs
            | otherwise   = x : uniq xs
            

main = do 
    inpStr <- readFile "memory.txt"
    let ws = words inpStr
    
    let diverseram = tresplit ws
    let dominanti = controlloallversusall diverseram
    let dominantiunici = uniq dominanti
    let output = unlines (map show dominantiunici)

    writeFile "output.txt" output






