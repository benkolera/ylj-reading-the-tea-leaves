module Todos where

import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Data.Maybe (Maybe(..))

data Query a = Noop a

type Todo = 
  { completed :: Boolean
  , title     :: String 
  }

type State = 
  { todos :: Array Todo }

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
  initialState = { todos : 
    [ { completed : false, title : "Write Talk" }
    , { completed : true, title : "Propose Talk"}
    ]}
  
  renderTodo :: Todo -> H.ComponentHTML Query
  renderTodo t = HH.li_ 
    [ HH.label_ 
      [ HH.input [HP.class_ (H.ClassName "toggle"),HP.type_ HP.InputCheckbox] 
      , HH.text t.title
      ] ]

  render :: State -> H.ComponentHTML Query
  render state = HH.body_ 
    [ HH.section [HP.class_ (H.ClassName "todo")]
      [HH.ul [HP.class_ (H.ClassName "todo-list")]
        $ map renderTodo state.todos 
        ]]

  eval :: Query ~> H.ComponentDSL State Query Void m
  eval = case _ of
    Noop next -> do
      pure next

