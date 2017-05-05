# 6 - Timer Ticks

We need to set up a Msg into Pomodoro that is a TimerTick Milliseconds that allows 
our reducers to observe the passage of time and update our pomodoro state /UI.

For elm, have a look at the Time module. There is a subscription called every
that allows you to send a message ever X period.

In Halogen, we have to do a Aff outside of the Ui and pass events in. Ben will explain this 
in person.

The timer should terminate when it hits 00:00.