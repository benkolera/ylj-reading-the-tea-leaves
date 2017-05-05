# 5 - Timer Static

This step, we will refactor main into a separate component that has two 
children: Todos (the one that we wrote before) & Pomodoro.

We are going to want a state of Maybe millisecondsRemaining that powers this DOM structure:

```html
<section class pomodoro>
    <!-- if there is currently no timer then show this -->
    <section class="timer-selector">
        <div class="timer-selector-msg">
            Please select a task below
        </div>
    </section>
    <!-- if there is a timer then show this -->
    <section class="timer">
        <span class="timer-minutes">25</span>
        <span class="timer-colon">:</span>
        <span class="timer-seconds>00</span>
    </section>
</section>
```

Stub the initial state with a timer with 25 minutes remaining to test it.

Do this in Elm and Purescript.