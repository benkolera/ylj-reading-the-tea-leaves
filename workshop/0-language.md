
## Step 0 - Language Intro

If you haven't played with Elm or Purescript before, there are a few things that
you should probably know before proceeding. That's what this section is about!
You're probably OK just skimming this section and coming back to it when you need
it. 

Given that we are at Lambda Jam and we have a lot to get done in the workshop,
I've needed to make some assumptions that you have a some experience 
with navigating and writing purely functional code. If at any point get to a 
block of "I know how i'd do this in an imperative language, but I'm stuck here"
please just throw your hand up and we'll work through it.

### Elm

Elm is a ML like language. There are no typeclasses or ad-hoc polymorphism, so 
you'll find all of the functions you can use for a type in the module for that
type. The standard library is quite spartan, so the you may find that you need
to go to an *Extras package (e.g: If there isn't a function in the Maybe module
, you'll probably find what you want in MaybeExtras) to get extra useful functions.

The workshop code has ListExtras and MaybeExtras already around (you need MaybeExtra 
even to get `unwrap :: b -> (a -> b) -> Maybe a -> b`, so feel free to use them
as much as you like.

#### Primitives

  - String : `"foo" : String"`
  - Int : `1 : Int`
  - Number : `1.0 : Number`
  - List : `["foo","bar"] : List String`

(++) will append strings or lists for you. Note the type for List is `List a` and not `[a]`. 

toString (prelude function) will take most things and print it to a string.

You can't mix integers and numbers in arithmetic. round will go from Number -> Int. 
`(%)`  / modulo and `(\\)` / integer division only work on Ints.

#### Functions

Type ascriptions are a single `:` rather than `::` in haskell. Otherwise they are the
same as haskell. There is no pattern matching in the function definition, so you have
to do a case inside the function instead.

```elm
maybe : b -> (a -> b) -> Maybe a -> b
maybe def f m = case m of
  Nothing -> def
  Just a  -> f a
```

#### Data Definitions & Records 

There are no newtypes: just datatype declarations and type aliases. However, Elm
doesn't use the `data` keyword for datatypes. 

```elm
type Maybe a = Nothing | Just a

type alias Option a = Maybe a
```

Elm has the concept of a record, which can either be open or closed. You could
write the types inline on your function types, but it helps to alias them. You 
access fields with `.` and update with a curly brace and pipe syntax. *Please note
that you cannot nest the update syntax!*

```elm
type alias Person = { name: String, age: Int } 
type alias HasName b = { b | name:String }

yellName : HasName b -> HasName b
yellName rec = { rec | name = String.toUpper rec.name }

ben : Person
ben = { name = "Ben Kolera", age = 30 }

yellName ben
-- => { name = "BEN KOLERA", age = 30 }
```

#### Module Imports

Most Elm guides recommend importing modules qualified. With the lack of typeclasses, 
you need to do this otherwise you get too many clashes (e.g. List.map vs Maybe.map vs Cmd.map, etc).

By default, an import is qualified. You need to explicitly put `exposing` to import symbols into 
the namespace.

```
import Html exposing (Html,body)
import Maybe.Extra as MaybeExtra
import State
```

#### Debugging

If you need to debug or stub out a function that you haven't implemented yet, these will help:

  - `Debug.log : String -> a -> a` : Logs to the JS console
  - `Debug.watch : String -> a -> a` : Watches that value in the time travelling debugger.
  - `Debug.crash : String -> a` : Crashes the program with an error (if you haven't written that code and need code to compile)

#### Running

The best way to run elm is via elm-reactor, as per the installation instructions.

That'll have a webserver running that will recompile when you refresh, show compilation
errors, etc. It also has a time travelling debugger in it that you can inspect the 
state of your app and the events flowing through it.

In VsCode, you can run this by running the `Elm: Reactor Start` command (Ctrl-Shift-P).

### Purescript

Purescript is very haskelly but strict, uses very JS like primitives and has row types
for describing effects and fields in a record. 

There is no implicit prelude, so you'll need to import Prelude in every file.

#### Primitives 

  - `"foo" :: String`
  - `5 :: Int`
  - `5.0 :: Number`
  - `[1,2,3] :: Array Int`
  - ` 1 : 2 : 3 : List.Nil :: List Int`

Everything maps to the JS things underneath except lists. Note, arrays are JS 
arrays and have horrible complexity for head / tail operations. Unfortunately,
the halogen HTML functions take arrays instead of lists (probably due to the
nicer syntax) so we have to wear a fair few arrays in our code.

#### Functions

Type ascriptions are `::` and you need an explicit forall on any type params.

You can also pattern match in the function definition like haskell.

```haskell
maybe :: forall a b. b -> (a -> b) -> Maybe a -> b
maybe def _ Nothing = def
maybe _ f (Just a)  = f a
```

#### Data Declarations and Records

Everything is how you would expect it in Haskell.

```haskell
data Maybe a = Nothing | Just a
type Option a = Maybe a
type Option = Maybe    -- Partial application also works
newtype First a = First (Maybe a)
```

Except for deriving typeclass instances instances must have names
and you use the Haskell StandaloneDeriving notation.

```haskell
newtype TodoSlot = TodoSlot Todo.Id
derive instance eqTodoSlot :: Eq TodoSlot
derive instance ordTodoSlot :: Ord TodoSlot
```

Records are the same as elm, but syntactically different:

```haskell
type Person = { name :: String, age:: Int } 
type HasName b = { name :: String | b }

yellName :: forall b. HasName b -> HasName b
yellName rec = rec { name = String.toUpper rec.name }

ben :: Person
ben = { name : "Ben Kolera", age : 30 }

yellName ben
-- => { name = "BEN KOLERA", age = 30 }
```

#### Modules and Imports

Much the same as haskell just without the `qualified` keyword.

```haskell
import Prelude   -- All prelude symbols included unqualified in this file
import Data.Monoid (class Monoid) -- Imports monoid typeclass
import Data.Foldable (class Foldable,fold)
import Data.Array as Arr -- Arr.length will work

foo :: forall f a. Foldable f => Monoid a => f a -> a
foo = fold
```

#### Miscelaneous Difference from Haskell 

The typeclass hierarchy doesn't have a lot of the cruft that the Haskell prelude does.

  - Monoid `(<>)` is used everywhere instead of having `(++)` for lists / arrays.
  - Semigroupoid composition `(<<<)` or `(>>>)` for composing functions instead of `(.)`
  - There aren't any standard functions hardcoded to list/array. Look in foldable instead.
  - No `return`, `(>>)`, etc that are all superceded by Apply/Applicative things. 

#### Debugging

While you need to track effects for real code in purescript, there are a few handy impure functions
if you need to inspect a value.

  - `Debug.trace : String -> (Unit -> a) -> a` : Logs to the JS console with the label and JS console representation.
  - `Debug.traceShow : Show a => a -> (Unit -> b) -> b` : Logs to the console with a label and the string representation from show.
  - `Debug.spy : a -> a` : Console.log that passes the value through.

#### Running

As shown in the setup instructions, running `pulp server` will start webserver that will
compile your code in the background ready for you to refresh the page.

In vscode, you can happily run that inside the terminal window if you go View > Integrated Terminal.
