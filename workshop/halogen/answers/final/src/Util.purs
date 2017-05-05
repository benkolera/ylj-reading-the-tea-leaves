module Util where

import Prelude
import Data.Array (replicate)
import Data.Foldable (fold)
import Data.String as Str

padDigits :: Int -> String
padDigits i = fold (replicate(max 0 (2 - Str.length intStr)) "0") <> intStr
  where
    intStr     = show i

