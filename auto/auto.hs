data Tipo = Tipo {identificativoTipo :: Int, ariaCondizionata :: Bool, tettuccioApribile :: Bool, numAutoRichieste :: Int}deriving(Show,Eq)
data Auto = Auto {numeroProg :: Int, tipoDaProdurre :: Int}deriving(Show,Eq)

parsetipo str = 
    let [tipo,aria,tettuccio,numero] = words str 
    in Tipo (read tipo :: Int) (read aria :: Bool) (read tettuccio :: Bool) (read numero :: Int)

parseautodaprodurre str = 
    let [num,tipo] = words str 
    in Auto (read num :: Int) (read tipo :: Int)

prendiprimi4 autodaprodurre = take 4 autodaprodurre
prendiprimi2 autodaprodurre = take 2 autodaprodurre


getinfosutipidatoid tipi id = head [t | t<- tipi, identificativoTipo t == id]


contaquantaiconf [] tipi f n = n
contaquantaiconf (auto:autos) tipi f n 
                                    | f (getinfosutipidatoid tipi (tipoDaProdurre auto)) =  contaquantaiconf autos tipi f n+1
                                    | otherwise                                          =  contaquantaiconf autos tipi f n


nonpiudiNconF auto tipi f n 
                                    | (contaquantaiconf auto tipi f 0) <= n = True 
                                    | otherwise                             = False 


_controllo [] tipi quantifaretake caratteristica quantialmeno = [True]
_controllo (autodaprodurre:autodaprodurres) tipi quantifaretake caratteristica quantialmeno
                                                    | nonpiudiNconF (autodaprodurre:(take quantifaretake autodaprodurres)) tipi caratteristica quantialmeno = True : _controllo autodaprodurres tipi quantifaretake caratteristica quantialmeno
                                                    | otherwise                                                                                             = False: _controllo autodaprodurres tipi quantifaretake caratteristica quantialmeno

controllo autodaprodurre tipi quantifaretake caratteristica quantialmeno = and (_controllo autodaprodurre tipi quantifaretake caratteristica quantialmeno)

quantitipox [] tipox num = num 
quantitipox (auto:autos) tipox num 
                                    | (tipoDaProdurre auto)  == tipox = quantitipox autos tipox num+1
                                    | otherwise                       = quantitipox autos tipox num


_controllodirichieste [] autos          = [True]
_controllodirichieste (tipo:tipi) autos 
                                        | (numAutoRichieste tipo) >= (quantitipox autos (identificativoTipo tipo) 0) = True:_controllodirichieste tipi autos 
                                        | otherwise                                                                = False:_controllodirichieste tipi autos 




main = do
    print "=========LEGGO TIPI==========="
    inpstr <- readFile "richiesteAuto.txt"
    let liness = lines inpstr
    let tipi = map parsetipo liness
    print tipi 

    print "=========LEGGO SEQU==========="
    inpstr2 <- readFile "sequenzaAuto.txt"
    let liness2 = lines inpstr2
    let autodaprodurre = map parseautodaprodurre liness2
    print autodaprodurre

    print "=========Controllo A==========="
    let veritaControlloA = controllo autodaprodurre tipi 4 ariaCondizionata 3
    print veritaControlloA

    print "=========Controllo B==========="
    let veritaControlloB = controllo autodaprodurre tipi 2 tettuccioApribile 1
    print veritaControlloB

    print "==============================="
    print "==I VINCOLI DI LINEA SONO:   == "
    if (veritaControlloB && veritaControlloA) 
        then print "== Rispettati                =="
    else print "== NON Rispettati entrambi   =="
    print "==============================="

    print "controllo se posso farne numero macchine rispetto a qunte posso fare di quel tipo:"
    let ccount = _controllodirichieste tipi autodaprodurre
    let veritas = and ccount
    if veritas then print "CONFERMO POSSO FARNE NUMERO X" else print "NON POSSO FARNE TROPPO DI UN TIPO !!"




