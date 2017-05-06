module Button where

import Prelude
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type State = { on :: Boolean }

data Query a
  = Toggle a

button :: forall m. H.Component HH.HTML Query Unit Void m
button =
  H.component
    { initialState: const initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where

  initialState :: State
  initialState = { on : false }

  render :: State -> H.ComponentHTML Query
  render state =
    let
      label = if state.on then "World" else "Hello"
    in
      HH.button
        [ HP.title label
        , HP.class_ (H.ClassName "big-button")
        , HE.onClick (HE.input_ Toggle)
        ]
        [ HH.text label ]

  eval :: Query ~> H.ComponentDSL State Query Void m
  eval = case _ of
    Toggle next -> do
      H.modify (\ s -> s { on = not s.on } )
      pure next