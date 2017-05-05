module App where

import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Pomodoro as Pomodoro
import Todos as Todos
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Now (NOW)
import Data.DateTime (DateTime)
import Data.Either.Nested (Either2)
import Data.Functor.Coproduct.Nested (Coproduct2)
import Data.Maybe (Maybe(..))
import Halogen.Component.ChildPath (cp1, cp2)

data Query a 
  = Tick DateTime a
  | HandleTodosOutput Todos.Output a
  | HandlePomodoroOutput Pomodoro.Output a

type State = Unit

type ChildQuery = Coproduct2 Todos.Query Pomodoro.Query
type ChildSlot  = Either2 Unit Unit

type DslEff e  = Eff (now :: NOW | e) 
type Dsl e = H.ParentDSL State Query ChildQuery ChildSlot Void (DslEff e)

app :: forall e. H.Component HH.HTML Query State Void (DslEff e)
app = H.parentComponent 
    { initialState: const initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where
    initialState :: State
    initialState = unit

    todosPath = cp1
    pomodoroPath = cp2

    render :: State -> H.ParentHTML Query ChildQuery ChildSlot (DslEff e)
    render state = HH.body_ 
      [ HH.slot' pomodoroPath unit Pomodoro.pomodoro unit (HE.input HandlePomodoroOutput)
      , HH.slot' todosPath unit Todos.todos unit (HE.input HandleTodosOutput)
      ]

    eval :: Query ~> Dsl e
    eval = case _ of
      HandleTodosOutput output next -> do
        case output of
          Todos.TimerStarted id title ->
            void $ H.query' pomodoroPath unit (H.action $ Pomodoro.StartTimer id title)
        pure next

      HandlePomodoroOutput output next -> do
        case output of
          Pomodoro.TimerElapsed id millis ->
            void $ H.query' todosPath unit (H.action $ Todos.AddTime id millis)
          Pomodoro.TimerDone id ->
            void $ H.query' todosPath unit (H.action $ Todos.Deactivate id)
        pure next
      
      Tick n next -> do
        _ <- H.query' pomodoroPath unit (H.action (Pomodoro.PomodoroTick n))
        pure next

