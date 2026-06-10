--10.30
--10.44
data Ram = Ram{costruttore :: String,tempAccesso :: Int, costoDollari :: Int}deriving(Show)

parse :: [Char] -> Ram
parse str = let [a,b,c] = words str 
            in Ram a (read b :: Int) (read c :: Int)

vienedominata :: Ram -> Ram -> Bool
vienedominata r r2 = (tempAccesso r > tempAccesso r2 && costoDollari r > costoDollari r2)


--_nonvienemaidominata r1 [] = [True] 
--_nonvienemaidominata r1 (r:rs) 
--                            | vienedominata r1 r = False:_nonvienemaidominata r1 rs
--                            | otherwise          = True:_nonvienemaidominata r1 rs 
--
--nonvienemaidominata r rs = and (_nonvienemaidominata r rs)
nonvienemaidominata :: Foldable t => Ram -> t Ram -> Bool
nonvienemaidominata r1 rs = all (\r -> not(vienedominata r1 r)) rs

nondominate :: [Ram] -> [Ram]
nondominate rams = [r | r <- rams, (nonvienemaidominata r rams)]

main :: IO()
main = do 
    inpstr <- readFile "memory.txt"
    let liness  = lines inpstr
    let memorys = map parse liness
    print memorys
    let nd = nondominate memorys
    let out = map (\r -> costruttore r ++ " " ++ (show (tempAccesso r)) ++ " " ++ (show (costoDollari r)) ) nd 
    writeFile "out.txt" (unlines out)