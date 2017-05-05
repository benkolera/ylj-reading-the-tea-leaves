import Html exposing (Html,body)
import Platform.Cmd exposing (Cmd)
import Maybe.Extra as MaybeExtra
import State

import Todos 
import Pomodoro

type Msg
  = PomodoroMsg Pomodoro.Msg
  | TodosMsg Todos.Msg

type alias Model = 
  { pomodoro : Pomodoro.Model
  , todos : Todos.Model
  }

init : Model
init = 
  { pomodoro = Pomodoro.init
  , todos = Todos.init
  }

view : Model -> Html Msg
view model = 
  body [] 
     [ Html.map PomodoroMsg <| Pomodoro.view model.pomodoro
     , Html.map TodosMsg <| Todos.view model.todos
     ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    PomodoroMsg m ->
      let (pomodoroModel,stopEvt,cmd) = Pomodoro.update m model.pomodoro
      in case m of 
        Pomodoro.Tick (Pomodoro.TaskTimer uid _) _ timeElapsed ->
          let act msg = State.State (\s -> ((),Todos.update msg s))
              msg1 = Todos.AddTime uid timeElapsed
              msg2May = case stopEvt of 
                Just (Pomodoro.TaskTimer uid _) -> Just <| Todos.DeactivateTodo uid
                _                               -> Nothing
              msgs = msg1 :: (MaybeExtra.toList msg2May)
              todosModel = State.finalState model.todos <| State.traverse act msgs
          in ( {model 
               | pomodoro = pomodoroModel
               , todos = todosModel
               }, Cmd.map PomodoroMsg cmd )
        _ -> ( { model | pomodoro = pomodoroModel }, Cmd.none )

    TodosMsg m ->
      let newTodos = Todos.update m model.todos 
      in case m of
        Todos.TimeTodo t -> 
          let pomodoroMsg = Pomodoro.NewTimer (Pomodoro.TaskTimer t.uid t.title)
              (pomodoroModel,_,cmd) = Pomodoro.update pomodoroMsg model.pomodoro
          in ( {model | pomodoro = pomodoroModel, todos = newTodos }, Cmd.map PomodoroMsg cmd )
        _ -> 
          ( {model | todos = newTodos }, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.map PomodoroMsg <| Pomodoro.subscriptions model.pomodoro

main : Program Never Model Msg
main =
  Html.program
    { init = (init, Cmd.none)
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
