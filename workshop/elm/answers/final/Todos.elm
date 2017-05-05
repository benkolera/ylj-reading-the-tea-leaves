module Todos exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class,type_,autofocus,value,name,placeholder,classList,checked)
import Html.Keyed as Keyed
import Html.Events exposing (..)
import Json.Decode as Json
import Maybe.Extra as MaybeExtra
import Time exposing (Time,inSeconds)

type Msg 
    = UpdateField String
    | Toggle Int
    | Add
    | TimeTodo Todo
    | DeactivateTodo Int
    | AddTime Int Time

type alias Model = 
    { todos : List Todo
    , editingString : String
    , nextUid : Int
    , activeUid: Maybe Int
    }

type alias Todo = 
    { uid : Int
    , title : String
    , completed : Bool
    , timeSpent: Time
    }

init : Model
init = 
    { nextUid = 3
    , editingString = ""
    , activeUid = Nothing
    , todos = 
        [ { uid = 1 , title = "Write talk", completed = False, timeSpent = 120 * 60000 }
        , { uid = 2 , title = "Propose talk", completed = True, timeSpent = 60 * 60000 }
        ]
    }

newTodo : Int -> String -> Todo
newTodo uid title = { uid = uid, title = title, completed = False, timeSpent = 0 }  

view : Model -> Html Msg
view model = section [class "todo"] 
  [ input
    [ class "new-todo"
    , placeholder "What needs to be done?"
    , autofocus True
    , value model.editingString
    , name "newTodo"
    , onInput UpdateField
    , onEnter Add
    ]
    []
   , Keyed.ul [class "todo-list"] <| List.map (todoKeyedView model.activeUid) model.todos
   ]

todoKeyedView : Maybe Int -> Todo -> (String,Html Msg)
todoKeyedView activeUid t = 
  (toString t.uid 
  , li [classList 
        [("completed",t.completed)
        ,("active",MaybeExtra.unwrap False (\au -> t.uid == au) activeUid)
        ]]
    ([ label []
        [ input 
            [ type_ "checkbox"
            , class "toggle"
            , checked t.completed 
            , onClick (Toggle t.uid)
            ] [] 
        , text t.title 
        ]
    ] ++
    ( if (t.completed) 
        then [] 
        else [button [class "timer-start", onClick (TimeTodo t)] []]
    ) ++
    [span [class "time-spent"] [timeSpentText t.timeSpent]]
    ))

maybe : forall b. b -> (a -> b) -> Maybe a -> b
maybe def _ Nothing = def
maybe _ f (Just a)  = f a

timeSpentText : Time -> Html Msg
timeSpentText time = 
  let seconds = round <| inSeconds time
      s = toDoubleDigits <| seconds % 60
      minutes = seconds // 60
      m = toDoubleDigits <| minutes % 60
      h = toDoubleDigits <| minutes // 60
  in text (h ++ ":" ++ m ++ ":" ++ s)

toDoubleDigits : Int -> String
toDoubleDigits = toString >> String.padLeft 2 '0'

update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateField s ->
        { model | editingString = s }
    Add ->
        if (String.isEmpty model.editingString )
        then model
        else { model 
             | nextUid = model.nextUid + 1
             , editingString = ""
             , todos = (newTodo model.nextUid model.editingString) :: model.todos
             }
    Toggle uid ->
        { model | todos = updateEntry (\t -> {t| completed = not t.completed}) uid model.todos }
    TimeTodo t ->
        { model | activeUid = Just t.uid }
    AddTime uid timeElapsed ->
        { model 
        | todos = 
            updateEntry 
                (\t -> {t| timeSpent = t.timeSpent + timeElapsed }) 
                uid 
                model.todos 
        }
    DeactivateTodo uid ->
        { model 
        | activeUid = Maybe.andThen (\u -> if u == uid then Nothing else Just u) model.activeUid
        }

updateEntry : (Todo -> Todo) -> Int -> List Todo -> List Todo
updateEntry f uid = List.map (\ t -> if (t.uid == uid) then f t else t)

onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        on "keydown" (Json.andThen isEnter keyCode)
