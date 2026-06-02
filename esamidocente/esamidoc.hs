data Risultati = Risultati{nome :: String ,cognome :: String ,giorno :: Int ,mese :: Int ,anno:: Int,voto::Int}deriving(Show,Eq)
data Persona = Persona{nomee :: String ,cognomee :: String}deriving(Show,Eq)
data PersonaConSuoStorico = PersonaConSuoStorico{nn::String,cc::String,vs::[Int]}deriving(Show,Eq)

parse_pers str = let [nome,cognome,giorno,mese,anno,voto] = words str
    in Persona nome cognome 

uniqq lis = foldr (\x acc -> x : filter (/=x) acc) [] lis

parse_ris str = 
    let [nome,cognome,giorno,mese,anno,voto] = words str
    in Risultati nome cognome (read giorno :: Int) (read mese :: Int) (read anno :: Int) (read voto :: Int)

tuttiesamidix persona risultati = [x| x<-risultati , nome x == nomee persona, cognome x == cognomee persona]

ultimoesamedip person ris = head (reverse (tuttiesamidix person ris))

core2 [] = []
core2 (storicodipersonax:storici) = (PersonaConSuoStorico (nome(head storicodipersonax)) (cognome (head storicodipersonax)) (map voto storicodipersonax)):core2 storici

main = do
    inpStr <- readFile "esami.txt"
    --print inpStr
    let liness = lines inpStr
    --print liness
    let ris = map parse_ris liness
    --print ris

    print "=============================="
    let person = uniqq (map parse_pers liness)
    --print person

    -- PRIMA PARTE -- 
    --let testa = head person 
    --let m = ultimoesamedip testa ris

    let core = map (\p -> ultimoesamedip p ris) person

    let _output = map (\s -> unwords [nome s, cognome s, (show (giorno s)),(show (mese s)),(show (anno s)),(show (voto s))]) core
    let output = (unlines _output)
    putStrLn output

    print "=============================="
    -- SECONDA PARTE -- 
    let storici = map (\p -> tuttiesamidix p ris ) person
    let _outputfinale = core2 storici
        
    let outputfinale = map (\s -> unwords [nn s, cc s, (show (vs s))]) _outputfinale
    let outputfinalee = (unlines outputfinale)
    putStrLn outputfinalee