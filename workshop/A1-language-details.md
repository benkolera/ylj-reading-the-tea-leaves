
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
  - Float : `1.0 : Float`
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


### Purescript

#### Miscelaneous Difference from Haskell 

The typeclass hierarchy doesn't have a lot of the cruft that the Haskell prelude does.

  - Monoid `(<>)` is used everywhere instead of having `(++)` for lists / arrays.
  - Semigroupoid composition `(<<<)` or `(>>>)` for composing functions instead of `(.)`
  - There aren't any standard functions hardcoded to list/array. Look in foldable instead.
  - No `return`, `(>>)`, etc that are all superceded by Apply/Applicative things. 
