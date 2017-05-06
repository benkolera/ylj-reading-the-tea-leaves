import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Platform.Cmd exposing (Cmd)
import Platform.Sub exposing (Sub)

type Msg = Toggle

type alias Model = { on : Bool }

init : Model
init = { on = True }

view : Model -> H.Html Msg
view model = 
  let msg = if model.on then "Hello" else "World"
  in H.body []
    [ H.button [ HA.class "big-button", HE.onClick Toggle ] 
      [H.text msg] ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Toggle -> ( { model | on = not model.on }, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main =
  H.program
    { init = (init, Cmd.none)
    , view = view
    , update = update
    , subscriptions = subscriptions
    }