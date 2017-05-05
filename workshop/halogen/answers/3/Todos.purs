module Todos where

import Prelude
import DOM.Event.KeyboardEvent as Key
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Data.Maybe (Maybe(..))

data Query a 
  = UpdateInput String a 
  | NewTodo a

type Todo = 
  { completed :: Boolean
  , title     :: String 
  }

type State = 
  { todos :: Array Todo
  , editingString :: String 
  }

todos :: forall m. H.Component HH.HTML Query Unit Void m
todos =
  H.component
    { initialState: const initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where

  initialState :: State
  initialState = 
    { editingString : ""
    , todos : 
      [ { completed : false, title : "Write Talk" }
      , { completed : true, title : "Propose Talk"}
      ]
    }
  
  renderTodo :: Todo -> H.ComponentHTML Query
  renderTodo t = HH.li_ 
    [ HH.label_ 
      [ HH.input [HP.class_ (H.ClassName "toggle"),HP.type_ HP.InputCheckbox] 
      , HH.text t.title
      ] ]

  render :: State -> H.ComponentHTML Query
  render state = HH.body_ 
    [ HH.section [HP.class_ (H.ClassName "todo")]
      [ HH.input 
        [ HP.class_ (H.ClassName "new-todo")
        , HP.placeholder "What needs to be done?"
        , HP.autofocus true
        , HP.name "newTodo"
        , HP.value state.editingString
        , HE.onValueInput (HE.input UpdateInput)
        , HE.onKeyDown (\ ke -> if (Key.code ke == "Enter") then (Just (H.action NewTodo)) else Nothing)
        ] 
      , HH.ul [HP.class_ (H.ClassName "todo-list")]
        $ map renderTodo state.todos 
        ]]

  eval :: Query ~> H.ComponentDSL State Query Void m
  eval = case _ of
    NewTodo next -> do
      H.modify (\s -> s { editingString = "", todos = [{completed: false, title: s.editingString}] <> s.todos})
      pure next 
    UpdateInput input next -> do
      H.modify (_ {editingString = input })
      pure next

