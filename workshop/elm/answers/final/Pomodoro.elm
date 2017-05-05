module Pomodoro exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Platform.Cmd exposing (Cmd)
import Maybe.Extra as MaybeExtra
import Task 
import Time exposing (Time,millisecond,inSeconds,inMinutes,minute,second,every)

type Msg 
  = Tick TimerTarget Time Time 
  | NewTimer TimerTarget
  | SetTimer TimerTarget Time

type TimerTarget = TaskTimer Int String | BreakTimer
type alias Timer = 
  { target      : TimerTarget
  , lastTimed   : Time
  , finishesAt  : Time
  , minutesLeft : Int
  , secondsLeft : Int 
  }

type alias Model = 
  { timer : Maybe Timer
  }

init : Model
init = 
  { timer = Nothing
  }

view : Model -> Html Msg
view model = 
  section [class "pomodoro"] 
    ( MaybeExtra.unwrap timerSelectorView timerView model.timer ) 

update : Msg -> Model -> (Model, Maybe TimerTarget, Cmd Msg)
update msg model = 
  case msg of
    NewTimer target ->
      ( { model | timer = Nothing } , Nothing, setTimerCmd target )
    SetTimer target currentTime ->
      ( { model 
        | timer = Just (timerForTarget target currentTime)
        } , Nothing, Cmd.none )
    Tick target currentTime elapsed -> 
      let resultMay = Maybe.map (calculateTimeRemaining currentTime) model.timer 
          newTimer  = Maybe.andThen Tuple.second resultMay
          stopEvent = Maybe.andThen Tuple.first resultMay
      in ( { model | timer = newTimer} , stopEvent, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model = 
    MaybeExtra.unwrap 
        Sub.none
        (\t -> every (300 * millisecond) (tickEvent t))
        model.timer

setTimerCmd : TimerTarget -> Cmd Msg
setTimerCmd target = Task.perform (SetTimer target) Time.now 

timerSelectorView : List (Html Msg)
timerSelectorView = 
  [ section [class "timer-selector"] 
    [ text "Select a task from below to start a timer..." 
    ]
  ]

timerView : Timer -> List (Html Msg)
timerView timer =
    [ section [class "timer"] [
      span [class "timer-minutes"] [text (String.padLeft 2 '0' <| toString timer.minutesLeft)] 
    , span [class "timer-colon"] [text ":"]
    , span [class "timer-seconds"] [text (String.padLeft 2 '0' <| toString timer.secondsLeft)] 
    ]]

calculateTimeRemaining : Time -> Timer -> (Maybe TimerTarget, Maybe Timer)
calculateTimeRemaining currentTime timer = 
  let (minutesLeft,secondsLeft) = calculateMinsSecs currentTime timer.finishesAt
  in Debug.log "result" <|
    if (minutesLeft == 0 && secondsLeft == 0)
    then 
        case timer.target of
          TaskTimer _ _ -> (Just timer.target, Just <| timerForTarget BreakTimer currentTime) 
          _             -> (Just timer.target, Nothing)
    else 
      (Nothing, Just { timer 
      | lastTimed = currentTime
      , minutesLeft = minutesLeft
      , secondsLeft = secondsLeft
      })

calculateMinsSecs : Time -> Time -> (Int,Int)
calculateMinsSecs currentTime finishesAt = 
  let diff = finishesAt - currentTime
      minutesLeft = max 0 <| floor <| inMinutes diff
      secondsLeft = (max 0 <| floor <| inSeconds diff) % 60
  in (minutesLeft,secondsLeft)


timerForTarget : TimerTarget -> Time -> Timer
timerForTarget target currentTime =
    let time = 
            case target of
                TaskTimer _ _ -> 6 * second 
                BreakTimer    -> 3 * second
        finishesAt = currentTime + time
        (minutes,seconds) = calculateMinsSecs currentTime finishesAt
    in { target      = target
       , finishesAt  = finishesAt
       , lastTimed   = currentTime
       , minutesLeft = minutes
       , secondsLeft = seconds
       }

tickEvent : Timer -> Time -> Msg
tickEvent timer currentTime = 
    Tick timer.target currentTime (currentTime - timer.lastTimed)