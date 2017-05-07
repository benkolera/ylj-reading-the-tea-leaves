# 5 - Timer Static

From this point onwards, I'm going to give a lot less hints as to how to do things
as you have most of what you need to implement things from now.

This step, we will refactor main into a separate component that has two 
children: Todos (the one that we wrote before) & Pomodoro.

We are going to want a state of `Maybe { minutesRemaining :: Int, secondsRemaining :: Int}` that powers this DOM structure:

```html
<section class pomodoro>
    <!-- if there is currently no timer then show this -->
    <section class="timer-selector">
        <div class="timer-selector-msg">
            Please select a task below
        </div>
    </section>
    <!-- if there is a timer then show this -->
    <section class="timer">
        <span class="timer-minutes">25</span>
        <span class="timer-colon">:</span>
        <span class="timer-seconds">00</span>
    </section>
</section>
```

Stub the initial state with a timer with 25 minutes remaining to test it.

## Elm

**_Exercise 5.elm.1:_** 

- Copy Main.elm to Todos.elm.
- Delete program from Todos and put a module on the file.
- Create Pomodoro.elm with a view, update, Model, Msg and initialState
- Change Main.elm to parent the Pomodoro and Todos components.

Hint: Cmd and Sub have map functions, too! 

## Halogen

This is where we see how we make components that mix different child components.
Halogen needs to do some work to have different Slots and Queries underneath 
but still keep everything typesafe.

**_Exercise 5.elm.1:_** 

- Make the Pomodoro.purs component
- Make an App.purs components that includes Pomodoro and Todos.
- Change Main to start App rather than Todos.

Hints:

- We will want a child slot and query type that looks like:

```haskell
import Data.Either.Nested (Either2)
import Data.Functor.Coproduct.Nested (Coproduct2)
import Halogen.Component.ChildPath (cp1, cp2)

-- A child query is the sum of Todos.Query and Pomodoro.Query
type ChildQuery = Coproduct2 Todos.Query Pomodoro.Query
-- And our slot id is either Todos or Pomodoro
-- Because our children are singletons, Unit is fine here.
type ChildSlot  = Either2 Unit Unit
```

- And then we use a different slot function than when we just had one child type:
```haskell
HH.slot' 
  cp2                             -- It's the second slot of our coproduct 
  unit                            -- It's a singleton, so id is just unit
  Pomodoro.pomodoro               -- Our subcomponent
  unit                            -- Input to the component
  (HE.input HandlePomodoroOutput) -- This takes the output events and raises a Query here.
```