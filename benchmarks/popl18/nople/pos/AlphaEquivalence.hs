{-@ LIQUID "--reflection"     @-}
{-@ LIQUID "--alphaequivalence"  @-}
{-@ LIQUID "--betaequivalence"  @-}

module ApplicativeReader where

import Prelude hiding (fmap, id, seq, pure)

import Language.Haskell.Liquid.ProofCombinators 

{-@ reflect seq @-}
seq :: (r -> (a -> b)) -> (r -> a) ->  (Reader r b)
seq f x =  Reader (\r -> (f r) (x r))

data Reader r a     = Reader { runIdentity :: r -> a }


{-
This cannot be verified, as it creates the query 

;; vv = Reader (lam @2. ((lam @1. x @1) @2) (y @2))
;; dd = Reader (lam @1. (d1nc @1) (y @1))
;; d1nc = lam @1. (x @1)

-}

{-@ composition' :: x: (r -> (a -> a))
                -> y:(r -> a)
                -> { ((
                   (\r2:r -> ((\r1:r ->  (x r1)) (r2)) (y r2))
                         )                                    
                  == 
                   ((\r3:r ->  (x r3) ( y r3))
                         ) )
                   } @-}
composition' :: (r -> (a -> a)) -> (r-> a) -> Proof
composition' x y
  = trivial 