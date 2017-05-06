# Step 0 - Language & VSCode Intro

In this step we are going to poke around through the basics of
Elm and Purescript and the tooling that exists in VSCode for
them.

If you've done some Haskell before, you'll probably be 
able to charge on without this section.

## Elm 

### Functions

We define functions like this:

```elm
-- Add1 is a function that takes an int and returns another int
add1 : Int -> Int
add1 x = x + 1

-- And we apply functions with a space 
add1 10
-- => 11
-- Application is the highest precedence which can tricky to get used to
add1 10 + 1
-- is actually
(add1 10) + 1
-- To get things the other way around:
add1 (10 + 1)

List.map add1 [1,2,3]
-- => [2,3,4]
-- You can make anonymous functions too. This is the same thing:
List.map (\x = x + 1) [1,2,3]
```
### Data Types

```elm
-- We can create algebraic data types where a type can be inhabited by 
-- one of the mentioned constructors.
type Shape = Square Float | Rectangle Float Float | Circle Float

-- Which we can then pattern match to figure out which constructor we have:
area : Shape -> Float 
area shape = case shape of
  Square side            -> side^2
  Rectangle length width -> length * width
  Circle radius          -> pi * radius^2

-- We can also create records
type alias Person = 
  { name : String
  , age  : Int
  }

ben : Person
ben = { name = "Ben Kolera", age = 30 }

yellName : Person -> Person
yellName p = { p | name = String.toUpper p.name }
```

### Lists

Lists are created in a square braced list:

```elm
numbers = [1337,2020]
-- And they can be transformed using the List.map function
-- a and b are type parameters.
-- List.map : (a -> b) -> List a -> List b
-- We append lists with ++
List.map toString (numbers ++ [1,2,3])
-- ["1337","2020","42","1","2","3"]
```

### Imports

```elm
-- We can import elm things qualified
import String as S
S.toUpper "foo"

-- or import the symbols directly
import String (toUpper)
toUpper "foo"
```

#### Debugging

If you need to debug or stub out a function that you haven't implemented yet, these will help:

  - `Debug.log : String -> a -> a` : Logs to the JS console
  - `Debug.watch : String -> a -> a` : Watches that value in the time travelling debugger.
  - `Debug.crash : String -> a` : Crashes the program with an error (if you haven't written that code and need code to compile)

Using these functions is done like:

```elm
foo x = add1 (Debug.log "X" x)
-- This will add1 x AND Console.log( "X: ", x )
```

#### Running

The best way to run elm is via elm-reactor, as per the installation instructions.

That'll have a webserver running that will recompile when you refresh, show compilation
errors, etc. It also has a time travelling debugger in it that you can inspect the 
state of your app and the events flowing through it.

In VsCode, you can run this by running the `Elm: Reactor Start` command (Cmd/Ctrl-Shift-P).

## Purescript 

### Functions

Functions are much the same except that type ascription is done with two colons
and you need to quantifier type params with a forall.

```haskell
-- Add1 is a function that takes an int and returns another int
add1 :: Int -> Int
add1 x = x + 1

doubleArray :: forall a. Array a -> Array a
doubleArray arr = arr ++ arr

-- Anonymous functions can be created in two ways:
map (\ x -> x + 1) [1,2,3]
map (_ + 1) [1,2,3]
```

### Data Types

```haskell
-- Instead of type, we make algebraic data types with the data keyword
data Shape = Square Number | Rectangle Number Number | Circle Number

-- Which we can then pattern match in two ways:
area :: Shape -> Number
area shape = case shape of
  Square side            -> side^2
  Rectangle length width -> length * width
  Circle radius          -> pi * radius^2

-- We can also create records but there is no alias keyword
type Person = 
  { name :: String
  , age  :: Int
  }

-- Creating values with a single colon
ben :: Person
ben = { name : "Ben Kolera", age : 30 }

yellName :: Person -> Person
yellName p = p { name = toUpper p.name }
```

### Imports

If you have a function that isn't imported, you can press Cmd/Ctrl-Shift-P and run 
the command "Purescript - Add Explicit Import". If it can find that function in 
a module that is installed, it will allow you to pick that module to import the symbol from.

Just make sure you have Prelude imported in every file, else you wont even have numbers
or ints in scope.

```haskell
-- Imports all of the prelude functions into this namespace.
import Prelude 
-- Qualified
import Data.String as S
S.toUpper "foo"
import Data.String (toUpper)
toUpper "foo"
```

#### Debugging

While you need to track effects for real code in purescript, there are a few handy impure functions
if you need to inspect a value.

  - `Debug.trace : String -> (Unit -> a) -> a` : Logs to the JS console with the label and JS console representation.
  - `Debug.spy : a -> a` : Console.log that passes the value through.

#### Running

As shown in the setup instructions, running `pulp server` will start webserver that will
compile your code in the background ready for you to refresh the page.

In vscode, you can happily run that inside the terminal window if you go Ctrl-\` or Cmd-\`