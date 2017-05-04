import Html exposing (Html,body,button,text)
import Html.Events exposing (onClick)
import Platform.Cmd exposing (Cmd)
import Platform.Sub exposing (Sub)

type Msg = Toggle

type alias Model = Bool

init : Model
init = True

view : Model -> Html Msg
view model = 
  let msg = if model then "Hello" else "World"
  in body [] [ button [ onClick Toggle ] [text msg] ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Toggle -> ( not model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main =
  Html.program
    { init = (init, Cmd.none)
    , view = view
    , update = update
    , subscriptions = subscriptions
    }