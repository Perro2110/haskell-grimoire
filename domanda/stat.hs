data Stat = Stat {nome::String,voti::[Float]}deriving(Show,Eq)

parse (t:lista) = Stat t (map (read) lista)

main = do
    inpstr <- readFile "stast.txt" 
    let liness = lines inpstr
    print liness
    let listaperognimerda = map words liness
    print listaperognimerda
    let statistiche = map parse listaperognimerda
    print statistiche
    