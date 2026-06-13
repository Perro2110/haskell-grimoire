data Cella = Cella {x::Int,y::Int,temp::Int}deriving(Show,Eq)

parse (t,y) = map (\(v,x)->Cella x y (read v :: Int)) (zip (words t) [1..])

flat l = foldr (++) [] l


seiquellasopra    c c2 = (x c == x c2) && ((y c2)-1 == (y c))  
seiquellasotto    c c2 = (x c == x c2) && ((y c2)+1 == (y c))  
seiquelladestra   c c2 = (y c == y c2) && ((x c2)-1 == (x c))  
seiquellasinistra c c2 = (y c == y c2) && ((x c2)+1 == (x c))  

datocelladammivicini c cs = [nc | nc <- cs, ((seiquellasopra nc c) ||  (seiquellasotto nc c) ||  (seiquelladestra nc c) ||  (seiquellasinistra nc c) )]

faimedia [] acc n = (fromInteger acc :: Float) / (fromInteger n :: Float) 
faimedia (c:lc) acc n = faimedia lc (acc+(temp c)) n

main = do
    inpStr <- readFile "temp.txt"
    let liness = lines inpStr
    let linessz = zip liness [1..]
    let _celle = map parse linessz
    let celle = flat _celle
    print (map (\c -> faimedia (datocelladammivicini c celle) 0 (length (datocelladammivicini c celle))) celle)
    