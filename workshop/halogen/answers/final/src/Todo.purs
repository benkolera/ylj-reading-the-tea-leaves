module Todo where

import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Util as Util
import Data.Array (filter)
import Data.Foldable (fold, intercalate)
import Data.Int (round)
import Data.Newtype (class Newtype, over, un, unwrap)
import Data.Time.Duration (Milliseconds(..))

data Query a 
  = HandleInput State a
  | StartTimer a
  | AddTime Milliseconds a
  | Deactivate a
  | Toggle a

data Output 
  = TimerStarted String

type Id = Int

newtype State = State
  { id        :: Id
  , title     :: String 
  , completed :: Boolean 
  , active    :: Boolean
  , timeSpent :: Milliseconds
  }
derive instance eqTodo :: Eq State
derive instance newTypeTodo :: Newtype State _

newTodoDef :: Id -> String -> State
newTodoDef i t = newTodo i t false (Milliseconds 0.0)

newTodo :: Id -> String -> Boolean -> Milliseconds -> State
newTodo i t c m = State 
  { id : i
  , title : t
  , completed : c
  , active: false 
  , timeSpent: m
  } 

todo :: forall m. H.Component HH.HTML Query State Output m
todo = H.component 
    { initialState: id
    , render
    , eval 
    , receiver: HE.input HandleInput
    }
  where
    render :: State -> H.ComponentHTML Query
    render state = HH.li [HP.classes (classArray state)] $
      fold 
        [ [HH.label_
            [HH.input 
              [ HP.type_ HP.InputCheckbox
              , HP.class_ (H.ClassName "toggle")
              , HP.checked (unwrap state).completed
              , HE.onClick (HE.input_ Toggle)
              ]
            , HH.text (unwrap state).title
          ]]
        , filter 
          (const (not (unwrap state).completed)) 
          [HH.button 
            [ HP.class_ (H.ClassName "timer-start")
            , HE.onClick (HE.input_ StartTimer)
            ] []]
        , [HH.span 
          [HP.class_ (H.ClassName "time-spent")] 
          [HH.text $ timeSpentText (unwrap state).timeSpent]
          ]
        ]

    classArray :: State -> Array H.ClassName
    classArray t = fold 
      [ if (unwrap t).completed then [H.ClassName "completed"] else []
      , if (unwrap t).active then [H.ClassName "active"] else []
      ]
    
    timeSpentText :: Milliseconds -> String
    timeSpentText millis = intercalate ":" <<< map Util.padDigits $ [h,m,s] 
      where
        secondsLeft = (round $ un Milliseconds millis) `div` 1000
        s           = max 0 $ secondsLeft `mod` 60
        minutesLeft = max 0 $ secondsLeft `div` 60
        m           = max 0 $ minutesLeft `mod` 60
        h           = minutesLeft `div` 60

    eval :: Query ~> H.ComponentDSL State Query Output m
    eval = case _ of 
      Toggle next -> do
        H.modify (over State (\s -> s { completed = not s.completed }))
        pure next
      StartTimer next -> do
        H.modify (over State (_ { active = true }))
        s <- H.gets unwrap
        H.raise (TimerStarted s.title)
        pure next
      Deactivate next -> do
        H.modify (over State (_ { active = false }))
        pure next
      AddTime millis next -> do
        H.modify (over State (\s -> s { timeSpent = s.timeSpent + millis }))
        pure next
      HandleInput t next -> do   
        oldT <- H.get
        when (oldT /= t) $ H.put t 
        pure next

