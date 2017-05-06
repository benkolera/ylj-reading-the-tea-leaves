# 4 - Refactor Todos

In this step, we are going to refactor out the todo list and the individual todos. In this 
case it's a bit unnecessary but it'll get us used to how sub-components work in Elm and 
Halogen. 

## Elm

Elm doesn't have components, as such, but what we want is to at least separate the 
messages, state, view and update into two separate modules. That way we can reason about the stuff happening to individual todos without muddling it with the greater list functionality. It could 
also mean that we'd be able to reuse Todos separate from the list elsewhere, if that
ever made sense. The usual reasons for breaking your code up into modular chunks. :)

**_Exercise 4.elm.1:_** Copy Main.elm to Todo.elm and do the following things:

- Add a `module Todo exposing (..)` to the top of the file.
- Reduce Msg just down to the Toggle event
- Delete Model and rename Todo to Model
- Delete initialState
- Remove view and rename todoView to view
- Cut down the update function. Remove the Cmd component and just make it `Msg -> Model -> Model`.
- Remove everything else (subscriptions, program, onEnter, unused imports)

**_Exercise 4.elm.2:_** Integrate Todo.elm with Main.elm.

- `import Todo`
- Delete the Toggle Msg
- Replace Todo with Todo.Model
- Replace todoView with Todo.view

Take a look at the type error that is happening in the view right now. It says something about having `Html Todo.Msg` instead of `Html Msg`. What do you think we need to do here? Have a think about it before reading on.

The answer is *not* to share the same message type between all of the modules. That makes them
impossible to compose and reuse. 

Look at the type of `Html.map : (a -> b) -> Html a -> Html b`. If we have a function 
`liftTodoMsg : Todo.Msg -> Msg` then we can use map to lift the child view into this 
level.

We can make such a function just by adding another Msg constructor:

`type Msg = TodoMsg Int Todo.Msg | UpdateInput String | NewTodo`

then all we need is `(\todo -> H.map (TodoMsg todo.todoId) <| Todo.view todo)`

Finish off the last bit to make everything work. How do you feel about being able to accidentally
forget that last bit and break the behaviour of the Todo?

**_Exercise 4.elm.3:_** It's time to introduce you to `Html.Keyed` which allows the virtual
dom to better manage list things where things will get added and deleted. It gives each row
an ID so that things don't require rebuilding the whole list every time.

Add `import Html.Keyed as HK` to the top of the file, replace H.ul for HK.ul and write a 
`todoKeyedView : Todo.Model -> (String, H.Html Msg)` that uses the toString of the id as 
the key. 

## Halogen

This is the point where Elm and Halogen start looking very different! Where Elm composes the
Msgs and the Models up into bigger and bigger types as we go upwards, the state of a Halogen
component is completely hidden to everyone except the component itself. The only way to interact
with a component is via the query algebra and the input and output events. It is at this point
where it starts looking much more FRP looking than what we are used to in Elm and Redux.

Embedding child components works a lot like the keyed view in Elm. You give each child a slot
address which is both used by virtual DOM and is used for sending queries to children.

**_Exercise 4.purs.1:_** Lets pull all of the Todo related stuff into a separate Todo module
like we did for elm.

- Copy the Todos.purs to Todo.purs and make the following edits to Todo.purs
- Change the Module from Todos to Todo
- Delete the UpdateInput and NewTodo constructors from Query
- Rename Todo to State
- Rename todos to todo
- change `initialState: const initialState` to `initialState: ?initialState`
- Delete the initialState function
- Rename renderTodo to render
- Delete the unneeded pattern matches from eval and change Togglo to work with just our Todo.

At this point your remaining type error should be that we don't have a value for initialState
yet.

Change the type signature of our component from `H.Component HH.HTML Query Unit Void m` to
`H.Component HH.HTML Query State Void m`. Look at your compiler error again and find a good
function for initialState.

**_Exercise 4.purs.2_**: Integrate this with Todos.purs.

- Import Todo as Todo
- Then we need to create a type that signifies the Id of a Todo for Halogen.

```haskell
newtype TodoSlot = TodoSlot Todo.Id
derive instance eqTodoSlot :: Eq TodoSlot
derive instance ordTodoSlot :: Ord TodoSlot
```

We then need to make the following mechanical changes:

- Cull Query to just UpdateInput and NewTodo
- Change `H.component` to `H.parentComponent`
- Delete the Todo type and change any refernce to it to `Todo.State`
- Change from `H.ComponentHTML Query` to `H.ParentHTML Query Todo.Query TodoSlot m`
- Change -  `H.ComponentDSL State Query Void m` to `H.ParentDSL State Query Todo.Query TodoSlot Void m`
- renderTodo now becomes:
```haskell
renderTodo t = HH.slot
  (TodoSlot t.todoId) -- The Slot ID
  Todo.todo           -- The subcomponent 
  t                   -- Subcomponent input
 (const Nothing)     -- Output receiver
```

## Reflection

- Which do you prefer? 
  - The simplicity of Elm but not having any modularity between
    components (e.g. Any parent could just reach into the global state and ruin the invarants
    that the Children needed of the data. You could also forget to wire in a child update
    and actually have a component not work properly)?
  - The modularity of Halogen, but then having duplicated data between parent and child (e.g. 
    the Todo data sits in Todos and Todo with our current implementation) which could get out
    of sync if we aren't careful.

To me, it seems like there are problems with both.

- Elm:

  - Pros:
    - Very simple and easy to grok
  - Cons: 
    - Easy for parents to break modularity and break invariants of the State. 
    - It's very difficult to separate the Internal and External API of a component.
    - Very little ceremony to enforce a shape of the program. Needs discipline.

- Halogen:

  - Pros: 
    - Enforces modularity of state
    - Clearly defines the public api of a component with Input/Output/Query.
    - Allows parents to keep in sync with children either by Events (Output) or Synchronously 
      querying. This is really important as it is not always performant to get updated with 
      events for everything (e.g: If writing a text editor, you don't want to fire an event every
      time the content changes. You instead just want the parent to be able to query the content
      when ready for it)
  - Cons:
    - Duplication of state data between components that needs to be kept in sync.
    - A lot more complicated.
