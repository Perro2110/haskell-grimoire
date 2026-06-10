data Block = Block {name::String, x::Int, y::Int} deriving (Show, Eq)
data BlockPos = BlockPos {name2::String, xs::(Int,Int), ys::(Int,Int)} deriving (Show)

blockPosToLine bp = unwords [name2 bp,"(", show (fst (xs bp)),",", show (snd (xs bp)),")","(", 
                                       show (fst (ys bp)),",", show (snd (ys bp)) ,")"]

parse [] = []
parse (t:lts) =
    let ids = words (fst t)
        y   = snd t
        idz = zip ids [1..]
        bs  = map (\(n, i) -> Block n i y) idz
    in bs ++ parse lts

-- filter (\x -> fst x == fst (1,7) && x /= (1,7)) [(1,7),(1,2),(3,4)]
trovacompare b blooks = head (filter (\bl -> name bl == name b && bl /= b) blooks)

createBlockPos [] _ = []
createBlockPos (b:bs) allBlocks =
    let b2  = trovacompare b allBlocks
        xss = (y b, x b)
        yss = (y b2,x  b2)
    in BlockPos (name b) xss yss : createBlockPos (filter (\bl -> name bl /= name b) bs) allBlocks

main = do
    inpStr <- readFile "table.txt"
    let line  = lines inpStr
    print line
    let zline = zip line [1..]
    print zline
    let blooks = parse zline
    print blooks
    let bpos = createBlockPos blooks blooks
    print bpos
    
    let res = unlines (map blockPosToLine bpos)

    writeFile "out.txt" res