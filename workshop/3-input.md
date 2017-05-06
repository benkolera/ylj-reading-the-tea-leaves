# 3 - New Todo Input

In this step, we are going to add the text box that allows someone to add a new todo.

We want to add this HTML to our UI:

```html
<section class="todo"> <!-- this part already exists -->
    <input class="new-todo"
           placeholder="What needs to be done?"
           autofocus="true"
           name="newTodo"
           />
```

And we want to wire it up so that when you type in it and press enter, a new todo is 
added to the list.

**_Exercise: 3.elm.1:_** : Add the input into our render function. One thing that we
don't have in Elm/Halogen is the ability to poll the DOM on submit. We want to use the onInput 
event for the text field instead.

Hints :

  - Add the new HTML to our view
  - Add a `editingString : String` to our model to capture the string being typed. 
  - Add a `UpdateInput String` constructor to our Msg datatype.
  - Use the onInput event attribute on the new input field to raise UpdateInput. 
  - Update our model in reaction to the new message.
  - You can use Debug.log to test that things are updating correctly.

**_Exercise: 3.elm.2:_**: Add a new event that creates a new todo onEnter on the input field. The text field should clear back to the placeholder text when this happens. You'll need to generate 
a todoid.

The way to get an onEnter attribute isn't really clear just looking at the precanned things in Elm.
You probably just want to copy this: :)

```elm
import Json.Decode as Json

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
```

**_Exercise: 3.purs.1:_** : Lets do the same thing for Halogen as the input is exactly the same:

Hints: 

  - Add the new HTML to our render function.
  - Add a `editingString :: String` to our model. 
  - Add a `UpdateInput String a` constructor to our Query datatype. You can remove Noop.
  - Use the onValueInput event attribute on the new input field to raise UpdateInput. 
  - Update our model in reaction to the new message in eval.
  - To show that things are updating, you can use Debug.Trace.spy if you wish!

**_Exercise: 3.purs.2:_**: Add a new event that creates a new todo when enter is pressed in the field. You'll want to generate a new TodoId and make sure the input clears / placeholder text
comes back.

Hints: 

- You'll want onKeyPress. Note the type is KeyboardEvent -> Maybe (Query Unit). KeyboardEvent has a code in it that can be accessed using the function `import DOM.Event.KeyboardEvent.code`. But don't be tricked, to match Enter you need to match the string "Enter" and not "13". Sad, stringly typed programming. :(
- Halogen deals with arrays for it's children, so you probably just want to wear appending arrays
rather than using a list and being able to cons (and have to translate to an array every render...).