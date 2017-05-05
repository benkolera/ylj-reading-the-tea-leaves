module Pomodoro where

import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Now (NOW, now)
import Data.DateTime (DateTime, diff)
import Data.DateTime.Instant (toDateTime)
import Data.Foldable (traverse_)
import Data.Int (round, toNumber)
import Data.Maybe (Maybe(..), maybe)
import Data.Newtype (un)
import Data.Time.Duration (Milliseconds(..))
import Util as Util

data Query a 
  = StartTimer Int String a
  | PomodoroTick DateTime a

type Timer = 
  { millisLeft :: Int
  , lastTimed  :: DateTime
  , taskId     :: Int
  , taskTitle  :: String
  }

type State = { timer :: Maybe Timer }
data Output 
  = TimerDone Int
  | TimerElapsed Int Milliseconds

type DslEff e  = Eff (now :: NOW | e) 
type Dsl e = H.ComponentDSL State Query Output (DslEff e)

pomodoro :: forall e. H.Component HH.HTML Query Unit Output (DslEff e)
pomodoro = H.component 
    { initialState: const initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where
    initialState :: State
    initialState = { timer : Nothing }

    render :: State -> H.ComponentHTML Query
    render state = HH.section [HP.class_ (H.ClassName "pomodoro")]
      [maybe renderSelector renderTimer state.timer]
    
    renderSelector :: H.ComponentHTML Query
    renderSelector = HH.section [HP.class_ (H.ClassName "timer-selector")]
      [ HH.div 
        [HP.class_ (H.ClassName "timer-selector-msg")] 
        [HH.text "Please select a task below..." ]]
    
    renderTimer :: Timer -> H.ComponentHTML Query
    renderTimer timer = HH.section [HP.class_ (H.ClassName "timer")]
      [ HH.span [HP.class_ (H.ClassName "timer-minutes")] [renderDigits minutesLeft]
      , HH.span [HP.class_ (H.ClassName "timer-colon")] [HH.text ":"]
      , HH.span [HP.class_ (H.ClassName "timer-minutes")] [renderDigits secondsLeft]
      ]
      where
        allSecondsLeft = round (toNumber timer.millisLeft / 1000.0)
        secondsLeft    = max 0 (allSecondsLeft `mod` 60)
        minutesLeft    = max 0 (allSecondsLeft `div` 60)

    renderDigits :: Int -> H.ComponentHTML Query
    renderDigits = HH.text <<< Util.padDigits 

    eval :: Query ~> Dsl e
    eval = case _ of
      PomodoroTick n next -> do
        H.gets _.timer >>= traverse_ (tickTimer n)
        pure next
      StartTimer id title next -> do
        n <- toDateTime <$> H.liftEff now
        H.modify (_ 
          { timer = Just { millisLeft : 25*60000
          , lastTimed : n
          , taskId: id
          , taskTitle: title 
          }})
        pure next

    tickTimer :: DateTime -> Timer -> Dsl e Unit
    tickTimer n t = do
      H.raise $ TimerElapsed t.taskId millisecs
      H.modify (_ { timer = Just updatedTimer })
      where
        updatedTimer = t 
          { millisLeft = max 0 (t.millisLeft - millisElapsed) 
          , lastTimed  = n 
          }
        millisecs :: Milliseconds
        millisecs = diff n t.lastTimed
        millisElapsed = round $ un Milliseconds millisecs
        
