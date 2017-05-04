import Html exposing (Html,body,button,text)
import Html.Events exposing (onClick)
import Platform.Cmd exposing (Cmd)
import Platform.Sub exposing (Sub)

type Msg = Toggle

type alias Model = Int

init : Model
init = 0

divisibleBy : Int -> Int -> Bool
divisibleBy x n = x % n == 0 

view : Model -> Html Msg
view model = 
  let msg = if (divisibleBy model 3 && divisibleBy model 5) then "FizzBuzz" 
            else if (divisibleBy model 3) then "Fizz"
            else if (divisibleBy model 5) then "Buzz"
            else toString model
  in body [] [ button [ onClick Toggle ] [text msg] ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Toggle -> ( model + 1, Cmd.none )

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