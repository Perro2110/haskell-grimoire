data Turno = Turno {name::String, inizio::Int, fine::Int, stato::String} deriving (Show, Eq)

parse str =
    let [name,inizio,fine,stato] = words str
    in Turno name (read inizio :: Int) (read fine :: Int) stato



inn [] _ = [False]
inn (a:b) c = any(== a) c : inn b c

aenelturnodib a b = or (inn [inizio a..fine a] [inizio b..fine b])


nontuttiok a = not (and (map (\x -> stato x == "OK") a))

haaavvelenatotutti a b = (and (avsall a b))

avsall a  [] = [True] 
avsall a (b:xs)
    | aenelturnodib a b && stato b == "AVV" && stato a /= stato b = True: avsall a xs
    | aenelturnodib a b && stato b == "OK" && stato a == stato b = True: avsall a xs
    | not(aenelturnodib a b) && stato b == "AVV" = False:avsall a xs
    | otherwise = [False]


tuttiinturnoconme x turni = [y| y<-turni,y /= x, aenelturnodib x y]

core [] b = []
core (x:xs) b
    | (haaavvelenatotutti x b) && nontuttiok (tuttiinturnoconme x b) && stato x == "OK" = [x] 
    | otherwise              = core xs b

main = do 
    inpstr <- readFile "turni.txt"
    print inpstr
    let turnitxt = lines inpstr
    print turnitxt
    let turni = map parse turnitxt 
    print turni
    print "aaa"
    let res = core turni turni
    print res

    