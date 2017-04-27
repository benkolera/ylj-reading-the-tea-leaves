# Reading the TEA Leaves - Talk & Workshop

This repository contains code and slides for a talk & workshop 
investigating The Elm Architecture (TEA) and exploring it in
Elm and Halogen (a purescript library).

This workshop was created by [Ben Kolera](https://twitter.com/benkolera/) for
[YOW Lambda Jam 2017](http://lambdajam.yowconference.com.au/program/).

## Summary

The redux architecture seems to have really won over the React community, which
is awesome to see because it was inspired by a purely functional, typesafe
language called Elm.

This talk will quickly look at ‘The Elm Architecture’ (TEA) and explain why the
shape of the architecture works so well to create purely functional HTML UIs.
This language / architecture has been very popular with JS devs and is
worthwhile taking a peek at this typesafe thing that is capturing the attention
of mainstream developers. 

Elm/TEA makes a very deliberate design choice to avoid thinking of building UIs
in terms of components. It places the focus on building separate, reusable
functions/types for each of the model, view and update (event processing) parts
rather than thinking in the traditional OO component style. Functional is a good
thing and the simplicity makes TEA incredibly easy to get started with. However,
the design doesn't really bake in an idea of separating the public and private
events/state of a UI element and it can get a little messy.

Halogen, on the other hand is a similar Model-View-Intent framework
but works in terms of composable components each with their own internal state
and clearly defined input and output events. This is more complicated at first,
but allows composition of UI elements in a much more modular way since the 
lines between internal state/actions and public API are not as blurred. Even better,
it makes the state/events/any effects obvious in the component type, so you can
reason about the component based on type.

This workshop will explore the two approaches and take them to the point where
we have a lot of crosstalk between two separate UI elements. This is normally
the point where the modularity (or lack thereof) start becoming really
important. We'll need to go a bit past TodoMVC to get this to be obvious.

This intention of this talk is not to posture one as better than the other, but
to talk about the shapes of each and why one or both may be worth your interest.
Even if neither quite work for your use cases, it is still very useful to
understand where some people are pushing the bounds of typesafe JS UIs.

## Slides

TBC - I will post these here after the talk.

## Workshop 

_*Before coming to the workshop*_, please try to set up your environment while 
you are home in the land of reasonably good Internet access. There is no guarantee
that we'll have good Internet access at the actual workshop so it'll be good to
get all the heavy installation steps done prior. If you forgot to do this don't 
fret! Ben will have his 4G Hotspot around, but it can only do 10 connections at 
once and is his own personal data quota: so be nice! :)

See [Installation Prereqs](./workshop/installation.md) for details.

See [Workshop](./workshop/README.md) for the actual workshop details.

# Acknowledgements & License

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />
The slides and workshop material are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License. 
</a>

Big thanks to the following people whose work made this talk/workshop easier:
  - [Evan's Elm TodoMVC implementation](https://github.com/evancz/elm-todomvc)
  - [Slam Data's Halogen TodoMVC implementation](https://github.com/slamdata/purescript-halogen/tree/master/examples/todo)
  - [Stopwatch Icon by MadeByOliver](http://www.flaticon.com/free-icon/stopwatch_149318#term=timer&page=1&position=6)
  - [Evan Czaplicki for writing Elm](https://github.com/elm-lang)
  - [Phil Freeman for Purescript](https://github.com/purescript/purescript)
  - [Slamdata for Halogen](https://github.com/slamdata/purescript-halogen/)
  - [Bodil Stokke (who is here at YLJ, so give her a high-five!) for writing Pulp](https://github.com/bodil/pulp)