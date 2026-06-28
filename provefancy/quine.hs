module QuineMerge where

import Data.List  (nub, sort, sortBy, groupBy, intercalate, subsequences)


-- A literal slot: 0, 1, or Don't-Care (written − in textbooks).
data Lit = Zero | One | DC deriving (Eq, Ord)

instance Show Lit where
  show Zero = "0"
  show One  = "1"
  show DC   = "-"

-- An implicant: a bit-pattern (may contain DCs) + the minterms it covers.
data Impl = Impl
  { lits    :: [Lit]
  , covered :: [Int]
  } deriving (Eq)

instance Show Impl where
  show (Impl ls cv) = concatMap show ls ++ "  covers " ++ show cv


-- Bit layout: position 0 = MSB.
-- Variable naming convention (standard SOP):
--   n vars → names ["A"..] reversed so that A=LSB, <last letter>=MSB.
mintermToImpl :: Int -> Int -> Impl
mintermToImpl vars m = Impl (map (bitAt m) (reverse [0 .. vars-1])) [m]
  where bitAt n i = if odd (n `div` 2^i) then One else Zero

onesCount :: Impl -> Int
onesCount = length . filter (== One) . lits

-- Two implicants merge iff they share the same DC positions AND differ in
-- exactly one non-DC bit.  That bit becomes a new DC in the result.

tryMerge :: Impl -> Impl -> Maybe Impl
tryMerge (Impl ls1 cv1) (Impl ls2 cv2) =
  let diffs = [ i | (i, (a, b)) <- zip [0..] (zip ls1 ls2), a /= b ]
  in  if length diffs == 1
         && ls1 !! head diffs /= DC
         && ls2 !! head diffs /= DC
        then Just $ Impl (zipWith blendLit ls1 ls2)
                         (nub $ sort $ cv1 ++ cv2)
        else Nothing
  where blendLit a b = if a == b then a else DC


type Level = [Impl]

-- Partition implicants into groups of equal popcount (the "sorted buckets").
byOnesCount :: [Impl] -> [Level]
byOnesCount = groupBy (\a b -> onesCount a == onesCount b)
            . sortBy  (\a b -> compare (onesCount a) (onesCount b))

-- One merge pass: try every cross-product of adjacent level pairs.
-- Returns (newly produced implicants, implicants absorbed into something larger).
mergePass :: [Level] -> ([Impl], [Impl])
mergePass levels = (nub merged, nub absorbed)
  where
    pairs    = zip levels (tail levels)
    merged   = [ m | (lo, hi) <- pairs, a <- lo, b <- hi
                   , Just m <- [tryMerge a b] ]
    absorbed = [ x | (lo, hi) <- pairs, a <- lo, b <- hi
                   , Just _ <- [tryMerge a b], x <- [a, b] ]

-- Full reduction: accumulate prime implicants (those never absorbed)
-- until no new merges are possible — exactly the merge-sort fixpoint.
collectPrimes :: [Impl] -> [Impl]
collectPrimes = go [] . byOnesCount
  where
    go acc levels
      | null newMerged = acc ++ survivors ++ concat levels
      | otherwise      = go (acc ++ survivors) (byOnesCount newMerged)
      where
        (newMerged, absorbed) = mergePass levels
        survivors             = filter (`notElem` absorbed) (concat levels)

-- Among all subsets of prime implicants that cover every required minterm,
-- pick the one minimising (implicant count, total literal count).

petrick :: [Int] -> [Impl] -> [Impl]
petrick minterms primes = foldl1 better covers
  where
    covers     = filter (coversAll minterms) (subsequences primes)
    coversAll ms sol = all (\m -> any (elem m . covered) sol) ms
    cost sol   = ( length sol
                 , sum $ map (length . filter (/= DC) . lits) sol )
    better a b = if cost b < cost a then b else a

-- Variable names: A = LSB (rightmost), last letter = MSB (leftmost).
-- Example (4 vars): positions 0,1,2,3  →  D, C, B, A.

varNames :: Int -> [String]
varNames vars = reverse $ take vars $ map (:[]) ['A'..]

implToExpr :: Int -> Impl -> String
implToExpr vars (Impl ls _) =
  let terms = [ if lit == One then name else name ++ "'"
              | (name, lit) <- zip (varNames vars) ls
              , lit /= DC ]
  in  if null terms then "1" else intercalate "" terms


minimize :: Int    -- ^ number of variables
         -> [Int]  -- ^ on-set minterms
         -> String -- ^ minimized sum-of-products expression
minimize vars minterms
  | null minterms            = "0"
  | length minterms == 2^vars = "1"
  | otherwise                =
      let canon  = nub $ sort minterms
          primes = nub $ collectPrimes (map (mintermToImpl vars) canon)
          cover  = petrick canon primes
      in  intercalate " + " (map (implToExpr vars) cover)

demo :: IO ()
demo = mapM_ run examples
  where
    run (vars, ms, note) = do
      putStrLn $ show vars ++ " vars  Σm" ++ show ms
      putStrLn $ "  " ++ note
      putStrLn $ "  f = " ++ minimize vars ms
      putStrLn ""

    examples =
      [ ( 4, [0,1,2,5,6,7,8,9,10,14]
          , "classic 4-var textbook example" )
      , ( 3, [1,3,5,7]
          , "all odd 3-var minterms → should be A (LSB = 1)" )
      , ( 4, [0,1,2,3,4,8,10,11,12,15]
          , "4-var, Petrick selects between multiple equal covers" )
      , ( 3, [0,2,4,6]
          , "all even 3-var minterms → should be A' (LSB = 0)" )
      , ( 2, [0,1,2,3]
          , "tautology → 1" )
      , ( 3, []
          , "contradiction → 0" )
      ]

main :: IO ()
main = do
  putStrLn "=== QuineMerge: Merge-Sort Style Exact Boolean Minimizer ===\n"
  demo