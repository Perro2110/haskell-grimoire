data Drone = Drone {pos :: (Int,Int),live :: Bool}deriving(Show)
data DroneConStorico = DroneConStorico {poss :: (Int,Int)}deriving(Show)

data Meteorite = Meteorite {posm :: (Int,Int)}deriving(Show)

prendix drone = fst (pos drone)
prendiy drone = snd (pos drone)

keepLive drone = live drone

seineibordideuniverso bordideluniverso drone 
    | ((prendix drone) > (fst bordideluniverso) || (prendiy drone) > (snd bordideluniverso)) = False 
    | otherwise = True 
    

right drone = Drone ((prendix drone) +1 ,(prendiy drone)) True
left drone = Drone ((prendix drone) -1 ,(prendiy drone)) True

up drone = Drone (prendix drone,(prendiy drone) + 1) True
down drone = Drone (prendix drone,(prendiy drone) - 1) True

moves str drone bordideluniverso
            | str == "U" = if (u drone bordideluniverso) then (up drone)    else (Drone (-1,-1) False)
            | str == "D" = if (d drone bordideluniverso) then (down drone)  else (Drone (-1,-1) False)
            | str == "L" = if (l drone bordideluniverso) then (left drone)  else (Drone (-1,-1) False)
            | str == "R" = if (r drone bordideluniverso) then (right drone) else (Drone (-1,-1) False)
            | otherwise  = (Drone (-1,-1) False)


r drone bordideluniverso = not(prendix drone >= (fst bordideluniverso))
l drone bordideluniverso = not(prendix drone <= 0) 

u drone bordideluniverso = not(prendiy drone >= (snd bordideluniverso))
d drone bordideluniverso = not(prendiy drone <= 0)

autopilot drone movimenti bordideluniverso = foldl (\d movimento-> moves movimento d bordideluniverso) drone movimenti

main = do 
    inpStrp <- readFile "drone.txt"

    let linessp = lines inpStrp

    let [x,y] = words (head linessp) 
    let percorso = tail linessp
    let drone = Drone ((read x :: Int),(read y :: Int)) True
    print drone

    print "inserisci massima larghezza (x) universo"
    _bordox <- getLine
    let bordox = read _bordox :: Int
    print "inserisci massima altezza (y) universo"
    _bordoy <- getLine
    let bordoy = read _bordoy :: Int
    
    let bordideluniverso = (bordox,bordoy)
    let newd = autopilot drone percorso bordideluniverso
    print newd
   
    let movimenti = map (\mov -> moves mov drone bordideluniverso) percorso
    print movimenti
    print "END"
    
