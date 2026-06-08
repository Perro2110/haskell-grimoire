-- 16.15 16.39
data Tassello = Tassello{nome ::Int,pos::(Int,Int)}deriving(Show,Eq)
stampa lista = (show (nome (head lista))) ++ " " ++ unwords(map parseout lista) ++ "\n"

parse (strdiid,y) = map (\(i,x) -> Tassello (read i :: Int) (y,x)) (zip (words strdiid) [1..])

flat l = foldr (++) [] l
uniq l = foldr (\x acc-> if (elem x acc) then acc else x:acc) [] l

prenditassellidaid tasselli ids = [t | t <- tasselli, (nome t) == ids]

parseout tassello = show(pos tassello)

core f tasselli allid = uniq (map (\ids -> (f tasselli ids)) allid)

main = do
    inpStr <- readFile "table.txt"
    let liness    = lines inpStr
    let liess_y   = zip liness [1..]
    let tasselli  = map parse liess_y
    let tassellis = flat tasselli
    let allid     = map nome tassellis
    let out       = core prenditassellidaid tassellis allid
    let strOut = map stampa out 
    putStrLn (unwords strOut)