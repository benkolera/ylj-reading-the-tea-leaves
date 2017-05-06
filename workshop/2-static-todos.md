# 2 - Static Todo List

In this part we're going to make the todo list view code. No actions or todo creation right now.
This will give you a good feel for generating HTML in the view.

There is already CSS included in the example, so we need to make some HTML from our view that looks like:

```html
<section class="todo">
    <ul class="todo-list">
        <li> <!-- add the completed class if the todo is completed -->
            <label>
                <input type="checkbox" class="toggle" />
                Todo this task!
            </label>
        </li>
    </ul>
</section>
```

**_Exercise 2.elm.1_** : Lets change our Main.elm to have the following skeleton:

```elm
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Platform.Cmd exposing (Cmd)
import Platform.Sub exposing (Sub)

type Msg = Noop

type alias Todo = 
  { completed : Bool
  , title     : String 
  }

type alias Model = 
  { todos : List Todo }

init : Model
init = { todos = 
  [ { completed = False , title = "Write Talk" }
  , { completed = True  , title = "Propose Talk" }
  ]}

view : Model -> H.Html Msg
view model = H.body [] []

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Noop -> ( model, Cmd.none )

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
```

**_Exercise 2.elm.2_** : Change our view function to generate the above structured HTML and
put the "completed" class on any completed todo.

Hints: 
  - You can find all of the HTML elements under the H namespace (e.g H.section), the attributes under HA (e.g. HA.class) and the events under HE (e.g HE.onClick)
  - Note that the elements take two list of things: the first list are the attributes and the second list are the children. 
  - Also note that it is `HA.type_` because type is a reserved word in Elm.
  - It will be very handy to write a function `todoView : Todo -> H.Html Msg` before doing the full view. 
  - Haskell people may be looking for `($)` at this point. It is `(<|)` in Elm.
  - Use HA.classList to give a list of (String,Boolean) to optionally add classes 
    to an element.

**_Exercise 2.elm.3:_** Lets make the checkbox toggle the completed state of the todo.

Hints:

  - HE.onClick will do the job if you make an appropriate message. But what is that?
  - We'll need to add a `id : Int` to the todo and pass that into the action.
  - We'll need to implement handling this message in update. It's a O(n) operation,
    but it's fine just to update the list of todos with a :
    `List.map (\ t -> if t.id == toUpdateId then ... else t ) model.todos` 

**_Exercise 2.purs.1_** : Lets add a Todos.purs to have the following skeleton:

```haskell
module Todos where

import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Data.Maybe (Maybe(..))

data Query a = Noop a

type Todo = 
  { completed :: Boolean
  , title     :: String 
  }

type State = 
  { todos :: Array Todo }

todos :: forall m. H.Component HH.HTML Query Unit Void m
todos =
  H.component
    { initialState: const initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where

  initialState :: State
  initialState = { todos : 
    [ { completed : false, title : "Write Talk" }
    , { completed : true, title : "Propose Talk"}
    ]}

  render :: State -> H.ComponentHTML Query
  render state = HH.body_ []

  eval :: Query ~> H.ComponentDSL State Query Void m
  eval = case _ of
    Noop next -> do
      pure next
```

And then change Main.purs to import and use our todos component instead.

**_Exercise 2.purs.2_** : Change our render function to generate the above structured HTML, 
making sure to put the "completed" class on the li if the todo is completed.

Hints:
  - You probably also want a `renderTodo : Todo -> H.ComponentHTML Query` function.
  - You can find all of the HTML elements under the HH namespace (e.g HH.section), the attributes under HP (e.g. HP.class) and the events under HE (e.g HE.onClick)
  - Note that the elements take two list of things: the first list are the attributes and the second list are the children. If you have no attributes, there is usually a `HH.section_ [children]` variant of the element. Note that some elements have no children (like input).
  - Classnames are not just strings `(H.ClassName "todo-list")` will get you a classname.
  - The type for checkbox is `HP.InputCheckbox`
  - There is no classNames function like with Elm, sadly. Just use HP.classes and an if/then/else.

**_Exercise 2.purs.3:_** Follow the same process as with elm and make the checkbox toggle the 
todo completed state.

Hints:

- Our Toggle event will need to take two parameters now `Toggle Int a` because we still need
  the continuation.
- HE.input_ will turn (a -> Query) into the thing that HE.onClick needs by ignoring the click event and filling a with Unit.