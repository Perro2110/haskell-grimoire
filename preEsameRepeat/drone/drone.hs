data Drone = Drone {pos :: (Int,Int),live :: Bool}deriving(Show)
data DroneConStorico = DroneConStorico {poss :: (Int,Int)}deriving(Show)

data Meteorite = Meteorite {posm :: (Int,Int)}deriving(Show)

parsemeteoriti str = let [a,b] = words str 
                     in Meteorite ((read a ::Int),(read b :: Int))

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

moves str drone bordideluniverso meteroiti
            | str == "U" = if (u drone bordideluniverso meteroiti) then (up drone)    else (Drone (-1,-1) False)
            | str == "D" = if (d drone bordideluniverso meteroiti) then (down drone)  else (Drone (-1,-1) False)
            | str == "L" = if (l drone bordideluniverso meteroiti) then (left drone)  else (Drone (-1,-1) False)
            | str == "R" = if (r drone bordideluniverso meteroiti) then (right drone) else (Drone (-1,-1) False)
            | otherwise  = (Drone (-1,-1) False)


r drone bordideluniverso meteroiti = not(prendix drone >= (fst bordideluniverso)) && (all (/= ((prendix drone +1),(prendiy drone))) (map posm meteroiti))
l drone bordideluniverso meteroiti = not(prendix drone <= 0) && (all (/= ((prendix drone -1),prendiy drone)) (map posm meteroiti))

u drone bordideluniverso meteroiti = not(prendiy drone >= (snd bordideluniverso)) && (all (/= (prendix drone,(prendiy drone)+1)) (map posm meteroiti))
d drone bordideluniverso meteroiti = not(prendiy drone <= 0) && (all (/= (prendix drone,(prendiy drone)-1)) (map posm meteroiti))

autopilot drone movimenti bordideluniverso meteroiti = foldl (\d movimento-> moves movimento d bordideluniverso meteroiti) drone movimenti

tracciato drone [] bordideluniverso meteroiti = []
tracciato drone (m:movimenti) bordideluniverso meteroiti = (autopilot drone [m] bordideluniverso meteroiti):(tracciato (autopilot drone [m] bordideluniverso meteroiti) movimenti bordideluniverso meteroiti)

manathan (x,y) (xx,yy) = (x - xx) + (y - yy) 

main = do 
    inpStrp <- readFile "drone.txt"
    ostacoli <- readFile "meteorite.txt"

    let linessp = lines inpStrp
    let linessm = lines ostacoli
    

    let meteroiti = map parsemeteoriti linessm
    print meteroiti

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

    let newd = autopilot drone percorso bordideluniverso meteroiti
    
    print newd
    let tracciatoo = (tracciato drone percorso bordideluniverso meteroiti)
    print tracciatoo
    print "distanza manathan"
    print (show(manathan (pos newd) (0,0)))
    
