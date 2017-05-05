# 2 - Static Todo List

In this part we're going to make the todo list view code. No actions or todo creation right now.
This will give you a good feel for generating HTML in the view.

There is already CSS included in the example, so we need to make some HTML from our view that looks like:

```html
<section class="todo">
    <ul class="todo-list">
        <li>
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

**_Exercise 2.elm.2_** : Change our view function to generate the above structured HTML. You can find
all of the HTML elements under the H namespace (e.g H.section) and the attributes under HA (e.g. HA.class).
Note that the elements take two list of things: the first list are the attributes and the second list are
the children. Also note that it is `HA.type_` because type is a reserved word in Elm.

It will be very handy to write a function `todoView : Todo -> H.Html Msg` before doing the full view. 
Haskell people may be looking for `($)` at this point. It is `(<|)` in Elm. Remember that without typeclasses
you need to go List.map to map over a list.

**_Exercise 2.purs.1_** : Lets add a Todos.elm to have the following skeleton:

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

**_Exercise 2.elm.2_** : Change our render function to generate the above structured HTML. You can find
all of the HTML elements under the HH namespace (e.g HH.section) and the attributes under HP (e.g. HP.class).
Note that the elements take two list of things: the first list are the attributes and the second list are
the children. If you have no attributes, there is usually a `HH.section_ [children]`.

The two new things that you'll need to find are `H.ClassName` and `HP.InputCheckbox`. :)