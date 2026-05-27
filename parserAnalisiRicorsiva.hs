
-- s ->   p x | q x
-- x -> a x b | x 
-- y -> a y d | y 

s :: String -> (Bool,String)
s ('p':t) = x t 
s ('q':t) = y t 
s xs = (False,xs)

x :: String -> (Bool,String)
x ('a':t) = let (b,r) = x t in (b && head r == 'b', tail r)
x ('x':t) = (True,t)
x xs = (False,xs)

y :: String -> (Bool,String)
y ('a':t) = let (b,r) = y t in (b && head r == 'd', tail r)
y ('y':t) = (True,t)
y xs = (False,xs)