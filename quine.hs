module QuineMerge where

import Data.List  (nub, sort, sortBy, groupBy, intercalate, subsequences)
import Data.Maybe (mapMaybe)
import Data.Char  (intToDigit)


data Lit = Zero | One | X deriving (Eq, Ord)

instance Show Lit where
  show Zero = "0"
  show One  = "1"
  show X    = "-"

data Impl = Impl
  { pattern  :: [Lit]
  , covered  :: [Int]
  } deriving (Eq)

instance Show Impl where
  show (Impl p cvr) =
    concatMap show p ++ "  covers " ++ show cvr


fromMinterm :: Int -> Int -> Impl
fromMinterm vars m = Impl (toBits vars m) [m]

toBits :: Int -> Int -> [Lit]
toBits vars n = map bit (reverse [0 .. vars - 1])
  where bit i = if (n `div` 2^i) `mod` 2 == 1 then One else Zero

popcount :: Impl -> Int
popcount = length . filter (== One) . pattern


tryMerge :: Impl -> Impl -> Maybe Impl
tryMerge (Impl p1 c1) (Impl p2 c2) =
  let diffs = [ i | (i, (a, b)) <- zip [0..] (zip p1 p2), a /= b ]
  in  if length diffs == 1 && all (/= X) [p1 !! head diffs, p2 !! head diffs]
        then Just $ Impl (mergePattern p1 p2) (nub $ sort $ c1 ++ c2)
        else Nothing

mergePattern :: [Lit] -> [Lit] -> [Lit]
mergePattern = zipWith (\a b -> if a == b then a else X)


type Level = [Impl]

mergeAdjacentLevels :: [Level] -> ([Impl], [Impl])
mergeAdjacentLevels levels =
  let pairs    = zip levels (tail levels)
      merged   = nub [ m | (lo, hi) <- pairs
                         , a <- lo, b <- hi
                         , Just m <- [tryMerge a b] ]
      usedOnes = nub [ x | (lo, hi) <- pairs
                          , a <- lo, b <- hi
                          , Just _ <- [tryMerge a b]
                          , x <- [a, b] ]
  in (merged, usedOnes)


quineReduce :: [Impl] -> [Impl]
quineReduce implicants = go (groupByPopcount implicants) []
  where
    go levels primes
      | null newMerged = primes ++ concat levels   -- fixpoint
      | otherwise      =
          let survivors = filter (`notElem` used) (concat levels)
              newPrimes  = primes ++ survivors
              newLevels  = groupByPopcount newMerged
          in go newLevels newPrimes
      where
        (newMerged, used) = mergeAdjacentLevels levels

groupByPopcount :: [Impl] -> [Level]
groupByPopcount implicants =
  let sorted  = sortBy (\a b -> compare (popcount a) (popcount b)) implicants
      grouped = groupBy (\a b -> popcount a == popcount b) sorted
  in grouped


petrick :: [Int] -> [Impl] -> [Impl]
petrick minterms primes =
  let covers m   = filter (\p -> m `elem` covered p) primes
      -- For each minterm, the set of primes that cover it
      coverSets  = map covers minterms
      -- All combinations that cover every minterm
      solutions  = filter (coversAll minterms) (subsequences primes)
      -- Pick minimal by count, then by total literals
      minimal    = minimizeBy cost solutions
  in minimal
  where
    coversAll ms sol = all (\m -> any (elem m . covered) sol) ms
    cost sol         = (length sol, countLiterals sol)
    countLiterals    = sum . map (length . filter (/= X) . pattern)

minimizeBy :: Ord b => (a -> b) -> [a] -> a
minimizeBy _ []     = error "no solution"
minimizeBy f (x:xs) = foldl (\acc y -> if f y < f acc then y else acc) x xs


varName :: Int -> Int -> String
varName vars i = let names = map (:[]) ['A'..'Z'] in names !! (vars - 1 - i)

implToExpr :: Int -> Impl -> String
implToExpr vars (Impl p _) =
  let terms = mapMaybe toLit (zip [0..] p)
  in  if null terms then "1" else intercalate "" terms
  where
    toLit (i, One ) = Just $        varName vars i
    toLit (i, Zero) = Just $ varName vars i ++ "'"
    toLit (_, X   ) = Nothing

minimize :: Int -> [Int] -> String
minimize vars minterms =
  let initImpl  = map (fromMinterm vars) (nub $ sort minterms)
      primes    = nub $ quineReduce initImpl
      essential = petrick minterms primes
      expr      = intercalate " + " (map (implToExpr vars) essential)
  in  if null minterms then "0"
      else if length minterms == 2^vars then "1"
      else expr

demo :: IO ()
demo = do
  putStrLn "=== QuineMerge: Merge-Sort Style Exact Boolean Minimizer ===\n"

  -- Classic textbook example (4 vars): f = Σm(0,1,2,5,6,7,8,9,10,14)
  let ex1 = (4, [0,1,2,5,6,7,8,9,10,14])
  putStrLn $ "Example 1 (4 vars): f = Σm" ++ show (snd ex1)
  putStrLn $ "Minimized: f = " ++ uncurry minimize ex1
  putStrLn ""

  -- 3-variable example: f = Σm(1,3,5,7) → f = B (last var)
  let ex2 = (3, [1,3,5,7])
  putStrLn $ "Example 2 (3 vars): f = Σm" ++ show (snd ex2)
  putStrLn $ "Minimized: f = " ++ uncurry minimize ex2
  putStrLn ""

  -- Petrick-relevant: multiple equal solutions
  let ex3 = (4, [0,1,2,3,4,8,10,11,12,15])
  putStrLn $ "Example 3 (4 vars): f = Σm" ++ show (snd ex3)
  putStrLn $ "Minimized: f = " ++ uncurry minimize ex3
  putStrLn ""

  -- Degenerate: all minterms → tautology
  let ex4 = (2, [0,1,2,3])
  putStrLn $ "Example 4 (tautology): f = " ++ uncurry minimize ex4

main :: IO ()
main = demo