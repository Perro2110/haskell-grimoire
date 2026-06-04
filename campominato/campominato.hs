data Cella = Cella {x :: Int, y :: Int, val :: Char}deriving(Show,Eq)
data CellaConVal = CellaConVal {xscop :: Int, yscop :: Int, valscop :: Int}deriving(Show,Eq)


sostituiscispaziconmeni [] = [] 
sostituiscispaziconmeni (w:str) 
                                | w == ' '  = '-': sostituiscispaziconmeni str
                                | otherwise =   w: sostituiscispaziconmeni str

parse t = map (\(elem,x) -> Cella x (snd t) elem) (zip (fst t) [1..]) 


bomba c 
        | (val c) == '*'  = True 
        | otherwise = False 

prendicelladatoXY cs valX valY = head [c | c <- cs, (x c) == valX, (y c) == valY]

controllaXY cs valX valY 
                        | (bomba (prendicelladatoXY cs valX valY)) = True 
                        | otherwise                               = False 

celleattorno c cs maxX maxY
                    | ((x c) == 1 && (y c) == 1)       = [celle | celle <- cs, ( ( (x celle) == (x c) && ((y celle) - 1) == (y c)) || ( ((x celle) - 1) == (x c) && ((y celle)) == (y c)) || ( ((x celle) - 1) == (x c) && ((y celle) - 1) == (y c)) )]  
                    | ((x c) == maxX && (y c) == maxY) = [celle | celle <- cs, ( ( (x celle) == (x c) && ((y celle) + 1) == (y c)) || ( ((x celle) + 1) == (x c) && ((y celle)) == (y c)) || ( ((x celle) + 1) == (x c) && ((y celle) + 1) == (y c)) )]  
                    | ((x c) == 1 && (y c) == maxY)    = [celle | celle <- cs, ( ( (x celle) == (x c) && ((y celle) + 1) == (y c)) || ( ((x celle) - 1) == (x c) && ((y celle)) == (y c)) || ( ((x celle) - 1) == (x c) && ((y celle) + 1) == (y c)) )]  
                    | ((x c) == maxX && (y c) == 1)    = [celle | celle <- cs, ( ( (x celle) == (x c) && ((y celle) + 1) == (y c)) || ( ((x celle) + 1) == (x c) && ((y celle)) == (y c)) || ( ((x celle) + 1) == (x c) && ((y celle) + 1) == (y c)) )]  
                    | otherwise                        = [celle | celle <- cs, ( ( (x celle) == (x c) && ((y celle) - 1) == (y c)) || (  (x celle) == (x c) && ((y celle) + 1) == (y c))   || ( ((x celle) - 1) == (x c) && ((y celle)) == (y c))  || ( ((x celle) + 1) == (x c) && ((y celle) == (y c))) || ( ((x celle) + 1) == (x c) && ((y celle)+ 1) == (y c)) || ( ((x celle) + 1) == (x c) && ((y celle)- 1) == (y c)) || ( ((x celle) - 1) == (x c) && ((y celle)- 1) == (y c)) || ( ((x celle) + 1) == (x c) && ((y celle)+ 1) == (y c)) )]  


-- dato una cella e tutte le celle conta quante attorno sono bomba 
quanteattotno [] cs bordox bordoy = []
quanteattotno (c:css) cs bordox bordoy 
                                        | not (bomba c) = (CellaConVal (x c) (y c) (contareTrue (map bomba (celleattorno c cs bordox bordoy)))):quanteattotno css cs bordox bordoy
                                        | otherwise     = (CellaConVal (x c) (y c) (-1)) :quanteattotno css cs bordox bordoy

contareTrue l = foldr (\val count -> if val == True then (count+1) else count) 0 l

appiattisci l = foldr(++) [] l

parsastamerda [] y = []
parsastamerda (o:os) y 
                        | (yscop o /= y) = ("\n"):parsastamerda (o:os) (y+1)
                        | (yscop o == y) && (valscop o == -1) = "*":parsastamerda os y
                        | otherwise      = ((show (valscop o))):parsastamerda os y

main = do 
    inpsStr <- readFile "campominato.txt"
    let liness = lines inpsStr
    let camposenzaspazi  = map sostituiscispaziconmeni liness
    --print camposenzaspazi
    let numeroy = length liness
    let numerox = length (head camposenzaspazi)
    print "===================================="
    --print numeroy
    let numerorighe = [1..numeroy]
    --print numerox
    print "===================================="
    let linecony = zip camposenzaspazi numerorighe
    --print linecony
    let listacelle = map parse linecony
    let celle = appiattisci listacelle
    --print celle
    let output = quanteattotno celle celle numerox numeroy
    print output

    let outputstr = parsastamerda output 1
    print outputstr
    writeFile "schema.txt" (unwords outputstr)