import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Platform.Cmd exposing (Cmd)
import Platform.Sub exposing (Sub)
import Json.Decode as Json

type Msg 
  = UpdateInput String
  | NewTodo

type alias Todo = 
  { completed : Bool
  , title     : String 
  }

type alias Model = 
  { editingString : String 
  , todos : List Todo 
  }

init : Model
init =  
  { editingString = ""
  , todos = 
  [ { completed = False , title = "Write Talk" }
  , { completed = True  , title = "Propose Talk" }
  ]}

todoView : Todo -> H.Html Msg
todoView t = H.li [] 
  [ H.label []
    [ H.input [HA.type_ "checkbox", HA.class "toggle"] []
    , H.text t.title 
    ]]

view : Model -> H.Html Msg
view model = H.body []
  [ H.section [HA.class "todo"]
    [ H.input 
      [ HA.class "new-todo"
      , HA.placeholder "What needs to be done?"
      , HA.autofocus True
      , HA.name "newTodo"
      , HA.value model.editingString
      , HE.onInput UpdateInput
      , onEnter NewTodo
      ] []
    , H.ul [HA.class "todo-list"] <| List.map todoView model.todos 
    ]
  ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateInput input -> 
      ( { model | editingString = input }, Cmd.none )
    NewTodo           -> 
      ( { model 
        | editingString = ""
        , todos = { completed = False, title = model.editingString } :: model.todos 
      } , Cmd.none )

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

onEnter : Msg -> H.Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        HE.on "keydown" (Json.andThen isEnter HE.keyCode)