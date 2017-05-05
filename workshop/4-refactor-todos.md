# 4 - Refactor Todos

In this step, we are going to refactor out the todo list and the individual todos. In this 
case it's a bit unnecessary but it'll get us used to how sub-components work in Elm and 
Halogen. 

Elm doesn't have components, as such, but what we want is to at least separate the 
messages, state, view and update. That way we can reason about the stuff happening to 
individual todos without muddling it with the greater list functionality. It could 
also mean that we'd be able to reuse Todos separate from the list elsewhere, if that
ever made sense. The usual reasons for breaking your code up into modular chunks. :)



