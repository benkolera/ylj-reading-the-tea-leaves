import Html exposing (Html,body,button,text)
import Html.Events exposing (onClick)
import Platform.Cmd exposing (Cmd)
import Platform.Sub exposing (Sub)

type Msg = Toggle

type State = On | Off

type alias Model = { state : State }

init : Model
init = { state = On }

view : Model -> Html Msg
view model = 
  let msg = 
        case model.state of
            On -> "Hello"
            Off -> "World"
  in body [] [ button [ onClick Toggle ] [text msg] ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Toggle -> 
        let newState = 
                case model.state of
                    On  -> Off 
                    Off -> On
        in ( { model | state = newState }, Cmd.none )

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