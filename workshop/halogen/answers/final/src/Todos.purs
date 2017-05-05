module Todos where

import Prelude
import DOM.Event.KeyboardEvent as Key
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Todo as Todo
import Data.Array ((:))
import Data.Maybe (Maybe(..))
import Data.Monoid (class Monoid)
import Data.Foldable (class Foldable,fold)
import Data.Newtype (unwrap)
import Data.Time.Duration (Milliseconds(..))

data Query a 
  = NewTask a
  | UpdateStr String a
  | AddTime Int Milliseconds a
  | Deactivate Int a
  | HandleTodoMessage Todo.Id Todo.Output a

data Output 
  = TimerStarted Int String

type State = 
  { todos      :: Array Todo.State
  , nextTaskId :: Todo.Id
  , editingStr :: String
  }

newtype TodoSlot = TodoSlot Todo.Id
derive instance eqTodoSlot :: Eq TodoSlot
derive instance ordTodoSlot :: Ord TodoSlot

foo :: forall f a. Foldable f => Monoid a => f a -> a
foo = fold

todos :: forall m. H.Component HH.HTML Query Unit Output m
todos = H.parentComponent 
    { initialState: const initialState 
    , render
    , eval 
    , receiver: const Nothing 
    }
  where
    initialState :: State
    initialState = { editingStr: "", nextTaskId : 3, todos: 
      [ Todo.newTodo 2 "Write talk" false (Milliseconds $ 120.0*60000.0)
      , Todo.newTodo 1 "Propose Talk" true (Milliseconds $ 60.0*60000.0)
      ] }

    render :: State -> H.ParentHTML Query Todo.Query TodoSlot m
    render state = HH.section [HP.class_ (H.ClassName "todo")] 
      [ HH.input 
        [ HP.class_ (H.ClassName "new-todo")
        , HP.placeholder "What needs to be done?"
        , HP.autofocus true
        , HP.value state.editingStr
        , HE.onKeyPress (\e -> if (Key.code e == "Enter") then (Just (NewTask unit)) else Nothing)
        , HE.onValueInput (HE.input UpdateStr)
        ]
      , HH.ul [HP.class_ (H.ClassName "todo-list")] (map renderTodo state.todos)
      ]
    
    renderTodo :: Todo.State -> H.ParentHTML Query Todo.Query TodoSlot m
    renderTodo t =
      HH.slot
        (TodoSlot (unwrap t).id)
        Todo.todo
        t
        (HE.input (HandleTodoMessage (unwrap t).id))

    eval :: Query ~> H.ParentDSL State Query Todo.Query TodoSlot Output m
    eval = case _ of 
      UpdateStr s next -> do
        H.modify (_ { editingStr = s} )
        pure next
      
      AddTime id millis next -> do
        void $ H.query (TodoSlot id) (H.action $ Todo.AddTime millis)
        pure next
      
      Deactivate id next -> do
        void $ H.query (TodoSlot id) (H.action $ Todo.Deactivate)
        pure next
      
      HandleTodoMessage todoId tOutput next -> do
        case tOutput of
          Todo.TimerStarted title ->
            H.raise $ TimerStarted todoId title
        pure next

      NewTask next -> do   
        s <- H.get
        H.modify (_ 
          { todos = (Todo.newTodoDef s.nextTaskId s.editingStr) : s.todos
          , nextTaskId = s.nextTaskId + 1
          , editingStr = ""
          })
        pure next

