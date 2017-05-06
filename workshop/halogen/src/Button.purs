module Button where

import Prelude
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

-- State is our model for the UI
type State = { on :: Boolean }

-- Query reprents the actions that can happen in this component.
-- The a is there so we can make queries that return values to 
-- the parent component.
data Query a
  = Toggle a
  | Reset a

-- Our component, with 
--   - Outputs HTML
--   - Has a query algebra of the Query type
--   - Has no meaningful input (Unit)
--   - Outputs no events (Void)
--   - no side effects (m is a parameter)
button :: forall m. H.Component HH.HTML Query Unit Void m
button =
  H.component
    -- Initial state and receiver take our input. Given that 
    -- is Unit, we don't care about the input.
    { initialState: const initialState
    , receiver: const Nothing
    , render
    , eval
    }
  where

  initialState :: State
  initialState = { on : false }

  -- We render our HTML view from our State type
  render :: State -> H.ComponentHTML Query
  render state =
    let
      label = if state.on then "World" else "Hello"
    in
      HH.button
        [ HP.title label
        , HP.class_ (H.ClassName "big-button")
        -- This button raises the Toggle Query on click
        , HE.onClick (HE.input_ Toggle)
        ]
        [ HH.text label ]

  -- This is exactly the same as:
  -- eval :: forall a. Query a -> H.ComponentDSL State Query Void m a
  eval :: Query ~> H.ComponentDSL State Query Void m
  eval = case _ of
    -- Do notation just allows us to sequence commands of ComponentDSL
    Toggle next -> do
      -- H.modify takes a function from State -> State and updates our 
      -- component state with the new value
      H.modify (\ s -> s { on = not s.on } )
      -- We have to return the continuation
      pure next
    Reset next -> do
      H.put initialState
      pure next