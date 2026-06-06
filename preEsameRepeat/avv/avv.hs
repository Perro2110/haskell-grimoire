data Turno = Turno{cognome ::String, inizio :: Int, fine :: Int, stato :: String}deriving(Show)

parse str = let [c,i,f,s] = words str
            in Turno c (read i :: Int) (read f :: Int) s

avvelentao t 
            | (stato t) == "AVV" = True 
            | otherwise          = False

---
--_a_inturno_con_b [] b = [False]
--_a_inturno_con_b (a:as) b 
--                        | any (== a) b = True:_a_inturno_con_b as b 
--                        | otherwise    = False:_a_inturno_con_b as b 
---
_a_inturno_con_b a b = foldr (\x acc -> if (any (== x) b || acc) then True else False ) False a

a_inturno_con_b a b = (_a_inturno_con_b [(inizio a)..(fine a)] [(inizio b)..(fine b)])


divAvvOk l = foldr(\x (s,n) -> if not(avvelentao x) then (x:s,n) else (s,x:n)) ([],[]) l


-- _a_inturno_con_tutti_i_vari_b a []                        = [True]
-- _a_inturno_con_tutti_i_vari_b a (b:bs) 
--                                     | a_inturno_con_b a b = True:_a_inturno_con_tutti_i_vari_b a bs
--                                     | otherwise           = False:_a_inturno_con_tutti_i_vari_b a bs
-- 
-- a_inturno_con_tutti_i_vari_b a b = and(_a_inturno_con_tutti_i_vari_b a b)
--

a_inturno_con_tutti_i_vari_b a b = foldr (\x acc -> if (a_inturno_con_b a x) && acc then True else False) True b 

-- se sei tu ok e sei stato con tutti avv allora sei il cattivo 

cercoBastardo [] avv = []
cercoBastardo (sano:sani) avv 
                            | (a_inturno_con_tutti_i_vari_b sano avv)  = sano:cercoBastardo sani avv 
                            | otherwise                                = cercoBastardo sani avv 

toString bastardo = "dr. " ++ (cognome bastardo) ++ " che ha lavoprato dalle: " ++ (show (inizio bastardo)) ++ " alle: "++(show (fine bastardo))

main = do 
    inpStr <- readFile "turni.txt"
    let liness = lines inpStr
    let turni = map parse liness
    let (sani,avv) = divAvvOk turni
    print "======================"
    print "Sono possibili traditori:"
    print sani
    print "Sono sicuramente innocenti:"
    print avv
    print "======================"

    -- core 
    let bastardi = cercoBastardo sani avv
    print "I bastardi sono:"
    let outStr = unlines(map toString bastardi)
    putStrLn outStr