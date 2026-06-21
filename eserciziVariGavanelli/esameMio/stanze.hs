data Stanza = Stanza{giorniincuioccupata :: [Int],numeroStanza :: Int}deriving(Show,Eq)
data Cliente = Cliente {arrivoc :: Int, partenzac :: Int}deriving (Show,Eq)

parse :: [Char] -> Stanza
parse str = let [a,b,c] = words str 
            in if (read a ::Int) < ((read b ::Int)-1) then Stanza ([(read a ::Int)..((read b ::Int)-1)]) (read c ::Int) else Stanza ([((read b ::Int)-1)..((read a ::Int))]) (read c ::Int)

collassainunicastanza :: Foldable t => t Stanza -> [[Int]]
collassainunicastanza stanzeconstessoid = foldr (\s acc->(giorniincuioccupata s):acc) [] stanzeconstessoid

flatt :: Foldable t => t [a] -> [a]
flatt list = foldr (++) [] list

eStanzaLIberaNeiGiorni :: Foldable t => t Int -> Stanza -> Bool
eStanzaLIberaNeiGiorni giorni stanza = not(any (\g -> elem g (giorniincuioccupata stanza)) giorni)

uniq :: (Foldable t, Eq a) => t a -> [a]
uniq ll = foldr (\x acc -> if elem x acc then acc else x:acc) [] ll

contadatoG :: (Foldable t, Eq a, Num b) => a -> t a -> b
contadatoG g listapren = foldr (\x acc-> if x == g then acc+1 else acc) 0 listapren  

out :: Show a => a -> [Char]
out n = "Stanza numero: " ++ (show n)++" disponibile "

out2 :: (Show a1, Show a2) => (a1, a2) -> [Char] -> [Char]
out2 (g,c) str = "In giorno: "++(show g)++" si sono contati: "++(show c)++str


main :: IO ()
main = do 

    -------------------------------------------------------------------------------
    inpStr <- readFile "miramar.txt"
    let liness = lines inpStr
    let stanze = map parse liness
    -------------------------------------------------------------------------------
    --                          Parte 1:
    -------------------------------------------------------------------------------
    putStrLn "Inserire arrivo cliente"
    _arrivo_cliente <- getLine
    
    putStrLn "Inserire partenza cliente"
    _partenza_cliente <- getLine

    let arrivo_cliente   = read _arrivo_cliente :: Int 
    let partenza_cliente = read _partenza_cliente :: Int 
    let cliente = Cliente arrivo_cliente partenza_cliente

    let stanzecolaps = map (\id -> Stanza (flatt (collassainunicastanza [s | s<-stanze, (numeroStanza s)==id])) id ) [1..20]

    let giorniRichiesiDalCliente = [(arrivoc cliente)..(partenzac cliente)]
    let stanzeLibere = uniq [(numeroStanza s) | s<-stanzecolaps,eStanzaLIberaNeiGiorni giorniRichiesiDalCliente s]

    if [] == stanzeLibere then 
        putStrLn "Nessuna data disponibile"
    else 
        putStrLn (unlines(map out stanzeLibere))
    
    -------------------------------------------------------------------------------
    --                          Parte 2:
    -------------------------------------------------------------------------------
    let tuteprenotazioni = foldr (\s acc -> giorniincuioccupata s ++ acc) [] stanzecolaps
    let countforday = map (\d-> (d,contadatoG d tuteprenotazioni)) [1..31]
    putStrLn (unlines(map (\t -> out2 t " prenotazioni") countforday ))

    let fcountforday = map (\d-> (d,(31 - contadatoG d tuteprenotazioni))) [1..31]
    putStrLn (unlines(map (\t -> out2 t " stanze libere") fcountforday ))