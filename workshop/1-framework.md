# Step 1 - Framework Basics

This section has an overview of the general shape of MVI and how Elm and Halogen
implement it.

## Model / View / Intent / MVI

Think of MVI as a functional MVC. It feels like an old and unexciting idea at first,
but the progression from the mutable+OO MVC to an immutable+Functional MVI actually
tidies a lot up.

The basic shape of this pattern is as follows:

![model view intent](./images/mvi.png?raw=true)

### View

The critical component of MVI is the view function that takes some kind of state
and translates it to a virtual dom tree. Virtual DOM then takes care of patching 
the actual DOM in the most efficient way possible from the difference between 
our previous VirtualDOM tree and this new one. This would not be possible without
the ability of VirtualDOM to only make patches rather than recreate the DOM every 
time. It's cheap enough for us to generate the VDom true every time, but creating
/changing things in the actual DOM is still slow.

React started this idea of creating pure view functions and having virtual dom
to sort out the DOM mutation. 

Abstracting away the DOM completely means that there is absolutely no way for 
our application code to store state in the DOM anymore, removing that big ugly
global variable from our worries even compared to data-binding style frameworks
like angular and backbone. Better still, there is the promise of abstracting away 
the underlying UI entirely and one day being able to reuse chunks of your UI for
mobile and Web. 

The downside to this abstraction, of course, is that any UI components that aren't built
around your MVI framework are harder to integrate (like a JS based text editor) since 
you have to make sure that they behave in a VirtualDom environment. Most frameworks 
have abstractions to be able to integrate these things: you just need to be careful
at these integration points. See https://github.com/slamdata/purescript-ace-halogen/blob/master/src/Ace/Halogen/Component.purs
for an example in halogen.

### Messages / Actions

The other critical part of MVI is not mutating the component / app state directly but instead
passing actions defined by types that clearly communicate all of the state changes in the system.

Early react didn't quite have this. It encouraged people to minimise the use of mutable state
and instead passing immutable properties and callback functions down, but that callback could
still do anything and wasn't as clear of a communication tool. 

This allows us to completely separate our state changes from the UI and also allows us to 
look at a component's message type and be able to reason about all the things that can go on
in there. Gone are the days from angular where two-way bindings and random watches on the scope
meant that it was sometimes very difficult to track down or reason about the state changes 
going on in an app.

A benefit of this model of only passing around events is that it gels a lot better with 
optimistic UI updates / UIs that can handle being offline for brief periods and catch 
back up afterwards. Having an event rather than a mutating callback means that we can apply
the event to update our UI before we've even sent off the XHR. 

### Update Function (Redux Term: Reducer)

The update function / reducer is simply a function from a Msg/Event/Action and the previous
model state to calculate the next model state.

## Elm 

If you take a look at http://package.elm-lang.org/packages/elm-lang/html/1.1.0/Html-App#program 
you'll see the core of this idea in action:

```elm
program
    :  { init : (model, Cmd msg)
       , update : msg -> model -> (model, Cmd msg)
       , subscriptions : model -> Sub msg
       , view : model -> Html msg 
       }
    -> Program Never 
```

We can see clearly here what we were talking about with MVI:

  - `view` takes a model and returns our virtual dom representation of the UI
  - `update` takes our message and returns the next state (and optionally a side effect (like an XHR))
  - `init` is the initial value for our model and potentially a side effect to kick things off (like an XHR to load all of our data)
  - `subscriptions` are things that we can setup to receive incoming events from the outside world (websockets, time, etc)

The typeparameter `msg` for Cmd, Sub and Html means that our side effecting parts 
(UI events from HTML, Callback returns from Cmds and incoming messages from subscriptions)
all have to agree on the same message type so that we know our update function can handle 
all of the messages. 

If you open up your editor in the elm directory and take a look at Main.elm,
you can see this in action. You also want to run `elm-reactor` in that directory
(in VSCode, just run the `Elm: Reactor - Start` command) so 
you can hit [the test page](http://localhost:8000/test.html)

**_Exercise 1.elm.1_** : Modify the button so that it keeps a count of how many times it
has been clicked and: 
  - If that count is a multiple of 3 and 5, the label should be "FizzBuzz"
  - If it is just a multiple of 3, then the label should be "Fizz"
  - If it is just a multiple of 5, then the label should be "Buzz"
  - Else the label should be the count of clicks.

Note: Modulo is `(%)` in Elm. Change the state from Bool to Int and follow the types. :)

## Halogen

Halogen is a tiny bit more complicated, but is more or less the same shape:

```
type ComponentSpec h s f i o m =
  { initialState :: i -> s
  , render :: s -> h Void (f Unit)
  , eval :: f ~> ComponentDSL s f o m
  , receiver :: i -> Maybe (f Unit)
  }
```  

Here are the explanations of the type parameters:

  - h is the type of value that will be rendered by the component. This is always Html at the moment,
    but is this way so halogen may be able to support react native in the future.
  - s is the component's state type (model from elm).
  - f is the component's query algebra (msg from elm).
  - i is the type for the component's input values (This is like Flags in elm which we ignored above).
  - o is the type for the component's output messages (no elm analogue).
  - m is a monad used for non-component-state effects (AJAX requests, for example). 

The key difference between Elm and Halogen that requires these extra types
is the fact that components can be nested inside of each other in Halogen
whereas a Elm program is a top level thing that cannot be composed with 
another program.

Don't get too caught up on this or the intimidating types. It looks scary but it'll start making more sense
as we play around with it. A visual approximation of a halogen component is like this:

![halogen component](./images/halogen.png?raw=true)

If we are going to be pedantic about terminology, this actually makes halogen 
more like [The Flux Architecture](https://github.com/facebook/flux/tree/master/examples/flux-concepts) 
than [Redux](http://redux.js.org/) since redux is defined by only having a store & reducer in the
app.

### ComponentDSL

The strangest thing about moving from elm to halogen is this weird eval function
compared to the very simple `msg -> model -> (model, Cmd msg)` that we saw in Elm.

ComponentDSL is a sequential/monadic language that your component's eval function can:
  - Get/Update the component state with Halogen.{get,put,modify}
  - Send a query/message to a child component with Halogen.query
  - Raise an output event to the parent component.
  - Perform an effect in the external effect monad, m.

Note, it's perfectly valid to have components that:

  - Don't include effects in their DSL (if you leave this a type param you cannot have effects via parametricity)
  - Don't care about inputs (Input type: `Unit`)
  - Never emit output (Output type: `Void`)

Halogen is a purely functional library, so there is no actual mutation in a component 
like there is in react. This is why we go to the added complexity of having the component dsl.
The component DSL is actually an algebra wrapped up in free so that we can keep our components
as a purely functional declaration of a component whilst still getting the modular state that we 
want from a component.

To fit into the greater halogen algebra, our component query algebra needs to be parameterised 
and take a continuation to the next step of the halogen evaluation. This implementation detail
bleeds into our algebra because halogen actually allows the query algebra to return a value
to the caller once the query has been evaluated. See:

```haskell
data Msg next = Toggle next | GetState (Boolean -> next)

eval :: forall a. Query a -> H.ComponentDSL State Query Void m a
eval = case _ of
    Toggle next -> do
      _ <- H.modify not
      pure next
    IsOn reply -> do
      state <- H.get
      pure (reply state)
```

But there is a concept for a function from `f a -> g a`. It is called a natural transformation
and is written with a funny squiggly arrow:

```haskell
-- This is the same thing
eval :: Query ~> H.ComponentDSL State Query Void m
```

Because of the difference between query algebra constructors that return a value or 
just have an effect on the state, Halogen has different names for these different 
things.

  - `Action`'s are the algebra constructors that return nothing.
  - `Request`'s are the constructors that have a function callback and return something.

There are various combinators that create query algebra values with the right types and
input that work for either case. You'll know when you need them because you'll likely get 
stuck with a kinda of weird value to create for raising a message on a DOM event or querying
a child component.

  - For queries:
    - Halogen.request
    - Halogen.action
  - For DOM events:
    - Halogen.Events.input_ : Raise an action ignoring the DOM Event
    - Halogen.Events.input : Raise an action by first going through a function that examines the DOM Event. 

**_Exercise 1.purs.1_** : Modify the button in Main.purs so that it keeps a count of how many times it
has been clicked (test by running `pulp server` and hitting [the test page](http://localhost:1337/test.html)) and: 
  - If that count is a multiple of 3 and 5, the label should be "FizzBuzz"
  - If it is just a multiple of 3, then the label should be "Fizz"
  - If it is just a multiple of 5, then the label should be "Buzz"
  - Else the label should be the count of clicks.

Hint: This is exactly the same as with Elm. Just be cautioned that Purescript doesn't have syntax for tuples
if you used a pattern match on a (Bool,Bool) in elm! Tuple Boolean Boolean is a tuple without syntax.