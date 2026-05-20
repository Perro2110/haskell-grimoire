## `>>=` (bind) vs `return` in Haskell

Sono entrambi parte della **typeclass `Monad`**, ma fanno cose opposte.

---

### `return`

Prende un valore puro e lo **"avvolge"** in un contesto monadico:

```haskell
return :: a -> m a

return 5        -- Maybe: Just 5
return 5        -- List:  [5]
return 5        -- IO:    IO 5
```
---

### `>>=` (bind)

Prende un valore **già in un contesto monadico**, lo estrae, applica una funzione, e restituisce un nuovo contesto monadico:

```haskell
(>>=) :: m a -> (a -> m b) -> m b
```

```haskell
Just 5  >>= \x -> Just (x + 1)   -- Just 6
Nothing >>= \x -> Just (x + 1)   -- Nothing

[1,2,3] >>= \x -> [x, x*10]      -- [1,10, 2,20, 3,30]
```

È il meccanismo che permette di **concatenare operazioni monadiche**.
