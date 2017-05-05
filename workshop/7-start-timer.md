# 7 - Time Start

The point of this step is to start the timer from the todo list and have the passage of
the pomodoro accrue against the task.

Add a Millisseconds Elapsed onto Task and this additional UI:

```html
<li> <!-- apply the active class if this task is the current active todo accruing time -->
    <label></label>
    <button class="timer-start"></button> <!-- only show this on tasks that aren't completed -->
    <span class="time-spent">10:00:12</span> <!-- HH:MM:SS -->
</li>
```

There should be a onClick event that starts a pomodoro.

Once a pomodoro is started on a Task, tick events should accrue time against that task.