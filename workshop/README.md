# Model View Intent - Workshop

Welcome to the Elm and Halogen workshop for lambda jam 2017!

In this workshop, we're going to learn Elm and Halogen side
by side so that we can explore the strengths and weaknesses 
of both approaches.

## App Description

We're going to stick with the tradition of exploring UI libraries
via writing a Todo List application, but instead of writing a full
TodoMVC style thing we're going to write a todo list that combined
some time tracking elements. 

We are working towards an app that presents the user with a todo list
where things can be added, completed in the usual way. Additionally,
each task displays how much time has been spent on a given task and
invites the user to start a time block on any of the active tasks.

![initialised app](./images/init.png?raw=true)

When the timer is started, time accrues against that active task as 
the timer counts down from 25 minutes. The idea of this time block
is to keep the user focused on that task, so the timer needs to finish
either when the 25 minutes are up or when the task is marked completed.

![running timer](./images/running.png?raw=true)

## Workshop Methodology

The way that I've planned this workshop is via a sequence of incremental
steps that build up to the app that we want. It was also my plan that 
you do the elm incremental update first, then do the halogen one and then 
reflect on the differences at that step. The good part about doing them side
by side is that we don't have to worry about running out of time and either
neglecting Elm or Halogen in the process.

This may not work for you because you either:
  - Don't care about one option and just want to learn either Elm or Halogen
  - Feel overwhelmed by doing two languages and frameworks at once
  - Want to do one fully before the other
  - Or you'd like to experiment with some other aspects of the libraries.

These steps are just a guide for how I thought people would best approach 
an exploration to these two things. If the guide doesn't work for you, feel
free to chop, change and do any permutation of this content that helps you
learn what you want to learn. 

As time progresses in the workshop, I will be working through the answers to
each step up on the projector. If you get stuck don't be afraid to stick your
hand up and ask me earlier, or you can also take a peek at the /halogen-final 
and /elm-final folders in this repo to peek at my final solution. 

- [Step 0 - Language Basics](./0-language.md)
- [Step 1 - Framework Basics](./1-framework.md)
- [Step 2 - Static Todo List](./2-static-todos.md)
- [Step 3 - New Task Input](./3-input.md)
- [Step 4 - Refactor](./4-refactor-todos.md)
- [Step 5 - Timer UI](./5-static-timer.md)
- [Step 6 - Timer Ticks](./6-ticker.md)
- [Step 7 - Start Timer From Todos](./7-start-timer.md)
- [Step 8 - Breaks](./8-breaks.md)
- [Step 9 - Fancier Todo List](./9-fancy-list.md)
- [Step ??? - And further ideas](./10-further.md)

## Appendices & Reference Material

- [Appendix A - Language Details & Differences](./A1-language.md)
- [Appendix B - MVI Details and Differences between Halogen and Elm](./A2-mvi.md)
- [Elm Core Docs](http://package.elm-lang.org/packages/elm-lang/core/latest)
- [Elm HTML Docs](http://package.elm-lang.org/packages/elm-lang/html/latest/)
- [Elm Tutorial](https://guide.elm-lang.org/core_language.html)
- [Purescript Prelude Docs](https://pursuit.purescript.org/packages/purescript-prelude/3.0.0)
- [Halogen Docs](https://pursuit.purescript.org/packages/purescript-halogen/2.0.1)
- [Purescript Book](https://leanpub.com/purescript/read)