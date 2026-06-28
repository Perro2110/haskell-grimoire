# 📘 Haskell — Notes and Core Concepts

Summary of explanations and code examples for key Haskell concepts.
Full code available in `conoscenze.hs`

> [!TIP]
> It is recommended to read the `conoscenze.hs` file for complete, working code, while this `README.md` contains explanations and code snippets.

---

## 1. Basic Functions

In Haskell every function has a **type signature** and a **definition**. The syntax is clean and declarative.

```haskell
double :: Int -> Int
double x = x + x

quadruple :: Int -> Int
quadruple x = double(double x)
```

Functions are **pure**: given the same input, they always return the same output, with no side effects.

---

## 2. Pattern Matching

**Pattern matching** allows you to define different behaviors based on the structure of an argument. It is one of the most powerful mechanisms in Haskell.

```haskell
-- On specific values
or :: Bool -> Bool -> Bool
or True _ = True
or _ True = True
or _ _    = False

-- On lists
last4 :: [a] -> a
last4 [a]   = a
last4 (a:b) = last4 b
```

The `_` symbol is a **wildcard**: it indicates that the value is not of interest.

---

## 3. Guards

**Guards** are boolean conditions that select which branch to execute. They use `|`.

```haskell
abs :: Int -> Int
abs n | n < 0     = -n
      | otherwise = n

last3 :: [a] -> a
last3 (a:b) | (length b) /= 0 = last3 b
            | otherwise       = a
```

`otherwise` is equivalent to `True` and is used as the default case.

---

## 4. Recursion

Haskell has no `for` or `while` loops. **Recursion** is used to iterate.

```haskell
mfactorial :: Int -> Int
mfactorial n = foldr (*) 1 [1..n]

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (l:t) = reverse' t ++ [l]

length' [] = 0
length' (a:b) = 1 + length' b
```

The typical pattern is: **base case** (empty list or single value) + **recursive case**.

---

## 5. Lists

Lists are the most used data type in Haskell. Some fundamental operations:

| Operation | Function |
|---|---|
| First element | `head` |
| Rest of the list | `tail` |
| Length | `length` |
| Concatenation | `++` |
| Reversal | `reverse` |
| Index access | `!!` |

```haskell
-- Different implementations of "last element"
last1 a = head(reverse(a))
last2 a = a !! ((length a) - 1)
last4 [a]   = a
last4 (a:b) = last4 b
```

### The `(a:b)` syntax

The `(a:b)` construct **deconstructs** a list: `a` is the head and `b` is the tail.

```haskell
concatenate :: [a] -> [a] -> [a]
concatenate [] b    = b
concatenate (a:b) c = a : concatenate b c
```

---

## 6. Higher-Order Functions

Haskell treats functions as values: they can be passed as arguments or returned.

### `map`
Applies a function to every element of a list.

```haskell
quadList :: [Int] -> [Int]
quadList a = map (\x -> x * x) a

acronym :: [String] -> [Char]
acronym a = map (\x -> head x) a
```

### `filter`
Selects elements that satisfy a predicate.

```haskell
positives :: [Int] -> [Int]
positives a = filter (\x -> x > 0) a

vowels :: [Char] -> [Char]
vowels a = filter (\x -> elem x "aeiou") a
```

### `foldr` — right fold

Reduces a list to a single value by applying a function **from the right**. Syntax: `foldr f initial_value list`.

**How it works internally:**

```haskell
foldr' f x []    = x
foldr' f x (a:b) = f a (foldr' f x b)
```

The recursion descends to the end of the list **before** applying any operation. The initial value is the rightmost argument of the whole expression:

```
foldr (+) 0 [1,2,3]
  → 1 + (foldr (+) 0 [2,3])
  → 1 + (2 + (foldr (+) 0 [3]))
  → 1 + (2 + (3 + 0))          ← built starting from the end
  → 6
```

In general: `foldr f z [a,b,c]` becomes `f a (f b (f c z))`.

```haskell
sumf a = foldr (+) 0 a       -- sum
prod a = foldr (*) 1 a       -- product

-- Count elements
lengthFold a = foldr (\ x n -> n + 1) 0 a

-- Count vowels
vowelCount :: [Char] -> Int
vowelCount a = foldr (\ x n -> if (elem x "aeiou") then n + 1 else n) 0 a
```

### `foldl` — left fold

Like `foldr` but accumulates **from the left**. The accumulator is updated at each step without waiting for the end of the list.

**How it works internally:**

```haskell
foldl' f v []     = v
foldl' f v (x:xs) = foldl' f (f v x) xs
```

At each recursive step, the function is **applied immediately** to the current accumulator:

```
foldl (+) 0 [1,2,3]
  → foldl (+) (0+1) [2,3]
  → foldl (+) ((0+1)+2) [3]
  → foldl (+) (((0+1)+2)+3) []
  → ((0+1)+2)+3                ← accumulated from the left
  → 6
```

In general: `foldl f v [a,b,c]` becomes `f (f (f v a) b) c`.

### `foldr` vs `foldl` comparison

| | `foldr f z [a,b,c]` | `foldl f v [a,b,c]` |
|---|---|---|
| Expansion | `f a (f b (f c z))` | `f (f (f v a) b) c` |
| Associativity | right | left |
| Evaluates first | end of list | head of list |
| Infinite lists | works (lazy) | does not terminate |
| Efficiency | less efficient on long lists | more efficient with accumulator |

> **Practical rule:** use `foldr` when you want to build a new list or work lazily. Use `foldl` (or better `foldl'` from `Data.List`) when accumulating a value over finite lists.

### Point-free versions with `foldr`

```haskell
s :: [Int] -> Int
s = foldr (+) 0

p :: [Int] -> Int
p = foldr (*) 1

o :: [Bool] -> Bool
o = foldr (||) False

aa :: [Bool] -> Bool
aa = foldr (&&) True
```

---

## 7. Lambdas (Anonymous Functions)

**Lambdas** are written with `\x -> expression`. They are useful with `map`, `filter`, `foldr`, etc.

```haskell
map (\x -> x * x) [1,2,3]          -- [1,4,9]
filter (\x -> x > 0) [-1,2,-3,4]   -- [2,4]
```

---

## 8. Currying and Partial Application

In Haskell every function accepts **one argument at a time** and returns a new function for each subsequent argument. This is called **currying**.

```haskell
multiply :: Int -> Int -> Int
multiply x y = x * y

double2 = multiply 2   -- partially applied function
triple2 = multiply 3

-- With list functions
addOne       = map (+1)     -- adds 1 to every element
greaterThan5 = filter (>5)  -- filters values > 5

-- Example with gravity
gravity :: Float -> Float -> Float -> Float
gravity m1 d m2 = ((6.67 * 1/10^11) * (m1 * m2)) / (d * d)

earthGravity :: Float -> Float -> Float
earthGravity = gravity (5.972 * 10^24)   -- m1 fixed to Earth's mass

earthGravitySurface = earthGravity 6371000  -- d fixed to Earth's radius

-- Sections
log2 :: Float -> Float
log2 = logBase 2

rec :: Float -> Float
rec = (1/)
```

---

## 9. `zip` and Correspondences

`zip` joins two lists into a list of pairs. Useful for comparing elements at corresponding positions. It stops at the shorter list.

```haskell
-- zip [1,2,3] ["a","b","c"] → [(1,"a"),(2,"b"),(3,"c")]

correspondences listA listB =
    filter (\(x, y) -> x == y) (zip listA listB)
```

---

## 10. Tuples

**Tuples** group a fixed number of values, possibly of different types.

```haskell
addVect :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVect a b = (fst a + fst b, snd a + snd b)
```

- `fst` returns the first element of a pair
- `snd` returns the second element

---

## 11. Types and Polymorphism

Haskell is **strongly typed** but supports **polymorphism**: generic functions that work on any type.

```haskell
-- [a] means "list of any type"
last4 :: [a] -> a
reverse' :: [a] -> [a]

-- (Num a) is a constraint: a must be a numeric type
addVect :: (Num a) => (a, a) -> (a, a) -> (a, a)
```

---

## 12. Characters and Strings

In Haskell a `String` is simply a list of `Char` (`[Char]`).

```haskell
nsucc :: Char -> Int -> Char
nsucc c n = toEnum (fromEnum c + n)

-- Caesar cipher
cypher :: [Char] -> Int -> [Char]
cypher a num = map (\x -> nsucc x num) a
```

- `fromEnum` converts a `Char` to its numeric code (ASCII/Unicode)
- `toEnum` does the reverse

---

## 13. Functions on Lists of Functions

In Haskell functions are first-class values and can be put in a list. This allows you to apply multiple checks in sequence in an elegant way.

```haskell
funandmap :: [(a -> Bool)] -> a -> Bool
funandmap [] b     = True
funandmap (a:at) b = a b && funandmap at b

-- Example: checker that combines multiple validators
checker :: [Char] -> Bool
checker a = funandmap [check_digits, check_lower, check_upper, check_length] a
```

---

## 14. Complete Example — Password Validator

Requirements: length > 15, at least one lowercase letter, at least one uppercase letter, at least one digit.

```haskell
-- Modular version (4 separate checkers)
checker_1 :: [Char] -> Bool
checker_1 a = (foldr (\ x n -> n + 1) 0 a) > 15

checker_2 :: [Char] -> Bool
checker_2 a = (foldr (\ x n -> if elem x ['A'..'Z'] then n+1 else n) 0 a) > 1

checker_3 :: [Char] -> Bool
checker_3 a = (foldr (\ x n -> if elem x ['a'..'z'] then n+1 else n) 0 a) > 1

checker_4 :: [Char] -> Bool
checker_4 a = (foldr (\ x n -> if elem x ['0'..'9'] then n+1 else n) 0 a) > 1

checker :: [Char] -> Bool
checker a = funandmap [checker_4, checker_3, checker_2, checker_1] a

-- Compact version (everything in one function)
checker_lite :: [Char] -> Bool
checker_lite a =
    ((foldr (\ x n -> n + 1) 0 a) > 15) &&
    (foldr (\ x n -> elem x ['a'..'z'] || n) False a) &&
    (foldr (\ x n -> elem x ['A'..'Z'] || n) False a) &&
    (foldr (\ x n -> elem x ['0'..'9'] || n) False a)
```

---

## 15. Function Composition

The `.` operator composes two functions: `(f . g) x` is equivalent to `f (g x)`. It allows building elegant pipelines without naming arguments (**point-free** style).

```haskell
-- Without composition
isOdd x = not (even x)

-- With composition
odd' :: Int -> Bool
odd' = not . even
-- odd' 3 → not (even 3) → not False → True

-- Longer pipeline
capitalInitial :: String -> Char
capitalInitial = toUpper . head
-- first head, then toUpper
```

The `.` operator reads "after": `not . even` means "not *after* even". Reading goes **right to left**.

---

## 16. `zipWith` — zip with a Function

`zipWith` is the generalization of `zip`: instead of creating pairs, it applies a function to the corresponding elements of two lists.

```haskell
zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' f [] _        = []
zipWith' f _ []        = []
zipWith' f (a:b) (c:d) = f a c : zipWith' f b d

-- Examples
zipWith (+) [1,2,3] [10,20,30]   -- [11,22,33]
zipWith (*) [1,2,3] [4,5,6]      -- [4,10,18]

-- Check if a list is sorted
sorted :: (Ord a) => [a] -> Bool
sorted a = and (zipWith (<=) a (tail a))
-- [1,2,3] → zipWith (<=) [1,2,3] [2,3] → [True,True] → True

-- Version with all
sorted' :: (Ord a) => [a] -> Bool
sorted' a = all (== True) (zipWith (<=) a (tail a))
```

`zip` is the special case `zipWith (,)`.

---

## 17. List Comprehension

**List comprehension** is a compact syntax for generating lists, inspired by mathematical set notation. `{ x² | x ∈ [1..5] }` becomes `[x*x | x <- [1..5]]`.

```haskell
-- Basic syntax: [expression | generator, guard]

-- Squares of even numbers
[x*x | x <- [1..10], even x]
-- [4,16,36,64,100]

-- Pairs (x,y) with x <= y
[(x,y) | x <- [1..3], y <- [x..3]]
-- [(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)]

-- n×n multiplication table
multiplicationTable n = [[x*y | x <- [1..n]] | y <- [1..n]]

-- Cartesian product: generator order matters!
[(x,y) | y <- [4,5], x <- [1,2,3]]
-- [(1,4),(2,4),(3,4),(1,5),(2,5),(3,5)]
-- y varies more slowly (it is the outer generator)
```

List comprehensions can always be rewritten with `map` and `filter`:

| Comprehension | Equivalent |
|---|---|
| `[f x \| x <- xs]` | `map f xs` |
| `[x \| x <- xs, p x]` | `filter p xs` |
| `[f x \| x <- xs, p x]` | `map f (filter p xs)` |

### List comprehension on infinite lists

Lazy evaluation allows using list comprehensions on infinite sequences. The trick is to combine a `[1..]` generator with a costly predicate: Haskell only computes the elements actually needed.

```haskell
-- Taxicab numbers: expressible as sum of two cubes in at least 2 ways
taxicab :: [Int]
taxicab = [ n | n <- [1..], length (pairs n) >= 2 ]

pairs :: Int -> [(Int,Int)]
pairs n = [ (x,y) | x <- [1..n], y <- [x+1..n], x^3 + y^3 == n ]

-- take 3 taxicab → [1729, 4104, 13832]
```

---

## 18. Lazy Evaluation

Haskell uses **lazy evaluation**: expressions are computed only when their value is actually needed. This allows defining potentially infinite data structures.

```haskell
-- Infinite list of Hamming numbers (divisible only by 2, 3, or 5)
_hamming = 1 : merge (map (*2) hamming)
                     (merge (map (*3) hamming) (map (*5) hamming))

hamming = uniq _hamming

-- take 10 hamming → [1,2,3,4,5,6,8,9,10,12]
```

The `uniq` function removes adjacent duplicates (needed because the three sequences `*2`, `*3`, `*5` can produce the same value):

```haskell
uniq [] = []
uniq (a:as) = a : filter (/= a) (uniq as)
```

The `hamming` list is defined **in terms of itself**: this is possible because Haskell does not evaluate the entire list, but builds each element only when requested via `take`, `head`, etc.

**Eager vs lazy**: in eager evaluation every expression is computed immediately; in lazy evaluation a "thunk" (a promise of computation) is created and forced only when necessary. The advantage is being able to work with infinite structures; the downside is memory overhead if thunks accumulate without being consumed.

> [!IMPORTANT]
> Note that `foldr` can work with infinite lists if the combining function is **non-strict** (i.e., it does not immediately evaluate its second argument). For example, `foldr (&&) True` can terminate on an infinite list of `False` without scanning the whole list.

---

## 19. Removing Duplicates

### Consecutive duplicates — `remdups`

Removes only **adjacent** duplicates (the list must be sorted for this to be a complete deduplication).

```haskell
remdups :: (Eq a) => [a] -> [a]
remdups [] = []
remdups [a] = [a]
remdups (a:b:xs) | a == b    = remdups (b:xs)
                 | otherwise = a : remdups (b:xs)

-- remdups [1,1,2,2,2,3] → [1,2,3]
-- remdups [1,2,1,2]     → [1,2,1,2]  (unsorted list stays the same!)
```

Version with `foldr`:

```haskell
remdupsf :: (Eq a) => [a] -> [a]
remdupsf [] = []
remdupsf (a:as) = foldr (\x acc -> if x == head acc then acc else x:acc) [a] as
```

---

## 20. Maximum with Ordering Function

`maxf` finds the element that maximises the value produced by a function `f`, using `foldr`:

```haskell
maxf :: (Ord b) => (a -> b) -> [a] -> a
maxf f (a:b) = foldr (\x y -> if f x >= f y then x else y) a b

-- Example: longest word
maxf length ["cat","elephant","ox"]   -- "elephant"

-- Number with greatest absolute value
maxf abs [-10, 3, -5, 8]             -- -10
```

---

## 21. Sorting Algorithms — Merge Sort

**Merge sort** is a divide-and-conquer algorithm: it splits the list in half, recursively sorts each half, then merges them while preserving order.

```haskell
merge :: (Ord a) => [a] -> [a] -> [a]
merge a [] = a
merge [] a = a
merge (a:b) (c:d) | a < c     = a : merge b (c:d)
                  | otherwise = c : merge (a:b) d

mergeSort :: (Ord a) => [a] -> [a]
mergeSort []  = []
mergeSort [a] = [a]
mergeSort a   = let (l,r) = splitAt (length a `div` 2) a
                in merge (mergeSort l) (mergeSort r)

-- mergeSort [5,1,3,2,4] → [1,2,3,4,5]
```

`splitAt n xs` splits `xs` into two halves: the first `n` elements and the rest.

---

## 22. Distance Calculation

`distance` calculates the total length of a path given as a list of `(Float, Float)` points:

```haskell
distancePair :: ((Float,Float),(Float,Float)) -> Float
distancePair (a,b) = sqrt (((fst a - fst b)^2) + ((snd a - snd b)^2))

distance :: [(Float,Float)] -> Float
distance a = foldr (\x acc -> acc + distancePair x) 0 (zip a (tail a))

-- distance [(0,0),(3,0),(3,4)] → 7.0  (3 + 4)
```

`zip a (tail a)` produces the pairs of consecutive points; the Euclidean distance is computed for each pair, then summed with `foldr`.

---

## 23. Generic Finite State Automata

`generic_fsm` models a finite state automaton generically: given a list of inputs, an initial state, an **output function** (Moore) and a **state transition function**, it produces a list of `(output, new_state)` pairs.

```haskell
generic_fsm :: [a] -> s -> (a -> s -> o) -> (a -> s -> s) -> [(o, s)]
generic_fsm [] _ _ _                    = []
generic_fsm (read:rest) state msf snf =
    (msf read state, snf read state)
    : generic_fsm rest (snf read state) msf snf
```

- `a` is the input type (symbol read)
- `s` is the state type
- `o` is the output type
- `msf` (Moore State Function) computes the output given input and current state
- `snf` (State Next Function) computes the next state

---

## 24. Algebraic Data Types

Haskell allows defining new types with the `data` keyword. These types can be **recursive** and have **constructors** that act as patterns.

### Arithmetic expressions — `Expr`

```haskell
data Expr = Val Int
          | Add Expr Expr
          | Mul Expr Expr

-- Example: (2 + 3) * 4
example :: Expr
example = Mul (Add (Val 2) (Val 3)) (Val 4)

eval :: Expr -> Int
eval (Val n)   = n
eval (Add x y) = eval x + eval y
eval (Mul x y) = eval x * eval y

size :: Expr -> Int
size (Val n)   = 1
size (Add x y) = size x + size y
size (Mul x y) = size x + size y

-- eval example → 20
-- size example → 3  (number of Val nodes in the structure)
```

The `Expr` type is recursive: `Add` and `Mul` themselves contain other `Expr` values. Pattern matching on constructors allows navigating the tree structure naturally.

### Binary trees — `Tree`

```haskell
data Tree a = Leaf a
            | Node (Tree a) a (Tree a)

-- Check if the tree is balanced (every node has 0 or 2 children of the same kind)
is_binary_tree :: Tree a -> Bool
is_binary_tree (Node (Node _ _ _) _ (Leaf _)) = False
is_binary_tree (Node (Leaf _) _ (Node _ _ _)) = False
is_binary_tree (Node (Leaf _) _ (Leaf _))     = True
is_binary_tree (Node left _ right)            =
    is_binary_tree left && is_binary_tree right
```

### Peano natural numbers — `Nat`

A purely structural representation of natural numbers: `Zero` corresponds to 0, `Succ n` corresponds to `n + 1`.

```haskell
data Nat = Zero | Succ Nat
    deriving (Show)

nat2int :: Nat -> Int
nat2int Zero     = 0
nat2int (Succ n) = 1 + nat2int n

int2nat :: Int -> Nat
int2nat 0 = Zero
int2nat n = Succ (int2nat (n-1))

-- Recursive addition
add :: Nat -> Nat -> Nat
add m n = int2nat (nat2int m + nat2int n)

-- Recursive multiplication (without conversion)
mult :: Nat -> Nat -> Nat
mult n Zero     = Zero
mult n (Succ m) = add n (mult n m)
-- n * (Succ m)  =  n + n*m   (standard recursive definition)
```

`mult` shows how multiplication can be defined recursively without ever converting to `Int`: `n * 0 = 0` and `n * (m+1) = n + n*m`.

---

## 25. Application: D'Hondt Method

The **D'Hondt method** is a proportional algorithm for allocating parliamentary seats. For each party the quotients `votes / 1`, `votes / 2`, `votes / 3`, … are computed and seats are assigned to the highest quotients.

```haskell
-- Generate the infinite sequence of quotients for each party
dHondt h = [ [(div v j, j) | v <- vs, j <- [1..]] | vs <- h ]

-- Assign n seats given a set of quotients (list of sorted lists)
seats :: Int -> [[(Int, Int, Int)]] -> [(Int, Int, Int)]
seats n h = take n . foldl1 merge $ zipWith tag h [1..]
  where
    tag xs i = map (\(x,j) -> (x,j,i)) xs
    merge [] ys = ys
    merge xs [] = xs
    merge (x:xs) (y:ys)
      | fst3 x >= fst3 y = x : merge xs (y:ys)
      | otherwise        = y : merge (x:xs) ys
    fst3 (v,_,_) = v
```

The `seats` function uses an alternative approach with `foldr` to build a sorted ranking of quotients, then counts how many seats go to each party.

---

## Summary — Useful Functions

| Function | Description |
|---|---|
| `head` / `tail` | First element / rest of the list |
| `reverse` | Reverses a list |
| `length` | Length of a list |
| `map f xs` | Applies `f` to every element |
| `filter p xs` | Keeps elements satisfying `p` |
| `foldr f z xs` | Right fold (`z` = initial value) |
| `foldl f v xs` | Left fold (`v` = accumulator) |
| `zip xs ys` | Joins two lists into a list of pairs |
| `zipWith f xs ys` | Applies `f` to corresponding elements |
| `splitAt n xs` | Splits the list at position `n` |
| `elem x xs` | `True` if `x` belongs to `xs` |
| `fst` / `snd` | First / second element of a pair |
| `fromEnum` / `toEnum` | `Char` ↔ `Int` conversion |
| `logBase b x` | Logarithm of `x` in base `b` |
| `(f . g)` | Composition: applies `g` then `f` |
| `all p xs` | `True` if all elements satisfy `p` |
| `and xs` / `or xs` | AND / OR over a list of booleans |
| `take n xs` | First `n` elements |
| `drop n xs` | List without the first `n` elements |

---

```
Haskell is a purely functional language where:
  - Everything is a function
  - There are no mutable variables
  - Recursion replaces loops
  - Pattern matching makes code readable
  - Currying enables partial application
  - Types guarantee correctness at compile-time
  - foldr builds from the end: f a (f b (f c z))
  - foldl accumulates from the left: f (f (f v a) b) c
  - zip/zipWith allow working on pairs of lists in parallel
  - (.) composes functions in point-free style
  - List comprehensions combine map and filter in readable syntax
  - Lazy evaluation enables infinite lists and structures
  - Algebraic types (data) model recursive structures like trees and expressions
  - Peano numbers show how arithmetic can derive from structure
```

> [!CAUTION]
> Note that everything was written from scratch and then reworked with the help of LLMs.