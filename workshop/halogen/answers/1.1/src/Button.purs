module Button where

import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Math ((%))

type State = Int

data Query a
  = Toggle a

myButton :: forall m. H.Component HH.HTML Query Unit Void m
myButton =
  H.component
    { initialState: const initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where

  initialState :: State
  initialState = 0

  divisibleBy :: Int -> Int -> Boolean
  divisibleBy x n = toNumber x % toNumber n == 0.0

  render :: State -> H.ComponentHTML Query
  render state =
    let
      label = 
        case Tuple (state `divisibleBy` 5) (state `divisibleBy` 3) of 
          (Tuple true true)  -> "FizzBuzz" 
          (Tuple true false) -> "Buzz"
          (Tuple false true) -> "Fizz"
          _                  -> show state
    in
      HH.button
        [ HP.title label
        , HE.onClick (HE.input_ Toggle)
        ]
        [ HH.text label ]

  eval :: Query ~> H.ComponentDSL State Query Void m
  eval = case _ of
    Toggle next -> do
      void $ H.modify (_ + 1)
      pure next

