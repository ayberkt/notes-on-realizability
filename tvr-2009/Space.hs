-- Basic definitions od spaces and their properties

module Space where

import Staged

-- Basic spaces

-- Partial Booleans

type PBool = Maybe Bool

por :: PBool -> PBool -> PBool
(Just True)   `por` q            = Just True
(Just False)  `por` q            = q
p             `por` (Just True)  = Just True
p             `por` (Just False) = p
Nothing       `por` Nothing      = Nothing

pand :: PBool -> PBool -> PBool
(Just True)   `pand` q            = q
(Just False)  `pand` q            = Just False
p             `pand` (Just True)  = p
p             `pand` (Just False) = Just False
Nothing       `pand` Nothing      = Nothing

pnot :: PBool -> PBool
pnot = fmap not

-- Staged partial Booleans

type SBool = Staged PBool

fmap2 :: (a -> b -> c) -> Staged a -> Staged b -> Staged c
fmap2 f x y = do u <- x
                 v <- y
                 return $ f u v

sor :: SBool -> SBool -> SBool
sor = fmap2 por

sand :: SBool -> SBool -> SBool
sand = fmap2 pand

snot :: SBool -> SBool
snot = fmap pnot

toBool :: SBool -> Bool
toBool p = loop (prec 0)
           where loop s = case approximate p s of
                              Nothing -> loop (Stage {precision = precision s+1, rounding = rounding s})
                              Just b -> b

-- Properties of spaces

class Hausdorff s where
  neq :: s -> s -> SBool
  
class Discrete s where
  eq :: s -> s -> SBool

class Compact s where
  forall :: (s -> SBool) -> SBool
  
class Overt s where
  exists :: (s -> SBool) -> SBool
