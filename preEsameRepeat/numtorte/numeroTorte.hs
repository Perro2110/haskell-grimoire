data Ingrediente = Ingrediente {nome :: String, peso::Int}deriving(Show)

parse str = let [a,b] = words str
            in Ingrediente a (read b ::Int)

elementox ricetta x = foldr (\r acc -> if (nome r) == (nome x) then r else acc) (Ingrediente (nome x) 0) ricetta

richiestoinricettaelementoconnomex ricetta c = elem (nome c) (map nome ricetta)

quantorichiesto ricetta c 
            | richiestoinricettaelementoconnomex ricetta c = div (peso c) (peso (elementox ricetta c))
            | otherwise                                    = 0  -- non capiterai mai qui ma lo tengo perche si 

minnimo lista = foldr (\x acc -> if x <= acc then x else acc) (head lista) lista 

main = do 
    inpStr  <- readFile "ricetta.txt"
    inpStr2 <- readFile "incredienti.txt"

    let ricetta     = lines inpStr
    let ingredienti = lines inpStr2

    let ric = map parse ricetta
    let ing = map parse ingredienti

    let inggg = map (\ingg -> quantorichiesto ric ingg) [i | i<-ing , richiestoinricettaelementoconnomex ric i]
    let out = "\nPuo fare "++(show (minnimo inggg))++" torte\n"
    putStrLn out
    


