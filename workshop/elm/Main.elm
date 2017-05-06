import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Platform.Cmd exposing (Cmd)
import Platform.Sub exposing (Sub)

-- This datatype describes the events that can happen in our UI.
type Msg = Toggle | Reset

-- This is the model that drives the UI
type alias Model = { on : Bool }

-- We initialise the model to our starting value
init : Model
init = { on = True }

-- A function from model -> Html 
view : Model -> H.Html Msg
view model = 
  let msg = if model.on then "Hello" else "World"
  in H.body []
    -- This button raises a toggle event that triggers an update
    [ H.button [ HA.class "big-button", HE.onClick Toggle ] 
      [H.text msg] ]

-- Our update takes in our Msg and returns a new model (and optional side effect)
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    -- We pattern match our two cases for Msg and act accordingly
    Toggle -> ( 
      { model 
      | on = not model.on
      }, Cmd.none ) -- Cmd.none just means no side effect.
    Reset -> ( init, Cmd.none )

-- Subscriptions are messages that are pushed in from the outside world.
-- Things like incoming websocket traffic, the current time, etc.
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

-- Wire everything together into our program.
main : Program Never Model Msg
main =
  H.program
    { init = (init, Cmd.none)
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
